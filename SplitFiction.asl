state("SplitFiction"){}
state("SplitFiction_Trial"){}

startup
{
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var timingMessage = MessageBox.Show(
			"This game uses IGT as the main timing method.\n"
			+ "LiveSplit is currently set to show Real Time (RTA).\n"
			+ "Would you like to set the timing method to IGT?",
			"Split Fiction | LiveSplit",
			MessageBoxButtons.YesNo, MessageBoxIcon.Question
		);
		if (timingMessage == DialogResult.Yes)
		{
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}

	
	vars.AccumulatedSessionTime = 0d;

	string LOGFILE = "Logs/SplitFiction.log";
	if (!File.Exists(LOGFILE))
    {
        Directory.CreateDirectory("Logs");
        File.Create(LOGFILE);
    }

	Func<object, bool> WriteLog = (data) =>
    {
        using (StreamWriter wr = new StreamWriter(LOGFILE, true)) {
            wr.WriteLine(
                DateTime.Now.ToString(@"HH\:mm\:ss.fff") + (timer != null && timer.CurrentTime.GameTime.HasValue ? 
                " | " + timer.CurrentTime.GameTime.Value.ToString("G").Substring(3, 11) : "") + ": " + data);
        }
        print("[SplitFiction] " + data);
        return true;
    };
    vars.Log = WriteLog;

	settings.Add("enableInGameTimer", false, "Enable the in-game timer");
}

init
{
	vars.CancelSource = new CancellationTokenSource();
	vars.ScanThread = new Thread(() =>
	{
		vars.Log("Starting scan thread.");

		var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);
		var token = vars.CancelSource.Token;

		var GWorld = IntPtr.Zero; 
		var GWorldTrg = new SigScanTarget(3, "48 8B 15 ???????? 49 8D 4F ?? 4C 8B C8")
		{ OnFound = (p, s, ptr) => ptr + 0x4 + p.ReadValue<int>(ptr)};

		var FNamePool = IntPtr.Zero; 
		var FNamePoolTrg = new SigScanTarget(7, "8B D9 74 ?? 48 8D 15 ???????? EB")
		{ OnFound = (p, s, ptr) => ptr + 0x4 + p.ReadValue<int>(ptr)};
		
		while (!token.IsCancellationRequested)
		{
			if (GWorld == IntPtr.Zero && (GWorld = scanner.Scan(GWorldTrg)) != IntPtr.Zero)
			{
				vars.Log("Found GWorld at 0x" + GWorld.ToString("X") + ".");

				vars.bDisplayTimerDP = new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x38);

				vars.Data = new MemoryWatcherList
				{
					new StringWatcher(new DeepPointer(GWorld, 0x5C8, 0x0), 255) { Name = "Level"},

					// GWorld.GameInstance.PlayerCharacters[0(Mio)].ActiveLevelSequenceActor.SequencePlayer.Sequence.Name
					new MemoryWatcher<int>(new DeepPointer(GWorld, 0x1D8, 0x300, 0x0, 0x430, 0x368, 0x2b0, 0x18)) { Name = "SequenceName", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull},

					// GWorld.GameInstance.SingletonObjects[78(UGlobalMenuSingleton)].Padding
					// Padding is always FF899701107998FF
					// new MemoryWatcher<IntPtr>(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x30)) { Name = "Padding"},
					new MemoryWatcher<bool>(vars.bDisplayTimerDP) { Name = "bDisplayTimer"},
					new MemoryWatcher<double>(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x40)) { Name = "GameSessionTimer"},
					new MemoryWatcher<bool>(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x58)) { Name = "bGameIsLoading"},
					new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x60, 0x0), 255) { Name = "CurrentChapter"},
					new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x80 + 0x0, 0x0), 255) { Name = "CurrentChapterRef.InLevel"},
					new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x80 + 0x10, 0x0), 255) { Name = "CurrentChapterRef.Name"},
				};

				vars.Data.UpdateAll(game);
			}

			if (FNamePool == IntPtr.Zero && (FNamePool = scanner.Scan(FNamePoolTrg)) != IntPtr.Zero)
			{
				vars.FNamePool = FNamePool;
				vars.Log("Found FNamePool at 0x" + FNamePool.ToString("X") + ".");
			}

			if (GWorld != IntPtr.Zero && FNamePool != IntPtr.Zero)
			{
				break;
			}

			vars.Log("Sleeping...");
			Thread.Sleep(2000);
		}

		vars.Log("Exiting scan thread.");
	});

	vars.ScanThread.Start();

	vars.FNamePool = IntPtr.Zero;
	Func<int, string> FNameToString = (comparisonIndex) =>
	{
		if (vars.FNamePool == IntPtr.Zero)
		{
			return null;
		}

		var blockIndex = comparisonIndex >> 16;
		var blockOffset = 2 * (comparisonIndex & 0xFFFF);
		var headerPtr = new DeepPointer(vars.FNamePool + blockIndex * 8 + 0x10, blockOffset);

		byte[] headerBytes = null;
		if (headerPtr.DerefBytes(game, 2, out headerBytes))
		{
			bool isWide = (headerBytes[0] & 0x01) != 0;
			int length = (headerBytes[1] << 2) | ((headerBytes[0] & 0xC0) >> 6);

			IntPtr headerRawPtr;
			if (headerPtr.DerefOffsets(game, out headerRawPtr))
			{
				var stringPtr = new DeepPointer(headerRawPtr + 2);
				ReadStringType stringType = isWide ? ReadStringType.UTF16 : ReadStringType.ASCII;
				int numBytes = length * (isWide ? 2 : 1);

				string str;
				if (stringPtr.DerefString(game, stringType, numBytes, out str))
				{
					return str;
				}
			}
		}

		return null;
	};

	Func<string, string> GetObjectNameFromObjectPath = (objectPath) =>
	{
		if (objectPath == null)
		{
			return null;
		}

		int lastDotIndex = objectPath.LastIndexOf('.');
		if (lastDotIndex == -1)
		{
			return objectPath;
		}

		return objectPath.Substring(lastDotIndex + 1);
	};

	Func<int, string> GetObjectNameFromFName = (comparisonIndex) =>
	{
		return GetObjectNameFromObjectPath(FNameToString(comparisonIndex));
	};
	vars.GetObjectNameFromFName = GetObjectNameFromFName;
	vars.FNameToString = FNameToString;
}

