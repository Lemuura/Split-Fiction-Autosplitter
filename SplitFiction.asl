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

	settings.Add("chapterSplits", false, "Chapter Splits");
	settings.Add("subchapterSplits", false, "Subchapter Splits");
	settings.Add("sideStories", false, "Side Stories");

	settings.Add("Skyline_Highway_Tutorial_BP##Tutorial", false, "Neon Revenge", "chapterSplits"); 
	settings.Add("Tundra_Crack_Swamp_BP##Swamp_Caves", false, "Hopes of Spring", "chapterSplits"); 
	settings.Add("Island_Entrance_BP##Skydive", false, "Final Dawn", "chapterSplits");
	settings.Add("Summit_EggPath_BP##Entrance", false, "Rise of the Dragon Realm", "chapterSplits");
	settings.Add("Prison_Intro_BP##Outside_LevelStart", false, "Isolation", "chapterSplits");
	settings.Add("Sanctuary_Upper_Tutorial_BP##Sanctuary Intro", false, "The Hollow", "chapterSplits");
	settings.Add("Meltdown_SplitTraversal_BP##Split Traversal Intro", false, "Split", "chapterSplits");
	settings.Add("SEQ_Meltdown_Battle_Phase3_ScreenPush -> None", false, "Defeating Rader", "chapterSplits");

	
	settings.Add("raderPublishing", false, "Rader Publishing", "subchapterSplits");
	settings.Add("Village_BP##Intro", false, "Start of Brave Knights", "raderPublishing");

	settings.Add("neonRevenge", false, "Neon Revenge", "subchapterSplits");
	settings.Add("Skyline_DaClub_BP##DaClub Finding Sandfish", false, "Play Me Techno", "neonRevenge");
	settings.Add("Skyline_Nightclub_Club_BP##Club Combat Entry", false, "Hello, Mr. Hammer", "neonRevenge");
	settings.Add("Skyline_Nightclub_Alley_BP##Alley 0 - Start", false, "Streets of Neon", "neonRevenge");
	settings.Add("Skyline_CarTower_BP##BallBoss_Chase_Intro", false, "Parking Garage", "neonRevenge");
	settings.Add("Skyline_Chase_Tutorial_BP##Chase_Alley_Start", false, "The Getaway Car", "neonRevenge");
	settings.Add("Skyline_InnerCity_CarCrash_BP##CarCrash Site", false, "Big City Life", "neonRevenge");
	settings.Add("Skyline_InnerCity_Limbo_BP##Limbo Intro", false, "Flipped Cityscapes", "neonRevenge");
	settings.Add("Skyline_GravityBike_Tutorial_BP##Intro", false, "Gravity Bike", "neonRevenge");
	settings.Add("Skyline_Boss_Tutorial_BP##BikeTutorial 1", false, "Skyscraper Climb", "neonRevenge");
	settings.Add("Skyline_Boss_V2_BP##Tank Phase 1", false, "Head of the Crime Syndicate", "neonRevenge");

	settings.Add("neonRevengeSS", false, "Neon Revenge", "sideStories");
	settings.Add("Desert_SandFish_BP##Intro", false, "The Legend of the Sandfish", "neonRevengeSS");
	settings.Add("PigWorld_BP##Pigsty_Intro", false, "Farmlife", "neonRevengeSS");
	settings.Add("Summit_Giants_BP##IntroTraversalArea", false, "Mountain Hike", "neonRevengeSS");


	settings.Add("hopesOfSpring", false, "Hopes of Spring", "subchapterSplits");
	settings.Add("Tundra_Crack_Swamp_BP##Swamp_Wetlands", false, "Lord Evergreen", "hopesOfSpring");
	settings.Add("Tundra_Crack_Evergreen_BP##Evergreen_Inside", false, "Heart of the Forest", "hopesOfSpring");
	settings.Add("Tundra_Crack_EvergreenSide_BP##SideSectionStart", false, "Mother Earth", "hopesOfSpring");
	settings.Add("Tundra_Crack_Forest_BP##CreepyForest", false, "Walking Stick of Doom", "hopesOfSpring");
	settings.Add("Tundra_River_MonkeyRealm_BP##MountainPath", false, "Silly Monkeys", "hopesOfSpring");
	settings.Add("Tundra_River_MonkeyRealm_BP##MonkeyConga", false, "It Takes Three to Tango", "hopesOfSpring");
	settings.Add("Tundra_River_IcePalace_BP##IcePalace - Start", false, "Halls of Ice", "hopesOfSpring");
	settings.Add("Tundra_River_IcePalace_BP##IceKing - Phase01", false, "The Ice King", "hopesOfSpring");

	settings.Add("hopesOfSpringSS", false, "Hopes of Spring", "sideStories");
	settings.Add("Coast_TwistyTrain_BP##WingsuitIntro", false, "Train Heist", "hopesOfSpringSS");
	settings.Add("GameShowArena_BP##GameShowArena - Start", false, "Gameshow", "hopesOfSpringSS");
	settings.Add("SolarFlare_BP##SolarFlare_Intro", false, "Collapsing Star", "hopesOfSpringSS");


	settings.Add("finalDawn", false, "Final Dawn", "subchapterSplits");
	settings.Add("Island_Stormdrain_BP##Start", false, "Infiltration", "finalDawn");
	settings.Add("Island_Stormdrain_BP##WeaponUpgradeStation", false, "Gun Upgrade", "finalDawn");
	settings.Add("Island_Stormdrain_BP##SpinningHallway", false, "Toxic Tumblers", "finalDawn");
	settings.Add("Island_Rift_BP##Hallway", false, "Factory Entrance", "finalDawn");
	settings.Add("Island_Rift_BP##Cable House", false, "Factory Exterior", "finalDawn");
	settings.Add("Island_Rift_BP##Walker Arena", false, "Test Chamber", "finalDawn");
	settings.Add("Island_Tower_Sidescroller_BP##Sidescroller_Intro", false, "Run and Gun", "finalDawn");
	settings.Add("Island_Tower_Sidescroller_BossFight_BP##Overseer_Entry", false, "The Overseer", "finalDawn");
	settings.Add("Island_Tower_Sidescroller_Jetpack_BP##Jetpack_Tutorial", false, "Soaring Desperados", "finalDawn");
	settings.Add("Island_Escape_BP##Inner Tower", false, "The Escape", "finalDawn");
	settings.Add("RedSpace_BP##BeforeRedspace", false, "System Fail Safe Mode", "finalDawn");

	settings.Add("finalDawnSS", false, "Final Dawn", "sideStories");
	settings.Add("KiteTown_BP##Intro", false, "Kites", "finalDawnSS");
	settings.Add("MoonMarket_BP##Intro", false, "Moon Market", "finalDawnSS");
	settings.Add("Sketchbook_BP##Intro", false, "Notebook", "finalDawnSS");


	settings.Add("dragonRealm", false, "Rise of the Dragon Realm", "subchapterSplits");
	settings.Add("Summit_WaterTempleInner_Raft_BP##SlowRaftStart", false, "Water Temple", "dragonRealm");
	settings.Add("Summit_CraftApproach_BP##Water Volcano", false, "Dragon Riders Unite", "dragonRealm");
	settings.Add("Summit_CraftApproach_RubyKnight_BP##Ruby Knight Intro", false, "The Dragon Slayer", "dragonRealm");
	settings.Add("Summit_CraftTemple_BP##CraftTemple_Start", false, "Craft Temple", "dragonRealm");
	settings.Add("Summit_CraftTemple_BP##CraftTemple_DarkCaveEntrance", false, "Dragon Souls", "dragonRealm");
	settings.Add("Summit_TreasureTemple_BP##Gauntlet", false, "Treasure Temple", "dragonRealm");
	settings.Add("Summit_TreasureTemple_BP##TopDown", false, "Royal Palace", "dragonRealm");
	settings.Add("Summit_TreasureTemple_BP##Decimator", false, "Treasure Traitor", "dragonRealm");
	settings.Add("Summit_StormSiegeIntro_BP##Intro_Tutorial", false, "Might of Dragons", "dragonRealm");
	settings.Add("Summit_StormSiegeChase_BP##Intro", false, "Into the Storm", "dragonRealm");
	settings.Add("Summit_StormSiegeFinale_BP##Summit_StormSiegeFinale_FallingDebris", false, "Megalith's Wrath", "dragonRealm");

	settings.Add("dragonRealmSS", false, "Rise of the Dragon Realm", "sideStories");
	settings.Add("Battlefield_BP##Battlefield_Intro", false, "Slopes of War", "dragonRealmSS");
	settings.Add("SpaceWalk_BP##SpaceWalk_Indoor", false, "Space Escape", "dragonRealmSS");
	settings.Add("DentistNightmare_BP##Intro", false, "Birthday Cake", "dragonRealmSS");


	settings.Add("isolation", false, "Isolation", "subchapterSplits");
	settings.Add("Prison_Drones_Maintenance_BP##Drones_LevelStart", false, "Handy Drones", "isolation");
	settings.Add("Prison_Drones_InBetween_01_BP##InBetween_Slide", false, "Down the Rabbit Hole", "isolation");
	settings.Add("Prison_Drones_Cooling_BP##Cooling_Start", false, "Hydration Facility", "isolation");
	settings.Add("Prison_Drones_Stealth_Outdoor_BP##Stealth_Intro", false, "Prison Courtyard", "isolation");
	settings.Add("Prison_Drones_Pinball_BP##Pinball_Start", false, "Pinball Lock", "isolation");
	settings.Add("Prison_Arena_BP##Intro", false, "Execution Arena", "isolation");
	settings.Add("Prison_GarbageRoom_BP##GarbageRoom_Slide", false, "Waste Depot", "isolation");
	settings.Add("Prison_TrashCompactor_BP##TrashCompactor_Top", false, "Cell Blocks", "isolation");
	settings.Add("Prison_MaxSecurity_BP##MaxSecurity_Intro", false, "Maximum Security", "isolation");
	settings.Add("Prison_Boss_BP##Intro", false, "The Prisoner", "isolation");

	
	settings.Add("hollow", false, "The Hollow", "subchapterSplits");
	settings.Add("Sanctuary_Upper_BP##Upper WatchTower", false, "Mosaic of Memories", "hollow");
	settings.Add("Sanctuary_DiscSlide_BP##DiscSlide_Start", false, "Ghost Town", "hollow");
	settings.Add("Sanctuary_Below_CrackApproach_BP##CrackApproach_DrawBridge", false, "Light in the Dark", "hollow");
	settings.Add("Sanctuary_Centipede_Tutorial_BP##Centipede_StartRoom", false, "Spiritual Guides", "hollow");
	settings.Add("Sanctuary_Boss_Medallion_BP##Hydra Reveal Intro", false, "The Hydra", "hollow");

	
	settings.Add("split", false, "Split", "subchapterSplits");
	settings.Add("Meltdown_SplitTraversal_BP##Split Traversal Bridge Entrance", false, "A Warm Greeting", "split");
	settings.Add("Meltdown_BossBattleFirstPhase_BP##Boss phase Start", false, "Face-to-Face", "split");
	settings.Add("Meltdown_SoftSplit_BP##Soft Split Start", false, "Worlds Apart", "split");
	settings.Add("Meltdown_SplitBonanza_BP##Split Bonanza Start", false, "Cross Section", "split");
	settings.Add("Meltdown_BossBattleSecondPhase_BP##BossBattlePhase Lava", false, "Fight a God", "split");
	settings.Add("Meltdown_ScreenWalk_BP##Meltdown ScreenWalk Intro", false, "A New Perspective", "split");
	settings.Add("Meltdown_WorldSpin_Fullscreen_BP##WorldSpin Cutscene Intro", false, "Outside the Box", "split");
	settings.Add("Meltdown_BossBattleThirdPhase_BP##BossBattlePhaseThree First Phase ", false, "Final Showdown", "split");

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
					new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x60, 0x0), 255) { Name = "CurrentChapter"}, 					// This string is localized
					//new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x80 + 0x0, 0x0), 255) { Name = "CurrentChapterRef.InLevel"}, // Going to use this one instead
					//new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x80 + 0x10, 0x0), 255) { Name = "CurrentChapterRef.Name"},
					new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x298, 0xF8, 0x0), 255) { Name = "ProgressPoint.InLevel"}, 
					new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x298, 0x108, 0x0), 255) { Name = "ProgressPoint.Name"},
				
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
	current.InLevelShort = "";
	current.ProgressPoint = "";
}

