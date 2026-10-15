// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Questopia';

  @override
  String get home => 'Home';

  @override
  String get catalog => 'Catalog';

  @override
  String get settings => 'Settings';

  @override
  String get play => 'Play';

  @override
  String get installedGames => 'Installed games';

  @override
  String get favoriteGames => 'Favorites';

  @override
  String get saves => 'Saves';

  @override
  String get cheatModes => 'Cheat modes';

  @override
  String get search => 'Search games...';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get amoledTheme => 'AMOLED';

  @override
  String get fontSize => 'Font Size';

  @override
  String get gameFolder => 'Game Folder';

  @override
  String get importGame => 'Import Game';

  @override
  String get exportSave => 'Export Save';

  @override
  String get importSave => 'Import Save';

  @override
  String get autoSave => 'Auto-Save';

  @override
  String get restart => 'Restart';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get variables => 'Variables';

  @override
  String get locks => 'Locks';

  @override
  String get teleport => 'Teleport';

  @override
  String get inventory => 'Inventory';

  @override
  String get tabGame => 'Game';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabInventory => 'Inventory';

  @override
  String get console => 'Console';

  @override
  String get diff => 'Diff';

  @override
  String get download => 'Download';

  @override
  String get delete => 'Delete';

  @override
  String get downloading => 'Downloading...';

  @override
  String get addGame => 'Add Game';

  @override
  String get emptyLibraryHint =>
      'No games in your library yet.\nDownload from Catalog or import a folder.';

  @override
  String get fileOrArchive => 'File or Archive';

  @override
  String get fileOrArchiveHint => '.qsp, .gam, .zip, .rar, .aqsp, .7z';

  @override
  String get selectFolder => 'Select folder';

  @override
  String pageOf(int page, int total) {
    return 'Page $page of $total';
  }

  @override
  String get retry => 'Retry';

  @override
  String get prev => 'Prev';

  @override
  String get next => 'Next';

  @override
  String get noCatalogItems => 'No catalog items available.';

  @override
  String downloadedGame(String title) {
    return 'Downloaded $title';
  }

  @override
  String get searchOnlineCatalog => 'Search online catalog...';

  @override
  String get allLanguages => 'All Languages';

  @override
  String get featured => 'Featured';

  @override
  String get sortCatalog => 'Sort Catalog';

  @override
  String get selectGameFolder => 'Select Game Folder';

  @override
  String get selectGameFileOrArchive => 'Select Game File or Archive';

  @override
  String unsupportedGameFormat(Object ext) {
    return 'Selected file is not a supported game format (.$ext). Please select a .qsp, .gam, or archive file.';
  }

  @override
  String importedGame(String title) {
    return 'Imported $title';
  }

  @override
  String importFailed(String reason) {
    return 'Import failed: $reason';
  }

  @override
  String gameFileNotFound(String path) {
    return 'Game file not found at $path. Folder may have been moved or storage permission revoked.';
  }

  @override
  String get importGameTooltip => 'Import game';

  @override
  String get gameOptionsTooltip => 'Game Options';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionGeneral => 'General';

  @override
  String get sectionTypography => 'Typography';

  @override
  String get sectionMedia => 'Media and images';

  @override
  String get sectionSound => 'Sound';

  @override
  String get sectionStorage => 'Storage';

  @override
  String get sectionAbout => 'About';

  @override
  String get colorAccent => 'Color accent';

  @override
  String get language => 'Language';

  @override
  String get followSystem => 'Follow system';

  @override
  String get immersiveMode => 'Immersive mode';

  @override
  String get autoscroll => 'Auto-scroll';

  @override
  String get separatorLine => 'Separator line';

  @override
  String get edgeFeedback => 'Edge feedback';

  @override
  String get navBarBlur => 'Navigation bar blur';

  @override
  String get autoSaveInterval => 'Auto-save interval';

  @override
  String get clicks => 'clicks';

  @override
  String get cheatEngine => 'Cheat engine';

  @override
  String get qspCommandLine => 'QSP command line';

  @override
  String get actionsPanelHeight => 'Actions panel height';

  @override
  String get binaryPrefixes => 'Binary prefixes';

  @override
  String get typeface => 'Typeface';

  @override
  String get useGameFont => 'Use game font';

  @override
  String get customTextColor => 'Custom text color';

  @override
  String get textColor => 'Text color';

  @override
  String get customBackgroundColor => 'Custom background color';

  @override
  String get backgroundColor => 'Background color';

  @override
  String get customLinkColor => 'Custom link color';

  @override
  String get linkColor => 'Link color';

  @override
  String get disableImages => 'Disable images';

  @override
  String get showAllImagesDialog => 'Show all images in dialog';

  @override
  String get pinchZoom => 'Pinch zoom';

  @override
  String get fullscreenImages => 'Fullscreen image viewer';

  @override
  String get autoWidth => 'Auto image width';

  @override
  String get imageWidth => 'Image width';

  @override
  String get autoHeight => 'Auto image height';

  @override
  String get imageHeight => 'Image height';

  @override
  String get playSound => 'Play sound';

  @override
  String get muteVideoAudio => 'Mute video audio';

  @override
  String get gamesFolder => 'Games folder';

  @override
  String get defaultInternalFolder => 'Default internal folder';

  @override
  String get version => 'Version';

  @override
  String get openSourceLicenses => 'Open source licenses';

  @override
  String get themeModeTitle => 'Theme Mode';

  @override
  String get colorAccentTitle => 'Color Accent';

  @override
  String get languageTitle => 'Application Language';

  @override
  String get actionsHeightTitle => 'Actions Panel Height';

  @override
  String get binaryPrefixesTitle => 'Binary Prefixes';

  @override
  String get binaryKiB => 'Binary / KiB';

  @override
  String get decimalKB => 'Decimal / KB';

  @override
  String get livePreview => 'LIVE PREVIEW';

  @override
  String get livePreviewText =>
      'You stand at the gates of an ancient castle. The heavy oak doors are sealed shut with iron runes.';

  @override
  String get accentDynamic => 'Dynamic';

  @override
  String get accentBlue => 'Blue';

  @override
  String get accentGreen => 'Green';

  @override
  String get accentOrange => 'Orange';

  @override
  String get accentPurple => 'Purple';

  @override
  String get accentPink => 'Pink';

  @override
  String get accentTeal => 'Teal';

  @override
  String get accentAmber => 'Amber';

  @override
  String get accentMonochrome => 'Monochrome';

  @override
  String get fontDefaultSystem => 'Default system';

  @override
  String get fontSansSerif => 'Sans-serif';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMonospace => 'Monospace';

  @override
  String get fontMedium => 'Medium';

  @override
  String get fontCursive => 'Cursive';

  @override
  String get fontLight => 'Light';

  @override
  String get fontCondensed => 'Condensed';

  @override
  String get fontBlack => 'Black';

  @override
  String get fontThin => 'Thin';

  @override
  String get fontCasual => 'Casual';

  @override
  String get fontSerifMonospace => 'Serif monospace';

  @override
  String get exitGameTitle => 'Exit Game';

  @override
  String get exitGameMessage =>
      'Are you sure you want to exit the game? Any unsaved progress will be lost.';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get deleteAllGamesTitle => 'Delete All Installed Games';

  @override
  String get deleteAllGamesMessage =>
      'Are you sure you want to delete all installed games from your library? This action cannot be undone.';

  @override
  String get readingTheme => 'Reading theme';

  @override
  String get readingThemeDefault => 'Default';

  @override
  String get readingThemeSepia => 'Sepia';

  @override
  String get readingThemeNight => 'Night';

  @override
  String get readingThemeHighContrast => 'High contrast';

  @override
  String get readingThemeMaterialYou => 'Material You';

  @override
  String get storageUsage => 'Storage usage';

  @override
  String get storageTotal => 'Total used';

  @override
  String get storageCleanup => 'Clean up unused files';

  @override
  String get storageCleanupHint =>
      'Removes leftover folders that contain no game file.';

  @override
  String storageCleanupFreed(String size) {
    return 'Reclaimed $size';
  }

  @override
  String get storageNothingToClean => 'Nothing to clean up';

  @override
  String get storageCalculating => 'Calculating...';

  @override
  String get ok => 'OK';

  @override
  String get apply => 'Apply';

  @override
  String get remove => 'Remove';

  @override
  String get save => 'Save';

  @override
  String get load => 'Load';

  @override
  String get input => 'Input';

  @override
  String get choose => 'Choose';

  @override
  String get run => 'Run';

  @override
  String get add => 'Add';

  @override
  String get scan => 'Scan';

  @override
  String get overwrite => 'Overwrite';

  @override
  String get restore => 'Restore';

  @override
  String get maximize => 'Maximize';

  @override
  String get minimize => 'Minimize';

  @override
  String get dismiss => 'Dismiss';

  @override
  String lockedTo(String value) {
    return 'Locked to $value';
  }

  @override
  String get emptyStringValue => '(empty string)';

  @override
  String slotTitle(int index) {
    return 'Slot $index';
  }

  @override
  String pageOfPages(int page, int total) {
    return 'Page $page / $total';
  }

  @override
  String savedGameToSlot(int index) {
    return 'Saved game to Slot $index';
  }

  @override
  String teleportedTo(String location) {
    return 'Teleported to $location';
  }

  @override
  String editVarTitle(String name) {
    return 'Edit $name';
  }

  @override
  String searchVariablesHint(int count) {
    return 'Search variables ($count found)...';
  }

  @override
  String get loadingGameWorld => 'Loading game world...';

  @override
  String get notFound => 'Not found';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get couldNotOpenSaveFile => 'Could not open save file';

  @override
  String get imageOptions => 'Image Options';

  @override
  String get copyImage => 'Copy image';

  @override
  String get saveToGallery => 'Save to gallery';

  @override
  String get searchImageOnYandex => 'Search image on Yandex';

  @override
  String get imageReferenceCopied => 'Image reference copied';

  @override
  String get couldNotCopyImage => 'Could not copy the image';

  @override
  String get imageSavedToGallery => 'Image saved to gallery';

  @override
  String get couldNotSaveImage => 'Could not save the image';

  @override
  String get openingYandexSearch => 'Opening Yandex image search';

  @override
  String get couldNotOpenYandexSearch => 'Could not open Yandex search';

  @override
  String get videoPreview => 'Video Preview';

  @override
  String get imagePreview => 'Image Preview';

  @override
  String get options => 'Options';

  @override
  String get qspConsole => 'QSP Console';

  @override
  String get qspCodeHint => 'QSP code...';

  @override
  String get qspStatementHint => 'QSP statement...';

  @override
  String get noOutputYet => 'No output yet';

  @override
  String get qspConsoleReady =>
      'QSP Console ready.\nEnter statements like: money += 500 or goto \'start\'';

  @override
  String get restartGameTitle => 'Restart game?';

  @override
  String get restartGameMessage => 'Unsaved progress will be lost.';

  @override
  String get engineError => 'Engine Error';

  @override
  String get unknownEngineError => 'Unknown engine error';

  @override
  String errorNumber(int number, String description) {
    return 'Error #$number: $description';
  }

  @override
  String errorLocation(String name) {
    return 'Location: $name';
  }

  @override
  String errorLine(int number) {
    return 'Line: $number';
  }

  @override
  String errorCode(String code) {
    return 'Code: $code';
  }

  @override
  String get noOptions => 'No options';

  @override
  String get openSaveFile => 'Open Save File';

  @override
  String get openSaveFileHint => 'Pick an external .sav file to load.';

  @override
  String get pickFile => 'Pick File';

  @override
  String get message => 'Message';

  @override
  String get qspInteractiveFiction => 'QSP Interactive Fiction';

  @override
  String get gameOptions => 'Game Options';

  @override
  String get saveAndLoad => 'Save and Load';

  @override
  String get cheatEngineAndEditor => 'Cheat Engine and Editor';

  @override
  String get restartGame => 'Restart Game';

  @override
  String get savesAndSlots => 'Saves and Slots';

  @override
  String get selectSlotToSave => 'Select Slot to Save';

  @override
  String get selectSlotToLoad => 'Select Slot to Load';

  @override
  String get autoSaveSlot => 'Auto-Save Slot';

  @override
  String get lastSavedSessionAvailable => 'Last saved session available';

  @override
  String get noAutoSaveDataFound => 'No auto-save data found';

  @override
  String get savedGameState => 'Saved Game State';

  @override
  String get emptySlot => 'Empty Slot';

  @override
  String get importSav => 'Import .sav';

  @override
  String get exportSav => 'Export .sav';

  @override
  String get saveImported => 'Save file imported successfully';

  @override
  String get saveImportFailed => 'Failed to import save file';

  @override
  String get noActiveSaveData => 'No active save data to export';

  @override
  String get saveFileExported => 'Save file exported';

  @override
  String get exportSaveFileDialog => 'Export Save File';

  @override
  String get newValue => 'New Value';

  @override
  String get engineRejectedValue => 'Engine rejected the value';

  @override
  String get teleportFailed => 'Teleport failed';

  @override
  String get itemAdded => 'Item added';

  @override
  String get couldNotAddItem => 'Could not add item';

  @override
  String get couldNotRemoveItem => 'Could not remove item';

  @override
  String get jumpToLocationHint =>
      'Jump to a specific QSP location in the story.';

  @override
  String get locationNameHint => 'Location name (e.g. start, room, shop)...';

  @override
  String get newItemNameHint => 'New item name...';

  @override
  String get addVariableHint => 'Add variable to watch...';

  @override
  String get scanAllVariables => 'Scan all game variables';

  @override
  String get lockValue => 'Lock value';

  @override
  String get unlock => 'Unlock';

  @override
  String get editValue => 'Edit value';

  @override
  String get noVariablesFound => 'No variables found';

  @override
  String get noLockedVariables => 'No locked variables active';

  @override
  String get noSnapshotYet => 'No snapshot yet. Changes will appear here.';

  @override
  String get noChangesSinceSnapshot => 'No changes since snapshot';

  @override
  String get consoleFailed => 'Failed';

  @override
  String get previousSessionCrashed => 'Previous Session Crashed';

  @override
  String get crashIntro =>
      'Questopia encountered an unhandled error in the last run. You can copy the diagnostic details below to report it.';

  @override
  String get crashLogCopied => 'Crash log copied to clipboard';

  @override
  String get copyDetails => 'Copy Details';

  @override
  String get closeSearch => 'Close search';

  @override
  String get refreshCatalog => 'Refresh catalog';

  @override
  String get showAllGames => 'Show all games';

  @override
  String get showFavoritesOnly => 'Show favorites only';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get deleteGame => 'Delete game';

  @override
  String get removeFromLibrary => 'Remove from library';

  @override
  String get deleteGameTitle => 'Delete Game';

  @override
  String deleteGameMessage(String title) {
    return 'Permanently delete \"$title\" and all its files from your device?\n\nThis action cannot be undone.';
  }

  @override
  String removeFromLibraryMessage(String title) {
    return 'Remove \"$title\" from your library?\n\nNote: Game files on your device will NOT be deleted.';
  }

  @override
  String get couldNotReachRepository => 'Could not reach the repository.';

  @override
  String get noGamesYet => 'No games found';

  @override
  String get noStatusInformation => 'No status information available';

  @override
  String get inventoryIsEmpty => 'Inventory is empty';

  @override
  String get sortComments => 'Comments';

  @override
  String get sortName => 'Name';

  @override
  String get sortUpdated => 'Updated';

  @override
  String get sortCreated => 'Added';

  @override
  String get sortLikes => 'Likes';

  @override
  String get sortDownloads => 'Downloads';

  @override
  String get sortPlays => 'Plays';

  @override
  String get gameNotes => 'Game Notes';

  @override
  String get notesEmptyTitle => 'No notes yet';

  @override
  String get notesEmptyHint =>
      'Write down clues, codes, or puzzle solutions. Notes are kept for this game only.';

  @override
  String get notesHint => 'Write your notes here...';

  @override
  String get notesSaved => 'Notes saved';

  @override
  String get notesDiscardTitle => 'Unsaved Notes';

  @override
  String get notesDiscardMessage => 'You have unsaved changes. Discard them?';

  @override
  String get notesDiscard => 'Discard';

  @override
  String get notesKeepEditing => 'Keep editing';

  @override
  String notesTabDefaultTitle(int index) {
    return 'Note $index';
  }

  @override
  String get notesAddTab => 'New note';

  @override
  String get notesRenameTab => 'Rename note';

  @override
  String get notesRenameTabTitle => 'Rename Note';

  @override
  String get notesRenameTabHint => 'Note name';

  @override
  String get notesRenameTabEmpty => 'A note needs a name';

  @override
  String get notesDeleteTab => 'Delete note';

  @override
  String get notesDeleteTabTitle => 'Delete Note';

  @override
  String notesDeleteTabMessage(String title) {
    return 'Delete \"$title\" and its text? This cannot be undone.';
  }

  @override
  String get notesLastTabHint => 'At least one note must stay open';

  @override
  String get notesUntitledTab => 'Untitled note';

  @override
  String get notesSwitchDiscardTitle => 'Unsaved Changes';

  @override
  String get notesSwitchDiscardMessage =>
      'This note has unsaved changes. Discard them and switch?';

  @override
  String get notesSwitchDiscard => 'Switch and discard';

  @override
  String get notesTabSaved => 'Note saved';

  @override
  String get playStats => 'Play Statistics';

  @override
  String get playStatsTotal => 'Total play time';

  @override
  String get playStatsLast => 'Last played';

  @override
  String get playStatsNever => 'Never played';

  @override
  String get neverPlayed => 'Never played';

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String durationSeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String get saveTimeJustNow => 'Just now';

  @override
  String saveTimeMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String saveTimeHoursAgo(int hours) {
    return '$hours h ago';
  }

  @override
  String get saveTimeYesterday => 'Yesterday';

  @override
  String saveTimeDaysAgo(int days) {
    return '$days d ago';
  }

  @override
  String get emptySlotHint => 'No save data';

  @override
  String get searchHistoryTitle => 'Recent searches';

  @override
  String get searchHistoryClearAll => 'Clear all';

  @override
  String get searchHistoryClearTitle => 'Clear Search History';

  @override
  String get searchHistoryClearMessage =>
      'Remove all saved search queries from the catalog?';

  @override
  String get searchHistoryRemove => 'Remove from history';

  @override
  String get searchHistoryCleared => 'Search history cleared';

  @override
  String get languageAuto => 'Automatic';

  @override
  String untitledRemoteGame(String id) {
    return 'Game #$id';
  }

  @override
  String get onboardingWelcomeTitle => 'Welcome to Questopia';

  @override
  String get onboardingWelcomeBody =>
      'Your home for QSP interactive fiction. Import your games, pick up where you left off, and shape the app the way you like it.';

  @override
  String get onboardingLanguageTitle => 'Choose your language';

  @override
  String get onboardingLanguageBody => 'You can change this later in Settings.';

  @override
  String get onboardingThemeTitle => 'Pick a theme';

  @override
  String get onboardingThemeBody =>
      'Choose the look that is easiest on your eyes.';

  @override
  String get onboardingAccentTitle => 'Pick an accent color';

  @override
  String get onboardingAccentBody =>
      'Dynamic follows your system wallpaper on supported devices.';

  @override
  String get onboardingReadingTitle => 'Reading comfort';

  @override
  String get onboardingReadingBody =>
      'Set how large the game text appears and how the reading surface looks.';

  @override
  String get onboardingReadingFontSize => 'Text size';

  @override
  String get onboardingBehaviorTitle => 'Gameplay and helpers';

  @override
  String get onboardingBehaviorBody =>
      'Turn on the reading and input helpers you want from the start.';

  @override
  String get onboardingFinishTitle => 'You are all set';

  @override
  String get onboardingFinishBody =>
      'These choices are saved. You can change any of them later in Settings.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingRestart => 'Show setup again';

  @override
  String get onboardingRestartHint => 'Run the first time setup wizard again';
}
