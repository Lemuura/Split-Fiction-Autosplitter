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

	Action<string, string> AddSetting = (name, id) =>
	{
		settings.Add(id, false, name);
	};

	AddSetting("Enable the in-game timer", 		"enableInGameTimer");
	AddSetting("Chapter Splits", 				"chapterSplits");
	AddSetting("Subchapter Splits", 			"subchapterSplits");
	AddSetting("Side Stories", 					"sideStories");

	settings.CurrentDefaultParent = 			"chapterSplits";
	AddSetting("Neon Revenge", 					"Skyline_Highway_Tutorial_BP##Tutorial");
	AddSetting("Hopes of Spring", 				"Tundra_Crack_Swamp_BP##Swamp_Caves");
	AddSetting("Final Dawn", 					"Island_Entrance_BP##Skydive");
	AddSetting("Rise of the Dragon Realm", 		"Summit_EggPath_BP##Entrance");
	AddSetting("Isolation", 					"Prison_Intro_BP##Outside_LevelStart");
	AddSetting("The Hollow", 					"Sanctuary_Upper_Tutorial_BP##Sanctuary Intro");
	AddSetting("Split", 						"Meltdown_SplitTraversal_BP##Split Traversal Intro");
	AddSetting("Defeating Rader", 				"SEQ_Meltdown_Battle_Phase3_ScreenPush -> None");

	settings.CurrentDefaultParent = 			"subchapterSplits";
	AddSetting("Rader Publishing", 				"raderPublishing");
	AddSetting("Neon Revenge", 					"neonRevenge");
	AddSetting("Hopes of Spring", 				"hopesOfSpring");
	AddSetting("Final Dawn", 					"finalDawn");
	AddSetting("Rise of the Dragon Realm", 		"dragonRealm");
	AddSetting("Isolation", 					"isolation");
	AddSetting("The Hollow", 					"hollow");
	AddSetting("Split", 						"split");

	settings.CurrentDefaultParent = 			"sideStories";
	AddSetting("Neon Revenge", 					"neonRevengeSS");
	AddSetting("Hopes of Spring", 				"hopesOfSpringSS");
	AddSetting("Final Dawn", 					"finalDawnSS");
	AddSetting("Rise of the Dragon Realm", 		"dragonRealmSS");

	settings.CurrentDefaultParent = 			"raderPublishing";
	AddSetting("Brave Knights", 				"Village_BP##Intro");

	settings.CurrentDefaultParent = 			"neonRevenge";
	AddSetting("Play Me Techno", 				"Skyline_DaClub_BP##DaClub Finding Sandfish");
	AddSetting("Hello, Mr. Hammer", 			"Skyline_Nightclub_Club_BP##Club Combat Entry");
	AddSetting("Streets of Neon", 				"Skyline_Nightclub_Alley_BP##Alley 0 - Start");
	AddSetting("Parking Garage", 				"Skyline_CarTower_BP##BallBoss_Chase_Intro");
	AddSetting("The Getaway Car", 				"Skyline_Chase_Tutorial_BP##Chase_Alley_Start");
	AddSetting("Big City Life", 				"Skyline_InnerCity_CarCrash_BP##CarCrash Site");
	AddSetting("Flipped Cityscapes", 			"Skyline_InnerCity_Limbo_BP##Limbo Intro");
	AddSetting("Gravity Bike", 					"Skyline_GravityBike_Tutorial_BP##Intro");
	AddSetting("Skyscraper Climb", 				"Skyline_Boss_Tutorial_BP##BikeTutorial 1");
	AddSetting("Head of the Crime Syndicate", 	"Skyline_Boss_V2_BP##Tank Phase 1 (No intro)");

	settings.CurrentDefaultParent = 			"neonRevengeSS";
	AddSetting("The Legend of the Sandfish", 	"Desert_SandFish_BP##Intro");
	AddSetting("Farmlife", 						"PigWorld_BP##Pigsty_Intro");
	AddSetting("Mountain Hike", 				"Summit_Giants_BP##IntroTraversalArea");

	settings.CurrentDefaultParent = 			"hopesOfSpring";
	AddSetting("Lord Evergreen", 				"Tundra_Crack_Swamp_BP##Swamp_Wetlands");
	AddSetting("Heart of the Forest", 			"Tundra_Crack_Evergreen_BP##Evergreen_Inside");
	AddSetting("Mother Earth", 					"Tundra_Crack_EvergreenSide_BP##SideSectionStart");
	AddSetting("Walking Stick of Doom", 		"Tundra_Crack_Forest_BP##CreepyForest");
	AddSetting("Silly Monkeys", 				"Tundra_River_MonkeyRealm_BP##MountainPath");
	AddSetting("It Takes Three to Tango", 		"Tundra_River_MonkeyRealm_BP##MonkeyConga");
	AddSetting("Halls of Ice", 					"None -> SEQ_Tundra_IcePalace_Outergate_Entering");
	AddSetting("The Ice King", 					"Tundra_River_IcePalace_BP##IceKing - Phase01");

	settings.CurrentDefaultParent = 			"hopesOfSpringSS";
	AddSetting("Train Heist", 					"Coast_TwistyTrain_BP##WingsuitIntro");
	AddSetting("Gameshow", 						"GameShowArena_BP##GameShowArena - Start");
	AddSetting("Collapsing Star", 				"SolarFlare_BP##SolarFlare_Intro");

	settings.CurrentDefaultParent = 			"finalDawn";
	AddSetting("Infiltration", 					"Island_Stormdrain_BP##Start");
	AddSetting("Gun Upgrade", 					"Island_Stormdrain_BP##WeaponUpgradeStation");
	AddSetting("Toxic Tumblers", 				"Island_Stormdrain_BP##SpinningHallway");
	AddSetting("Factory Entrance", 				"Island_Rift_BP##Hallway");
	AddSetting("Factory Exterior", 				"Island_Rift_BP##Cable House");
	AddSetting("Test Chamber", 					"Island_Rift_BP##Walker Arena");
	AddSetting("Run and Gun", 					"Island_Tower_Sidescroller_BP##Sidescroller_Intro");
	AddSetting("The Overseer", 					"Island_Tower_Sidescroller_BossFight_BP##Overseer_Entry");
	AddSetting("Soaring Desperados", 			"Island_Tower_Sidescroller_Jetpack_BP##Jetpack_Tutorial");
	AddSetting("The Escape", 					"Island_Escape_BP##Inner Tower");
	AddSetting("System Fail Safe Mode", 		"RedSpace_BP##BeforeRedspace");

	settings.CurrentDefaultParent = 			"finalDawnSS";
	AddSetting("Kites", 						"KiteTown_BP##Intro");
	AddSetting("Moon Market", 					"MoonMarket_BP##Intro");
	AddSetting("Notebook", 						"Sketchbook_BP##Intro");

	settings.CurrentDefaultParent = 			"dragonRealm";
	AddSetting("Water Temple", 					"Summit_WaterTempleInner_Raft_BP##SlowRaftStart");
	AddSetting("Dragon Riders Unite", 			"Summit_CraftApproach_BP##Water Volcano");
	AddSetting("The Dragon Slayer", 			"None -> SEQ_Summit_CraftTemple_KnightArena_Intro");
	AddSetting("Craft Temple", 					"Summit_CraftTemple_BP##CraftTemple_Start");
	AddSetting("Dragon Souls", 					"Summit_CraftTemple_BP##CraftTemple_DarkCaveEntrance");
	AddSetting("Treasure Temple", 				"Summit_TreasureTemple_BP##Gauntlet");
	AddSetting("Royal Palace", 					"Summit_TreasureTemple_BP##TopDown");
	AddSetting("Treasure Traitor", 				"Summit_TreasureTemple_BP##Decimator");
	AddSetting("Might of Dragons", 				"Summit_StormSiegeIntro_BP##Intro_Tutorial");
	AddSetting("Into the Storm", 				"Summit_StormSiegeChase_BP##Intro");
	AddSetting("Megalith's Wrath", 				"Summit_StormSiegeFinale_BP##Summit_StormSiegeFinale_FallingDebris");

	settings.CurrentDefaultParent = 			"dragonRealmSS";
	AddSetting("Slopes of War", 				"Battlefield_BP##Battlefield_Intro");
	AddSetting("Space Escape", 					"SpaceWalk_BP##SpaceWalk_Indoor");
	AddSetting("Birthday Cake", 				"DentistNightmare_BP##Intro");

	settings.CurrentDefaultParent = 			"isolation";
	AddSetting("Handy Drones", 					"Prison_Drones_Maintenance_BP##Drones_LevelStart");
	AddSetting("Down the Rabbit Hole", 			"Prison_Drones_InBetween_01_BP##InBetween_Slide");
	AddSetting("Hydration Facility", 			"Prison_Drones_Cooling_BP##Cooling_Start_NoIntro");
	AddSetting("Prison Courtyard", 				"Prison_Drones_Stealth_Outdoor_BP##Stealth_Intro");
	AddSetting("Pinball Lock", 					"Prison_Drones_Pinball_BP##Pinball_Start");
	AddSetting("Execution Arena", 				"Prison_Arena_BP##Intro");
	AddSetting("Waste Depot", 					"Prison_GarbageRoom_BP##GarbageRoom_Slide");
	AddSetting("Cell Blocks", 					"Prison_TrashCompactor_BP##TrashCompactor_Top");
	AddSetting("Maximum Security", 				"Prison_MaxSecurity_BP##MaxSecurity_Intro");
	AddSetting("The Prisoner", 					"Prison_Boss_BP##Intro");

	settings.CurrentDefaultParent = 			"hollow";
	AddSetting("Mosaic of Memories", 			"Sanctuary_Upper_BP##Upper WatchTower");
	AddSetting("Ghost Town", 					"Sanctuary_DiscSlide_BP##DiscSlide_Start");
	AddSetting("Light in the Dark", 			"Sanctuary_Below_CrackApproach_BP##CrackApproach_DrawBridge");
	AddSetting("Spiritual Guides", 				"Sanctuary_Centipede_Tutorial_BP##Centipede_StartRoom");
	AddSetting("The Hydra", 					"Sanctuary_Boss_Medallion_BP##Hydra Reveal Intro");

	settings.CurrentDefaultParent = 			"split";
	AddSetting("A Warm Greeting", 				"Meltdown_SplitTraversal_BP##Split Traversal Bridge Entrance");
	AddSetting("Face-to-Face", 					"Meltdown_BossBattleFirstPhase_BP##Boss phase Start");
	AddSetting("Worlds Apart", 					"Meltdown_SoftSplit_BP##Soft Split Start");
	AddSetting("Cross Section", 				"Meltdown_SplitBonanza_BP##Split Bonanza Start");
	AddSetting("Fight a God", 					"Meltdown_BossBattleSecondPhase_BP##BossBattlePhase Lava");
	AddSetting("A New Perspective", 			"Meltdown_ScreenWalk_BP##Meltdown ScreenWalk Intro");
	AddSetting("Outside the Box", 				"Meltdown_WorldSpin_Fullscreen_BP##WorldSpin Cutscene Intro");
	AddSetting("Final Showdown", 				"Meltdown_BossBattleThirdPhase_BP##BossBattlePhaseThree First Phase ");
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
					new MemoryWatcher<int>(new DeepPointer(GWorld, 0x1D8, 0x300, 0x0, 0x430, 0x368, 0x2b0, 0x18)) { Name = "SequenceName", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull, Current = 0},

					// GWorld.GameInstance.SingletonObjects[78(UGlobalMenuSingleton)].Padding
					// Padding is always FF899701107998FF
					// new MemoryWatcher<IntPtr>(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x30)) { Name = "Padding"},
					new MemoryWatcher<bool>(vars.bDisplayTimerDP) { Name = "bDisplayTimer"},
					new MemoryWatcher<double>(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x40)) { Name = "GameSessionTimer", Current = 0},
					new MemoryWatcher<bool>(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x58)) { Name = "bGameIsLoading", Current = true},
					new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x60, 0x0), 255) { Name = "CurrentChapter", Current = ""}, 					// This string is localized
					//new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x80 + 0x0, 0x0), 255) { Name = "CurrentChapterRef.InLevel"}, // Going to use this one instead
					//new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x3E0, 0x78, 0x80 + 0x10, 0x0), 255) { Name = "CurrentChapterRef.Name"},
					new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x298, 0xF8, 0x0), 255) { Name = "ProgressPoint.InLevel", Current = ""}, 
					new StringWatcher(new DeepPointer(GWorld, 0x1D8, 0x298, 0x108, 0x0), 255) { Name = "ProgressPoint.Name", Current = ""},
				
				};
			}

			if (FNamePool == IntPtr.Zero && (FNamePool = scanner.Scan(FNamePoolTrg)) != IntPtr.Zero)
			{
				vars.FNamePool = FNamePool;
				vars.Log("Found FNamePool at 0x" + FNamePool.ToString("X") + ".");
			}

			if (GWorld != IntPtr.Zero && FNamePool != IntPtr.Zero)
			{
				vars.Data.UpdateAll(game);
				vars.Log("SequenceName: " + vars.FNameToString(vars.Data["SequenceName"].Current));
				vars.Log("CurrentChapter: " + vars.Data["CurrentChapter"].Current);
				vars.Log("ProgressPoint: " + vars.Data["ProgressPoint.InLevel"].Current + "##" + vars.Data["ProgressPoint.Name"].Current);

				current.InLevelShort = vars.Data["ProgressPoint.InLevel"].Current;
				int lastIndex = current.InLevelShort.LastIndexOf('/');
				if (lastIndex != -1)
				{
					current.InLevelShort = current.InLevelShort.Substring(lastIndex + 1);
				}

				current.ProgressPoint = current.InLevelShort + "##" + vars.Data["ProgressPoint.Name"].Current;

				vars.Log("ProgressPoint: " + current.ProgressPoint);
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

	var ids = new List<string>();

	if (vars.Data["SequenceName"].Changed)
	{
		ids.Add(vars.FNameToString(vars.Data["SequenceName"].Old) + " -> " + vars.FNameToString(vars.Data["SequenceName"].Current));
	}
	
	if (current.InLevelShort != old.InLevelShort)
	{
		ids.Add(current.InLevelShort);
	}

	if (current.ProgressPoint != old.ProgressPoint)
	{
		ids.Add(current.ProgressPoint);
	}

	foreach (var id in ids)
	{
		if (settings.ContainsKey(id) && settings[id])
		{
			vars.Log("Split! " + id);
			return true;
		}
	}

}