update
{
    if (vars.ScanThread.IsAlive) return false;

	vars.Data.UpdateAll(game);

	if (settings["enableInGameTimer"] && !vars.Data["bDisplayTimer"].Current)
	{
		// vars.Log("Enabling in-game timer.");
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

	if (vars.Data["ProgressPoint.InLevel"].Changed || vars.Data["ProgressPoint.Name"].Changed)
	{
		vars.Log("ProgressPoint changed: Old: " + vars.Data["ProgressPoint.InLevel"].Old + "##" + vars.Data["ProgressPoint.Name"].Old + 
				" -> New: " + vars.Data["ProgressPoint.InLevel"].Current + "##" + vars.Data["ProgressPoint.Name"].Current);

		current.InLevelShort = vars.Data["ProgressPoint.InLevel"].Current;
		int lastIndex = current.InLevelShort.LastIndexOf('/');
		if (lastIndex != -1)
		{
			current.InLevelShort = current.InLevelShort.Substring(lastIndex + 1);
		}

		// Using this format to match SaveData.Split
		current.ProgressPoint = current.InLevelShort + "##" + vars.Data["ProgressPoint.Name"].Current;

		vars.Log("ProgressPoint: " + current.ProgressPoint);
	}

}

isLoading
{
	return true;

	// return vars.Data["bGameIsLoading"].Current;
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

	if (GameSessionTimer.Current > GameSessionTimer.Old)
	{
		vars.AccumulatedSessionTime += (GameSessionTimer.Current - GameSessionTimer.Old);
	}

	return TimeSpan.FromSeconds(vars.AccumulatedSessionTime);
}

split
{

	if (vars.Data["SequenceName"].Changed && 
		settings[vars.FNameToString(vars.Data["SequenceName"].Old) + " -> " + vars.FNameToString(vars.Data["SequenceName"].Current)])
	{
		return true;
	}
	
	if (current.InLevelShort != old.InLevelShort &&
		settings[current.InLevelShort])
	{
		return true;
	}

	if (current.ProgressPoint != old.ProgressPoint &&
		settings[current.ProgressPoint])
	{
		return true;
	}

}