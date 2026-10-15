import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Questopia'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @catalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalog;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @installedGames.
  ///
  /// In en, this message translates to:
  /// **'Installed games'**
  String get installedGames;

  /// No description provided for @favoriteGames.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoriteGames;

  /// No description provided for @saves.
  ///
  /// In en, this message translates to:
  /// **'Saves'**
  String get saves;

  /// No description provided for @cheatModes.
  ///
  /// In en, this message translates to:
  /// **'Cheat modes'**
  String get cheatModes;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search games...'**
  String get search;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @amoledTheme.
  ///
  /// In en, this message translates to:
  /// **'AMOLED'**
  String get amoledTheme;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @gameFolder.
  ///
  /// In en, this message translates to:
  /// **'Game Folder'**
  String get gameFolder;

  /// No description provided for @importGame.
  ///
  /// In en, this message translates to:
  /// **'Import Game'**
  String get importGame;

  /// No description provided for @exportSave.
  ///
  /// In en, this message translates to:
  /// **'Export Save'**
  String get exportSave;

  /// No description provided for @importSave.
  ///
  /// In en, this message translates to:
  /// **'Import Save'**
  String get importSave;

  /// No description provided for @autoSave.
  ///
  /// In en, this message translates to:
  /// **'Auto-Save'**
  String get autoSave;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @variables.
  ///
  /// In en, this message translates to:
  /// **'Variables'**
  String get variables;

  /// No description provided for @locks.
  ///
  /// In en, this message translates to:
  /// **'Locks'**
  String get locks;

  /// No description provided for @teleport.
  ///
  /// In en, this message translates to:
  /// **'Teleport'**
  String get teleport;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @tabGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get tabGame;

  /// No description provided for @tabStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tabStatus;

  /// No description provided for @tabInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get tabInventory;

  /// No description provided for @console.
  ///
  /// In en, this message translates to:
  /// **'Console'**
  String get console;

  /// No description provided for @diff.
  ///
  /// In en, this message translates to:
  /// **'Diff'**
  String get diff;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @addGame.
  ///
  /// In en, this message translates to:
  /// **'Add Game'**
  String get addGame;

  /// No description provided for @emptyLibraryHint.
  ///
  /// In en, this message translates to:
  /// **'No games in your library yet.\nDownload from Catalog or import a folder.'**
  String get emptyLibraryHint;

  /// No description provided for @fileOrArchive.
  ///
  /// In en, this message translates to:
  /// **'File or Archive'**
  String get fileOrArchive;

  /// No description provided for @fileOrArchiveHint.
  ///
  /// In en, this message translates to:
  /// **'.qsp, .gam, .zip, .rar, .aqsp, .7z'**
  String get fileOrArchiveHint;

  /// No description provided for @selectFolder.
  ///
  /// In en, this message translates to:
  /// **'Select folder'**
  String get selectFolder;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {total}'**
  String pageOf(int page, int total);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get prev;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noCatalogItems.
  ///
  /// In en, this message translates to:
  /// **'No catalog items available.'**
  String get noCatalogItems;

  /// No description provided for @downloadedGame.
  ///
  /// In en, this message translates to:
  /// **'Downloaded {title}'**
  String downloadedGame(String title);

  /// No description provided for @searchOnlineCatalog.
  ///
  /// In en, this message translates to:
  /// **'Search online catalog...'**
  String get searchOnlineCatalog;

  /// No description provided for @allLanguages.
  ///
  /// In en, this message translates to:
  /// **'All Languages'**
  String get allLanguages;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @sortCatalog.
  ///
  /// In en, this message translates to:
  /// **'Sort Catalog'**
  String get sortCatalog;

  /// No description provided for @selectGameFolder.
  ///
  /// In en, this message translates to:
  /// **'Select Game Folder'**
  String get selectGameFolder;

  /// No description provided for @selectGameFileOrArchive.
  ///
  /// In en, this message translates to:
  /// **'Select Game File or Archive'**
  String get selectGameFileOrArchive;

  /// No description provided for @unsupportedGameFormat.
  ///
  /// In en, this message translates to:
  /// **'Selected file is not a supported game format (.{ext}). Please select a .qsp, .gam, or archive file.'**
  String unsupportedGameFormat(Object ext);

  /// No description provided for @importedGame.
  ///
  /// In en, this message translates to:
  /// **'Imported {title}'**
  String importedGame(String title);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {reason}'**
  String importFailed(String reason);

  /// No description provided for @gameFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Game file not found at {path}. Folder may have been moved or storage permission revoked.'**
  String gameFileNotFound(String path);

  /// No description provided for @importGameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Import game'**
  String get importGameTooltip;

  /// No description provided for @gameOptionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Game Options'**
  String get gameOptionsTooltip;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @sectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sectionGeneral;

  /// No description provided for @sectionTypography.
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get sectionTypography;

  /// No description provided for @sectionMedia.
  ///
  /// In en, this message translates to:
  /// **'Media and images'**
  String get sectionMedia;

  /// No description provided for @sectionSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sectionSound;

  /// No description provided for @sectionStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get sectionStorage;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @colorAccent.
  ///
  /// In en, this message translates to:
  /// **'Color accent'**
  String get colorAccent;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @immersiveMode.
  ///
  /// In en, this message translates to:
  /// **'Immersive mode'**
  String get immersiveMode;

  /// No description provided for @autoscroll.
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll'**
  String get autoscroll;

  /// No description provided for @separatorLine.
  ///
  /// In en, this message translates to:
  /// **'Separator line'**
  String get separatorLine;

  /// No description provided for @edgeFeedback.
  ///
  /// In en, this message translates to:
  /// **'Edge feedback'**
  String get edgeFeedback;

  /// No description provided for @navBarBlur.
  ///
  /// In en, this message translates to:
  /// **'Navigation bar blur'**
  String get navBarBlur;

  /// No description provided for @autoSaveInterval.
  ///
  /// In en, this message translates to:
  /// **'Auto-save interval'**
  String get autoSaveInterval;

  /// No description provided for @clicks.
  ///
  /// In en, this message translates to:
  /// **'clicks'**
  String get clicks;

  /// No description provided for @cheatEngine.
  ///
  /// In en, this message translates to:
  /// **'Cheat engine'**
  String get cheatEngine;

  /// No description provided for @qspCommandLine.
  ///
  /// In en, this message translates to:
  /// **'QSP command line'**
  String get qspCommandLine;

  /// No description provided for @actionsPanelHeight.
  ///
  /// In en, this message translates to:
  /// **'Actions panel height'**
  String get actionsPanelHeight;

  /// No description provided for @binaryPrefixes.
  ///
  /// In en, this message translates to:
  /// **'Binary prefixes'**
  String get binaryPrefixes;

  /// No description provided for @typeface.
  ///
  /// In en, this message translates to:
  /// **'Typeface'**
  String get typeface;

  /// No description provided for @useGameFont.
  ///
  /// In en, this message translates to:
  /// **'Use game font'**
  String get useGameFont;

  /// No description provided for @customTextColor.
  ///
  /// In en, this message translates to:
  /// **'Custom text color'**
  String get customTextColor;

  /// No description provided for @textColor.
  ///
  /// In en, this message translates to:
  /// **'Text color'**
  String get textColor;

  /// No description provided for @customBackgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Custom background color'**
  String get customBackgroundColor;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get backgroundColor;

  /// No description provided for @customLinkColor.
  ///
  /// In en, this message translates to:
  /// **'Custom link color'**
  String get customLinkColor;

  /// No description provided for @linkColor.
  ///
  /// In en, this message translates to:
  /// **'Link color'**
  String get linkColor;

  /// No description provided for @disableImages.
  ///
  /// In en, this message translates to:
  /// **'Disable images'**
  String get disableImages;

  /// No description provided for @showAllImagesDialog.
  ///
  /// In en, this message translates to:
  /// **'Show all images in dialog'**
  String get showAllImagesDialog;

  /// No description provided for @pinchZoom.
  ///
  /// In en, this message translates to:
  /// **'Pinch zoom'**
  String get pinchZoom;

  /// No description provided for @fullscreenImages.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen image viewer'**
  String get fullscreenImages;

  /// No description provided for @autoWidth.
  ///
  /// In en, this message translates to:
  /// **'Auto image width'**
  String get autoWidth;

  /// No description provided for @imageWidth.
  ///
  /// In en, this message translates to:
  /// **'Image width'**
  String get imageWidth;

  /// No description provided for @autoHeight.
  ///
  /// In en, this message translates to:
  /// **'Auto image height'**
  String get autoHeight;

  /// No description provided for @imageHeight.
  ///
  /// In en, this message translates to:
  /// **'Image height'**
  String get imageHeight;

  /// No description provided for @playSound.
  ///
  /// In en, this message translates to:
  /// **'Play sound'**
  String get playSound;

  /// No description provided for @muteVideoAudio.
  ///
  /// In en, this message translates to:
  /// **'Mute video audio'**
  String get muteVideoAudio;

  /// No description provided for @gamesFolder.
  ///
  /// In en, this message translates to:
  /// **'Games folder'**
  String get gamesFolder;

  /// No description provided for @defaultInternalFolder.
  ///
  /// In en, this message translates to:
  /// **'Default internal folder'**
  String get defaultInternalFolder;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get openSourceLicenses;

  /// No description provided for @themeModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeModeTitle;

  /// No description provided for @colorAccentTitle.
  ///
  /// In en, this message translates to:
  /// **'Color Accent'**
  String get colorAccentTitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Language'**
  String get languageTitle;

  /// No description provided for @actionsHeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Actions Panel Height'**
  String get actionsHeightTitle;

  /// No description provided for @binaryPrefixesTitle.
  ///
  /// In en, this message translates to:
  /// **'Binary Prefixes'**
  String get binaryPrefixesTitle;

  /// No description provided for @binaryKiB.
  ///
  /// In en, this message translates to:
  /// **'Binary / KiB'**
  String get binaryKiB;

  /// No description provided for @decimalKB.
  ///
  /// In en, this message translates to:
  /// **'Decimal / KB'**
  String get decimalKB;

  /// No description provided for @livePreview.
  ///
  /// In en, this message translates to:
  /// **'LIVE PREVIEW'**
  String get livePreview;

  /// No description provided for @livePreviewText.
  ///
  /// In en, this message translates to:
  /// **'You stand at the gates of an ancient castle. The heavy oak doors are sealed shut with iron runes.'**
  String get livePreviewText;

  /// No description provided for @accentDynamic.
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get accentDynamic;

  /// No description provided for @accentBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get accentBlue;

  /// No description provided for @accentGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get accentGreen;

  /// No description provided for @accentOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get accentOrange;

  /// No description provided for @accentPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get accentPurple;

  /// No description provided for @accentPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get accentPink;

  /// No description provided for @accentTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get accentTeal;

  /// No description provided for @accentAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get accentAmber;

  /// No description provided for @accentMonochrome.
  ///
  /// In en, this message translates to:
  /// **'Monochrome'**
  String get accentMonochrome;

  /// No description provided for @fontDefaultSystem.
  ///
  /// In en, this message translates to:
  /// **'Default system'**
  String get fontDefaultSystem;

  /// No description provided for @fontSansSerif.
  ///
  /// In en, this message translates to:
  /// **'Sans-serif'**
  String get fontSansSerif;

  /// No description provided for @fontSerif.
  ///
  /// In en, this message translates to:
  /// **'Serif'**
  String get fontSerif;

  /// No description provided for @fontMonospace.
  ///
  /// In en, this message translates to:
  /// **'Monospace'**
  String get fontMonospace;

  /// No description provided for @fontMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fontMedium;

  /// No description provided for @fontCursive.
  ///
  /// In en, this message translates to:
  /// **'Cursive'**
  String get fontCursive;

  /// No description provided for @fontLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get fontLight;

  /// No description provided for @fontCondensed.
  ///
  /// In en, this message translates to:
  /// **'Condensed'**
  String get fontCondensed;

  /// No description provided for @fontBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get fontBlack;

  /// No description provided for @fontThin.
  ///
  /// In en, this message translates to:
  /// **'Thin'**
  String get fontThin;

  /// No description provided for @fontCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get fontCasual;

  /// No description provided for @fontSerifMonospace.
  ///
  /// In en, this message translates to:
  /// **'Serif monospace'**
  String get fontSerifMonospace;

  /// No description provided for @exitGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Game'**
  String get exitGameTitle;

  /// No description provided for @exitGameMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the game? Any unsaved progress will be lost.'**
  String get exitGameMessage;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @deleteAllGamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete All Installed Games'**
  String get deleteAllGamesTitle;

  /// No description provided for @deleteAllGamesMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all installed games from your library? This action cannot be undone.'**
  String get deleteAllGamesMessage;

  /// No description provided for @readingTheme.
  ///
  /// In en, this message translates to:
  /// **'Reading theme'**
  String get readingTheme;

  /// No description provided for @readingThemeDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get readingThemeDefault;

  /// No description provided for @readingThemeSepia.
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get readingThemeSepia;

  /// No description provided for @readingThemeNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get readingThemeNight;

  /// No description provided for @readingThemeHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get readingThemeHighContrast;

  /// No description provided for @readingThemeMaterialYou.
  ///
  /// In en, this message translates to:
  /// **'Material You'**
  String get readingThemeMaterialYou;

  /// No description provided for @storageUsage.
  ///
  /// In en, this message translates to:
  /// **'Storage usage'**
  String get storageUsage;

  /// No description provided for @storageTotal.
  ///
  /// In en, this message translates to:
  /// **'Total used'**
  String get storageTotal;

  /// No description provided for @storageCleanup.
  ///
  /// In en, this message translates to:
  /// **'Clean up unused files'**
  String get storageCleanup;

  /// No description provided for @storageCleanupHint.
  ///
  /// In en, this message translates to:
  /// **'Removes leftover folders that contain no game file.'**
  String get storageCleanupHint;

  /// No description provided for @storageCleanupFreed.
  ///
  /// In en, this message translates to:
  /// **'Reclaimed {size}'**
  String storageCleanupFreed(String size);

  /// No description provided for @storageNothingToClean.
  ///
  /// In en, this message translates to:
  /// **'Nothing to clean up'**
  String get storageNothingToClean;

  /// No description provided for @storageCalculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get storageCalculating;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @load.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get load;

  /// No description provided for @input.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get input;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @run.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get run;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @overwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @maximize.
  ///
  /// In en, this message translates to:
  /// **'Maximize'**
  String get maximize;

  /// No description provided for @minimize.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get minimize;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @lockedTo.
  ///
  /// In en, this message translates to:
  /// **'Locked to {value}'**
  String lockedTo(String value);

  /// No description provided for @emptyStringValue.
  ///
  /// In en, this message translates to:
  /// **'(empty string)'**
  String get emptyStringValue;

  /// No description provided for @slotTitle.
  ///
  /// In en, this message translates to:
  /// **'Slot {index}'**
  String slotTitle(int index);

  /// No description provided for @pageOfPages.
  ///
  /// In en, this message translates to:
  /// **'Page {page} / {total}'**
  String pageOfPages(int page, int total);

  /// No description provided for @savedGameToSlot.
  ///
  /// In en, this message translates to:
  /// **'Saved game to Slot {index}'**
  String savedGameToSlot(int index);

  /// No description provided for @teleportedTo.
  ///
  /// In en, this message translates to:
  /// **'Teleported to {location}'**
  String teleportedTo(String location);

  /// No description provided for @editVarTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String editVarTitle(String name);

  /// No description provided for @searchVariablesHint.
  ///
  /// In en, this message translates to:
  /// **'Search variables ({count} found)...'**
  String searchVariablesHint(int count);

  /// No description provided for @loadingGameWorld.
  ///
  /// In en, this message translates to:
  /// **'Loading game world...'**
  String get loadingGameWorld;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @couldNotOpenSaveFile.
  ///
  /// In en, this message translates to:
  /// **'Could not open save file'**
  String get couldNotOpenSaveFile;

  /// No description provided for @imageOptions.
  ///
  /// In en, this message translates to:
  /// **'Image Options'**
  String get imageOptions;

  /// No description provided for @copyImage.
  ///
  /// In en, this message translates to:
  /// **'Copy image'**
  String get copyImage;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery'**
  String get saveToGallery;

  /// No description provided for @searchImageOnYandex.
  ///
  /// In en, this message translates to:
  /// **'Search image on Yandex'**
  String get searchImageOnYandex;

  /// No description provided for @imageReferenceCopied.
  ///
  /// In en, this message translates to:
  /// **'Image reference copied'**
  String get imageReferenceCopied;

  /// No description provided for @couldNotCopyImage.
  ///
  /// In en, this message translates to:
  /// **'Could not copy the image'**
  String get couldNotCopyImage;

  /// No description provided for @imageSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery'**
  String get imageSavedToGallery;

  /// No description provided for @couldNotSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Could not save the image'**
  String get couldNotSaveImage;

  /// No description provided for @openingYandexSearch.
  ///
  /// In en, this message translates to:
  /// **'Opening Yandex image search'**
  String get openingYandexSearch;

  /// No description provided for @couldNotOpenYandexSearch.
  ///
  /// In en, this message translates to:
  /// **'Could not open Yandex search'**
  String get couldNotOpenYandexSearch;

  /// No description provided for @videoPreview.
  ///
  /// In en, this message translates to:
  /// **'Video Preview'**
  String get videoPreview;

  /// No description provided for @imagePreview.
  ///
  /// In en, this message translates to:
  /// **'Image Preview'**
  String get imagePreview;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @qspConsole.
  ///
  /// In en, this message translates to:
  /// **'QSP Console'**
  String get qspConsole;

  /// No description provided for @qspCodeHint.
  ///
  /// In en, this message translates to:
  /// **'QSP code...'**
  String get qspCodeHint;

  /// No description provided for @qspStatementHint.
  ///
  /// In en, this message translates to:
  /// **'QSP statement...'**
  String get qspStatementHint;

  /// No description provided for @noOutputYet.
  ///
  /// In en, this message translates to:
  /// **'No output yet'**
  String get noOutputYet;

  /// No description provided for @qspConsoleReady.
  ///
  /// In en, this message translates to:
  /// **'QSP Console ready.\nEnter statements like: money += 500 or goto \'start\''**
  String get qspConsoleReady;

  /// No description provided for @restartGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart game?'**
  String get restartGameTitle;

  /// No description provided for @restartGameMessage.
  ///
  /// In en, this message translates to:
  /// **'Unsaved progress will be lost.'**
  String get restartGameMessage;

  /// No description provided for @engineError.
  ///
  /// In en, this message translates to:
  /// **'Engine Error'**
  String get engineError;

  /// No description provided for @unknownEngineError.
  ///
  /// In en, this message translates to:
  /// **'Unknown engine error'**
  String get unknownEngineError;

  /// No description provided for @errorNumber.
  ///
  /// In en, this message translates to:
  /// **'Error #{number}: {description}'**
  String errorNumber(int number, String description);

  /// No description provided for @errorLocation.
  ///
  /// In en, this message translates to:
  /// **'Location: {name}'**
  String errorLocation(String name);

  /// No description provided for @errorLine.
  ///
  /// In en, this message translates to:
  /// **'Line: {number}'**
  String errorLine(int number);

  /// No description provided for @errorCode.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String errorCode(String code);

  /// No description provided for @noOptions.
  ///
  /// In en, this message translates to:
  /// **'No options'**
  String get noOptions;

  /// No description provided for @openSaveFile.
  ///
  /// In en, this message translates to:
  /// **'Open Save File'**
  String get openSaveFile;

  /// No description provided for @openSaveFileHint.
  ///
  /// In en, this message translates to:
  /// **'Pick an external .sav file to load.'**
  String get openSaveFileHint;

  /// No description provided for @pickFile.
  ///
  /// In en, this message translates to:
  /// **'Pick File'**
  String get pickFile;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @qspInteractiveFiction.
  ///
  /// In en, this message translates to:
  /// **'QSP Interactive Fiction'**
  String get qspInteractiveFiction;

  /// No description provided for @gameOptions.
  ///
  /// In en, this message translates to:
  /// **'Game Options'**
  String get gameOptions;

  /// No description provided for @saveAndLoad.
  ///
  /// In en, this message translates to:
  /// **'Save and Load'**
  String get saveAndLoad;

  /// No description provided for @cheatEngineAndEditor.
  ///
  /// In en, this message translates to:
  /// **'Cheat Engine and Editor'**
  String get cheatEngineAndEditor;

  /// No description provided for @restartGame.
  ///
  /// In en, this message translates to:
  /// **'Restart Game'**
  String get restartGame;

  /// No description provided for @savesAndSlots.
  ///
  /// In en, this message translates to:
  /// **'Saves and Slots'**
  String get savesAndSlots;

  /// No description provided for @selectSlotToSave.
  ///
  /// In en, this message translates to:
  /// **'Select Slot to Save'**
  String get selectSlotToSave;

  /// No description provided for @selectSlotToLoad.
  ///
  /// In en, this message translates to:
  /// **'Select Slot to Load'**
  String get selectSlotToLoad;

  /// No description provided for @autoSaveSlot.
  ///
  /// In en, this message translates to:
  /// **'Auto-Save Slot'**
  String get autoSaveSlot;

  /// No description provided for @lastSavedSessionAvailable.
  ///
  /// In en, this message translates to:
  /// **'Last saved session available'**
  String get lastSavedSessionAvailable;

  /// No description provided for @noAutoSaveDataFound.
  ///
  /// In en, this message translates to:
  /// **'No auto-save data found'**
  String get noAutoSaveDataFound;

  /// No description provided for @savedGameState.
  ///
  /// In en, this message translates to:
  /// **'Saved Game State'**
  String get savedGameState;

  /// No description provided for @emptySlot.
  ///
  /// In en, this message translates to:
  /// **'Empty Slot'**
  String get emptySlot;

  /// No description provided for @importSav.
  ///
  /// In en, this message translates to:
  /// **'Import .sav'**
  String get importSav;

  /// No description provided for @exportSav.
  ///
  /// In en, this message translates to:
  /// **'Export .sav'**
  String get exportSav;

  /// No description provided for @saveImported.
  ///
  /// In en, this message translates to:
  /// **'Save file imported successfully'**
  String get saveImported;

  /// No description provided for @saveImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to import save file'**
  String get saveImportFailed;

  /// No description provided for @noActiveSaveData.
  ///
  /// In en, this message translates to:
  /// **'No active save data to export'**
  String get noActiveSaveData;

  /// No description provided for @saveFileExported.
  ///
  /// In en, this message translates to:
  /// **'Save file exported'**
  String get saveFileExported;

  /// No description provided for @exportSaveFileDialog.
  ///
  /// In en, this message translates to:
  /// **'Export Save File'**
  String get exportSaveFileDialog;

  /// No description provided for @newValue.
  ///
  /// In en, this message translates to:
  /// **'New Value'**
  String get newValue;

  /// No description provided for @engineRejectedValue.
  ///
  /// In en, this message translates to:
  /// **'Engine rejected the value'**
  String get engineRejectedValue;

  /// No description provided for @teleportFailed.
  ///
  /// In en, this message translates to:
  /// **'Teleport failed'**
  String get teleportFailed;

  /// No description provided for @itemAdded.
  ///
  /// In en, this message translates to:
  /// **'Item added'**
  String get itemAdded;

  /// No description provided for @couldNotAddItem.
  ///
  /// In en, this message translates to:
  /// **'Could not add item'**
  String get couldNotAddItem;

  /// No description provided for @couldNotRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Could not remove item'**
  String get couldNotRemoveItem;

  /// No description provided for @jumpToLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Jump to a specific QSP location in the story.'**
  String get jumpToLocationHint;

  /// No description provided for @locationNameHint.
  ///
  /// In en, this message translates to:
  /// **'Location name (e.g. start, room, shop)...'**
  String get locationNameHint;

  /// No description provided for @newItemNameHint.
  ///
  /// In en, this message translates to:
  /// **'New item name...'**
  String get newItemNameHint;

  /// No description provided for @addVariableHint.
  ///
  /// In en, this message translates to:
  /// **'Add variable to watch...'**
  String get addVariableHint;

  /// No description provided for @scanAllVariables.
  ///
  /// In en, this message translates to:
  /// **'Scan all game variables'**
  String get scanAllVariables;

  /// No description provided for @lockValue.
  ///
  /// In en, this message translates to:
  /// **'Lock value'**
  String get lockValue;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @editValue.
  ///
  /// In en, this message translates to:
  /// **'Edit value'**
  String get editValue;

  /// No description provided for @noVariablesFound.
  ///
  /// In en, this message translates to:
  /// **'No variables found'**
  String get noVariablesFound;

  /// No description provided for @noLockedVariables.
  ///
  /// In en, this message translates to:
  /// **'No locked variables active'**
  String get noLockedVariables;

  /// No description provided for @noSnapshotYet.
  ///
  /// In en, this message translates to:
  /// **'No snapshot yet. Changes will appear here.'**
  String get noSnapshotYet;

  /// No description provided for @noChangesSinceSnapshot.
  ///
  /// In en, this message translates to:
  /// **'No changes since snapshot'**
  String get noChangesSinceSnapshot;

  /// No description provided for @consoleFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get consoleFailed;

  /// No description provided for @previousSessionCrashed.
  ///
  /// In en, this message translates to:
  /// **'Previous Session Crashed'**
  String get previousSessionCrashed;

  /// No description provided for @crashIntro.
  ///
  /// In en, this message translates to:
  /// **'Questopia encountered an unhandled error in the last run. You can copy the diagnostic details below to report it.'**
  String get crashIntro;

  /// No description provided for @crashLogCopied.
  ///
  /// In en, this message translates to:
  /// **'Crash log copied to clipboard'**
  String get crashLogCopied;

  /// No description provided for @copyDetails.
  ///
  /// In en, this message translates to:
  /// **'Copy Details'**
  String get copyDetails;

  /// No description provided for @closeSearch.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get closeSearch;

  /// No description provided for @refreshCatalog.
  ///
  /// In en, this message translates to:
  /// **'Refresh catalog'**
  String get refreshCatalog;

  /// No description provided for @showAllGames.
  ///
  /// In en, this message translates to:
  /// **'Show all games'**
  String get showAllGames;

  /// No description provided for @showFavoritesOnly.
  ///
  /// In en, this message translates to:
  /// **'Show favorites only'**
  String get showFavoritesOnly;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @deleteGame.
  ///
  /// In en, this message translates to:
  /// **'Delete game'**
  String get deleteGame;

  /// No description provided for @removeFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Remove from library'**
  String get removeFromLibrary;

  /// No description provided for @deleteGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Game'**
  String get deleteGameTitle;

  /// No description provided for @deleteGameMessage.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete \"{title}\" and all its files from your device?\n\nThis action cannot be undone.'**
  String deleteGameMessage(String title);

  /// No description provided for @removeFromLibraryMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{title}\" from your library?\n\nNote: Game files on your device will NOT be deleted.'**
  String removeFromLibraryMessage(String title);

  /// No description provided for @couldNotReachRepository.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the repository.'**
  String get couldNotReachRepository;

  /// No description provided for @noGamesYet.
  ///
  /// In en, this message translates to:
  /// **'No games found'**
  String get noGamesYet;

  /// No description provided for @noStatusInformation.
  ///
  /// In en, this message translates to:
  /// **'No status information available'**
  String get noStatusInformation;

  /// No description provided for @inventoryIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Inventory is empty'**
  String get inventoryIsEmpty;

  /// No description provided for @sortComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get sortComments;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get sortUpdated;

  /// No description provided for @sortCreated.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get sortCreated;

  /// No description provided for @sortLikes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get sortLikes;

  /// No description provided for @sortDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get sortDownloads;

  /// No description provided for @sortPlays.
  ///
  /// In en, this message translates to:
  /// **'Plays'**
  String get sortPlays;

  /// No description provided for @gameNotes.
  ///
  /// In en, this message translates to:
  /// **'Game Notes'**
  String get gameNotes;

  /// No description provided for @notesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notesEmptyTitle;

  /// No description provided for @notesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Write down clues, codes, or puzzle solutions. Notes are kept for this game only.'**
  String get notesEmptyHint;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Write your notes here...'**
  String get notesHint;

  /// No description provided for @notesSaved.
  ///
  /// In en, this message translates to:
  /// **'Notes saved'**
  String get notesSaved;

  /// No description provided for @notesDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Notes'**
  String get notesDiscardTitle;

  /// No description provided for @notesDiscardMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Discard them?'**
  String get notesDiscardMessage;

  /// No description provided for @notesDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get notesDiscard;

  /// No description provided for @notesKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get notesKeepEditing;

  /// No description provided for @notesTabDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Note {index}'**
  String notesTabDefaultTitle(int index);

  /// No description provided for @notesAddTab.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get notesAddTab;

  /// No description provided for @notesRenameTab.
  ///
  /// In en, this message translates to:
  /// **'Rename note'**
  String get notesRenameTab;

  /// No description provided for @notesRenameTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Note'**
  String get notesRenameTabTitle;

  /// No description provided for @notesRenameTabHint.
  ///
  /// In en, this message translates to:
  /// **'Note name'**
  String get notesRenameTabHint;

  /// No description provided for @notesRenameTabEmpty.
  ///
  /// In en, this message translates to:
  /// **'A note needs a name'**
  String get notesRenameTabEmpty;

  /// No description provided for @notesDeleteTab.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get notesDeleteTab;

  /// No description provided for @notesDeleteTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Note'**
  String get notesDeleteTabTitle;

  /// No description provided for @notesDeleteTabMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\" and its text? This cannot be undone.'**
  String notesDeleteTabMessage(String title);

  /// No description provided for @notesLastTabHint.
  ///
  /// In en, this message translates to:
  /// **'At least one note must stay open'**
  String get notesLastTabHint;

  /// No description provided for @notesUntitledTab.
  ///
  /// In en, this message translates to:
  /// **'Untitled note'**
  String get notesUntitledTab;

  /// No description provided for @notesSwitchDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get notesSwitchDiscardTitle;

  /// No description provided for @notesSwitchDiscardMessage.
  ///
  /// In en, this message translates to:
  /// **'This note has unsaved changes. Discard them and switch?'**
  String get notesSwitchDiscardMessage;

  /// No description provided for @notesSwitchDiscard.
  ///
  /// In en, this message translates to:
  /// **'Switch and discard'**
  String get notesSwitchDiscard;

  /// No description provided for @notesTabSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get notesTabSaved;

  /// No description provided for @playStats.
  ///
  /// In en, this message translates to:
  /// **'Play Statistics'**
  String get playStats;

  /// No description provided for @playStatsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total play time'**
  String get playStatsTotal;

  /// No description provided for @playStatsLast.
  ///
  /// In en, this message translates to:
  /// **'Last played'**
  String get playStatsLast;

  /// No description provided for @playStatsNever.
  ///
  /// In en, this message translates to:
  /// **'Never played'**
  String get playStatsNever;

  /// No description provided for @neverPlayed.
  ///
  /// In en, this message translates to:
  /// **'Never played'**
  String get neverPlayed;

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String durationSeconds(int seconds);

  /// No description provided for @saveTimeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get saveTimeJustNow;

  /// No description provided for @saveTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String saveTimeMinutesAgo(int minutes);

  /// No description provided for @saveTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String saveTimeHoursAgo(int hours);

  /// No description provided for @saveTimeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get saveTimeYesterday;

  /// No description provided for @saveTimeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} d ago'**
  String saveTimeDaysAgo(int days);

  /// No description provided for @emptySlotHint.
  ///
  /// In en, this message translates to:
  /// **'No save data'**
  String get emptySlotHint;

  /// No description provided for @searchHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchHistoryTitle;

  /// No description provided for @searchHistoryClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get searchHistoryClearAll;

  /// No description provided for @searchHistoryClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Search History'**
  String get searchHistoryClearTitle;

  /// No description provided for @searchHistoryClearMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove all saved search queries from the catalog?'**
  String get searchHistoryClearMessage;

  /// No description provided for @searchHistoryRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from history'**
  String get searchHistoryRemove;

  /// No description provided for @searchHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'Search history cleared'**
  String get searchHistoryCleared;

  /// No description provided for @languageAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get languageAuto;

  /// No description provided for @untitledRemoteGame.
  ///
  /// In en, this message translates to:
  /// **'Game #{id}'**
  String untitledRemoteGame(String id);

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Questopia'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Your home for QSP interactive fiction. Import your games, pick up where you left off, and shape the app the way you like it.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onboardingLanguageTitle;

  /// No description provided for @onboardingLanguageBody.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings.'**
  String get onboardingLanguageBody;

  /// No description provided for @onboardingThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a theme'**
  String get onboardingThemeTitle;

  /// No description provided for @onboardingThemeBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the look that is easiest on your eyes.'**
  String get onboardingThemeBody;

  /// No description provided for @onboardingAccentTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick an accent color'**
  String get onboardingAccentTitle;

  /// No description provided for @onboardingAccentBody.
  ///
  /// In en, this message translates to:
  /// **'Dynamic follows your system wallpaper on supported devices.'**
  String get onboardingAccentBody;

  /// No description provided for @onboardingReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading comfort'**
  String get onboardingReadingTitle;

  /// No description provided for @onboardingReadingBody.
  ///
  /// In en, this message translates to:
  /// **'Set how large the game text appears and how the reading surface looks.'**
  String get onboardingReadingBody;

  /// No description provided for @onboardingReadingFontSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get onboardingReadingFontSize;

  /// No description provided for @onboardingBehaviorTitle.
  ///
  /// In en, this message translates to:
  /// **'Gameplay and helpers'**
  String get onboardingBehaviorTitle;

  /// No description provided for @onboardingBehaviorBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on the reading and input helpers you want from the start.'**
  String get onboardingBehaviorBody;

  /// No description provided for @onboardingFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'You are all set'**
  String get onboardingFinishTitle;

  /// No description provided for @onboardingFinishBody.
  ///
  /// In en, this message translates to:
  /// **'These choices are saved. You can change any of them later in Settings.'**
  String get onboardingFinishBody;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingRestart.
  ///
  /// In en, this message translates to:
  /// **'Show setup again'**
  String get onboardingRestart;

  /// No description provided for @onboardingRestartHint.
  ///
  /// In en, this message translates to:
  /// **'Run the first time setup wizard again'**
  String get onboardingRestartHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