update
{
    if (vars.ScanThread.IsAlive) return false;

	vars.Data.UpdateAll(game);

	if (settings["enableInGameTimer"] && !vars.Data["bDisplayTimer"].Current)
	{
		vars.Log("Enabling in-game timer.");
		IntPtr bDisplayTimerPtr;
		vars.bDisplayTimerDP.DerefOffsets(game, out bDisplayTimerPtr);
		game.WriteValue<bool>(bDisplayTimerPtr, true); 
	}

	if (vars.Data["SequenceName"].Changed)
	{
		vars.Log("SequenceName changed: Old: " + vars.FNameToString(vars.Data["SequenceName"].Old) + " -> New: " + vars.FNameToString(vars.Data["SequenceName"].Current));
	}

	if (vars.Data["CurrentChapter"].Changed)
	{
		vars.Log("CurrentChapter changed: Old: " + vars.Data["CurrentChapter"].Old + " -> New: " + vars.Data["CurrentChapter"].Current);
	}

	if (vars.Data["CurrentChapterRef.InLevel"].Changed || vars.Data["CurrentChapterRef.Name"].Changed)
	{
		vars.Log("CurrentChapterRef changed: Old: " + vars.Data["CurrentChapterRef.InLevel"].Old + "##" + vars.Data["CurrentChapterRef.Name"].Old + 
				" -> New: " + vars.Data["CurrentChapterRef.InLevel"].Current + "##" + vars.Data["CurrentChapterRef.Name"].Current);
	}

}

isLoading
{
	return true;
}

start
{
	return vars.Data["GameSessionTimer"].Current > 0.000d && vars.Data["GameSessionTimer"].Old <= 0.000d;
}

exit
{
	timer.IsGameTimePaused = true;
}

onReset
{
	vars.AccumulatedSessionTime = 0;
}

onStart
{
	vars.AccumulatedSessionTime = 0;
}

gameTime
{
	var GameSessionTimer = vars.Data["GameSessionTimer"];

	if (GameSessionTimer.Current <= 0.000d && GameSessionTimer.Old > 0.000d)
	{
		vars.AccumulatedSessionTime += GameSessionTimer.Old;
	}

	return TimeSpan.FromSeconds(vars.AccumulatedSessionTime + GameSessionTimer.Current);
}