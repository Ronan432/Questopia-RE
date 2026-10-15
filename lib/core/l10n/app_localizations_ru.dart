// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Questopia';

  @override
  String get home => 'Главная';

  @override
  String get catalog => 'Каталог';

  @override
  String get settings => 'Настройки';

  @override
  String get play => 'Играть';

  @override
  String get installedGames => 'Установленные игры';

  @override
  String get favoriteGames => 'Избранное';

  @override
  String get saves => 'Сохранения';

  @override
  String get cheatModes => 'Режимы читов';

  @override
  String get search => 'Поиск игр...';

  @override
  String get theme => 'Тема';

  @override
  String get systemTheme => 'Системная';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get amoledTheme => 'AMOLED';

  @override
  String get fontSize => 'Размер шрифта';

  @override
  String get gameFolder => 'Папка с играми';

  @override
  String get importGame => 'Импорт игры';

  @override
  String get exportSave => 'Экспорт сохранения';

  @override
  String get importSave => 'Импорт сохранения';

  @override
  String get autoSave => 'Автосохранение';

  @override
  String get restart => 'Перезапуск';

  @override
  String get close => 'Закрыть';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get variables => 'Переменные';

  @override
  String get locks => 'Замки';

  @override
  String get teleport => 'Телепорт';

  @override
  String get inventory => 'Инвенварь';

  @override
  String get tabGame => 'Игра';

  @override
  String get tabStatus => 'Статус';

  @override
  String get tabInventory => 'Инвентарь';

  @override
  String get console => 'Консоль';

  @override
  String get diff => 'Разница';

  @override
  String get download => 'Скачать';

  @override
  String get delete => 'Удалить';

  @override
  String get downloading => 'Загрузка...';

  @override
  String get addGame => 'Добавить игру';

  @override
  String get emptyLibraryHint =>
      'В библиотеке пока нет игр.\nСкачайте из каталога или импортируйте папку.';

  @override
  String get fileOrArchive => 'Файл или архив';

  @override
  String get fileOrArchiveHint => '.qsp, .gam, .zip, .rar, .aqsp, .7z';

  @override
  String get selectFolder => 'Выберите папку';

  @override
  String pageOf(int page, int total) {
    return 'Страница $page из $total';
  }

  @override
  String get retry => 'Повторить';

  @override
  String get prev => 'Назад';

  @override
  String get next => 'Вперёд';

  @override
  String get noCatalogItems => 'В каталоге пока ничего нет.';

  @override
  String downloadedGame(String title) {
    return 'Загружено: $title';
  }

  @override
  String get searchOnlineCatalog => 'Поиск в онлайн каталоге...';

  @override
  String get allLanguages => 'Все языки';

  @override
  String get featured => 'Рекомендуемые';

  @override
  String get sortCatalog => 'Сортировка каталога';

  @override
  String get selectGameFolder => 'Выберите папку с игрой';

  @override
  String get selectGameFileOrArchive => 'Выберите файл или архив игры';

  @override
  String unsupportedGameFormat(Object ext) {
    return 'Выбранный файл не поддерживается (.$ext). Выберите файл .qsp, .gam или архив.';
  }

  @override
  String importedGame(String title) {
    return 'Импортировано: $title';
  }

  @override
  String importFailed(String reason) {
    return 'Ошибка импорта: $reason';
  }

  @override
  String gameFileNotFound(String path) {
    return 'Файл игры не найден: $path. Папка могла быть перемещена или отозван доступ к хранилищу.';
  }

  @override
  String get importGameTooltip => 'Импорт игры';

  @override
  String get gameOptionsTooltip => 'Параметры игры';

  @override
  String get sectionAppearance => 'Внешний вид';

  @override
  String get sectionGeneral => 'Общие';

  @override
  String get sectionTypography => 'Типографика';

  @override
  String get sectionMedia => 'Медиа и изображения';

  @override
  String get sectionSound => 'Звук';

  @override
  String get sectionStorage => 'Хранилище';

  @override
  String get sectionAbout => 'О программе';

  @override
  String get colorAccent => 'Цветовой акцент';

  @override
  String get language => 'Язык';

  @override
  String get followSystem => 'Как в системе';

  @override
  String get immersiveMode => 'Полноэкранный режим';

  @override
  String get autoscroll => 'Автопрокрутка';

  @override
  String get separatorLine => 'Разделительная линия';

  @override
  String get edgeFeedback => 'Вибрация на границах';

  @override
  String get navBarBlur => 'Размытие навигации';

  @override
  String get autoSaveInterval => 'Интервал автосохранения';

  @override
  String get clicks => 'кликов';

  @override
  String get cheatEngine => 'Чит-движок';

  @override
  String get qspCommandLine => 'Командная строка QSP';

  @override
  String get actionsPanelHeight => 'Высота панели действий';

  @override
  String get binaryPrefixes => 'Двоичные префиксы';

  @override
  String get typeface => 'Гарнитура';

  @override
  String get useGameFont => 'Использовать шрифт игры';

  @override
  String get customTextColor => 'Свой цвет текста';

  @override
  String get textColor => 'Цвет текста';

  @override
  String get customBackgroundColor => 'Свой цвет фона';

  @override
  String get backgroundColor => 'Цвет фона';

  @override
  String get customLinkColor => 'Свой цвет ссылок';

  @override
  String get linkColor => 'Цвет ссылок';

  @override
  String get disableImages => 'Отключить изображения';

  @override
  String get showAllImagesDialog => 'Все картинки в диалогах';

  @override
  String get pinchZoom => 'Масштабирование жестом';

  @override
  String get fullscreenImages => 'Полноэкранный просмотр фото';

  @override
  String get autoWidth => 'Авто-ширина изображений';

  @override
  String get imageWidth => 'Ширина изображений';

  @override
  String get autoHeight => 'Авто-высота изображений';

  @override
  String get imageHeight => 'Высота изображений';

  @override
  String get playSound => 'Воспроизводить звук';

  @override
  String get muteVideoAudio => 'Без звука в видео';

  @override
  String get gamesFolder => 'Папка с играми';

  @override
  String get defaultInternalFolder => 'Папка по умолчанию';

  @override
  String get version => 'Версия';

  @override
  String get openSourceLicenses => 'Лицензии ПО';

  @override
  String get themeModeTitle => 'Режим темы';

  @override
  String get colorAccentTitle => 'Цветовой акцент';

  @override
  String get languageTitle => 'Язык приложения';

  @override
  String get actionsHeightTitle => 'Высота панели действий';

  @override
  String get binaryPrefixesTitle => 'Двоичные префиксы';

  @override
  String get binaryKiB => 'Двоичные / КиБ';

  @override
  String get decimalKB => 'Десятичные / КБ';

  @override
  String get livePreview => 'ЖИВОЙ ПРОСМОТР';

  @override
  String get livePreviewText =>
      'Вы стоите у ворот древнего замка. Тяжелые дубовые двери запечатаны рунами.';

  @override
  String get accentDynamic => 'Динамический';

  @override
  String get accentBlue => 'Синий';

  @override
  String get accentGreen => 'Зелёный';

  @override
  String get accentOrange => 'Оранжевый';

  @override
  String get accentPurple => 'Фиолетовый';

  @override
  String get accentPink => 'Розовый';

  @override
  String get accentTeal => 'Бирюзовый';

  @override
  String get accentAmber => 'Янтарный';

  @override
  String get accentMonochrome => 'Монохромный';

  @override
  String get fontDefaultSystem => 'Системный по умолчанию';

  @override
  String get fontSansSerif => 'Без засечек (Sans-serif)';

  @override
  String get fontSerif => 'С засечками (Serif)';

  @override
  String get fontMonospace => 'Моноширинный (Monospace)';

  @override
  String get fontMedium => 'Средний (Medium)';

  @override
  String get fontCursive => 'Курсив (Cursive)';

  @override
  String get fontLight => 'Тонкий (Light)';

  @override
  String get fontCondensed => 'Сжатый (Condensed)';

  @override
  String get fontBlack => 'Жирный (Black)';

  @override
  String get fontThin => 'Тонкий (Thin)';

  @override
  String get fontCasual => 'Рукописный (Casual)';

  @override
  String get fontSerifMonospace => 'Моноширинный с засечками';

  @override
  String get exitGameTitle => 'Выход из игры';

  @override
  String get exitGameMessage =>
      'Вы уверены, что хотите выйти из игры? Весь несохраненный прогресс будет потерян.';

  @override
  String get deleteAll => 'Удалить все';

  @override
  String get deleteAllGamesTitle => 'Удалить все установленные игры';

  @override
  String get deleteAllGamesMessage =>
      'Вы уверены, что хотите удалить все установленные игры из библиотеки? Это действие необратимо.';

  @override
  String get readingTheme => 'Тема чтения';

  @override
  String get readingThemeDefault => 'По умолчанию';

  @override
  String get readingThemeSepia => 'Сепия';

  @override
  String get readingThemeNight => 'Ночь';

  @override
  String get readingThemeHighContrast => 'Высокий контраст';

  @override
  String get readingThemeMaterialYou => 'Material You';

  @override
  String get storageUsage => 'Использование памяти';

  @override
  String get storageTotal => 'Всего занято';

  @override
  String get storageCleanup => 'Очистить неиспользуемые файлы';

  @override
  String get storageCleanupHint =>
      'Удаляет оставшиеся папки без игрового файла.';

  @override
  String storageCleanupFreed(String size) {
    return 'Освобождено $size';
  }

  @override
  String get storageNothingToClean => 'Нечего очищать';

  @override
  String get storageCalculating => 'Подсчёт...';

  @override
  String get ok => 'ОК';

  @override
  String get apply => 'Применить';

  @override
  String get remove => 'Удалить';

  @override
  String get save => 'Сохранить';

  @override
  String get load => 'Загрузить';

  @override
  String get input => 'Ввод';

  @override
  String get choose => 'Выбор';

  @override
  String get run => 'Выполнить';

  @override
  String get add => 'Добавить';

  @override
  String get scan => 'Сканировать';

  @override
  String get overwrite => 'Перезаписать';

  @override
  String get restore => 'Развернуть';

  @override
  String get maximize => 'Развернуть на весь экран';

  @override
  String get minimize => 'Свернуть';

  @override
  String get dismiss => 'Закрыть';

  @override
  String lockedTo(String value) {
    return 'Зафиксировано: $value';
  }

  @override
  String get emptyStringValue => '(пустая строка)';

  @override
  String slotTitle(int index) {
    return 'Слот $index';
  }

  @override
  String pageOfPages(int page, int total) {
    return 'Страница $page / $total';
  }

  @override
  String savedGameToSlot(int index) {
    return 'Игра сохранена в слот $index';
  }

  @override
  String teleportedTo(String location) {
    return 'Переход выполнен: $location';
  }

  @override
  String editVarTitle(String name) {
    return 'Изменение $name';
  }

  @override
  String searchVariablesHint(int count) {
    return 'Поиск переменных (найдено $count)...';
  }

  @override
  String get loadingGameWorld => 'Загрузка игрового мира...';

  @override
  String get notFound => 'Не найдено';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get couldNotOpenSaveFile => 'Не удалось открыть файл сохранения';

  @override
  String get imageOptions => 'Действия с изображением';

  @override
  String get copyImage => 'Скопировать изображение';

  @override
  String get saveToGallery => 'Сохранить в галерею';

  @override
  String get searchImageOnYandex => 'Найти изображение в Яндексе';

  @override
  String get imageReferenceCopied => 'Ссылка на изображение скопирована';

  @override
  String get couldNotCopyImage => 'Не удалось скопировать изображение';

  @override
  String get imageSavedToGallery => 'Изображение сохранено в галерею';

  @override
  String get couldNotSaveImage => 'Не удалось сохранить изображение';

  @override
  String get openingYandexSearch => 'Открывается поиск изображений в Яндексе';

  @override
  String get couldNotOpenYandexSearch => 'Не удалось открыть поиск в Яндексе';

  @override
  String get videoPreview => 'Просмотр видео';

  @override
  String get imagePreview => 'Просмотр изображения';

  @override
  String get options => 'Действия';

  @override
  String get qspConsole => 'Консоль QSP';

  @override
  String get qspCodeHint => 'Код QSP...';

  @override
  String get qspStatementHint => 'Инструкция QSP...';

  @override
  String get noOutputYet => 'Вывод пока пуст';

  @override
  String get qspConsoleReady =>
      'Консоль QSP готова.\nВведите команды вида: money += 500 или goto \'start\'';

  @override
  String get restartGameTitle => 'Перезапустить игру?';

  @override
  String get restartGameMessage => 'Несохранённый прогресс будет потерян.';

  @override
  String get engineError => 'Ошибка движка';

  @override
  String get unknownEngineError => 'Неизвестная ошибка движка';

  @override
  String errorNumber(int number, String description) {
    return 'Ошибка №$number: $description';
  }

  @override
  String errorLocation(String name) {
    return 'Локация: $name';
  }

  @override
  String errorLine(int number) {
    return 'Строка: $number';
  }

  @override
  String errorCode(String code) {
    return 'Код: $code';
  }

  @override
  String get noOptions => 'Нет вариантов';

  @override
  String get openSaveFile => 'Открыть файл сохранения';

  @override
  String get openSaveFileHint => 'Выберите внешний файл .sav для загрузки.';

  @override
  String get pickFile => 'Выбрать файл';

  @override
  String get message => 'Сообщение';

  @override
  String get qspInteractiveFiction => 'Интерактивная проза QSP';

  @override
  String get gameOptions => 'Параметры игры';

  @override
  String get saveAndLoad => 'Сохранение и загрузка';

  @override
  String get cheatEngineAndEditor => 'Читы и редактор';

  @override
  String get restartGame => 'Перезапустить игру';

  @override
  String get savesAndSlots => 'Сохранения и слоты';

  @override
  String get selectSlotToSave => 'Выберите слот для сохранения';

  @override
  String get selectSlotToLoad => 'Выберите слот для загрузки';

  @override
  String get autoSaveSlot => 'Слот автосохранения';

  @override
  String get lastSavedSessionAvailable => 'Доступно последнее сохранение';

  @override
  String get noAutoSaveDataFound => 'Данных автосохранения нет';

  @override
  String get savedGameState => 'Сохранённое состояние игры';

  @override
  String get emptySlot => 'Пустой слот';

  @override
  String get importSav => 'Импорт .sav';

  @override
  String get exportSav => 'Экспорт .sav';

  @override
  String get saveImported => 'Файл сохранения импортирован';

  @override
  String get saveImportFailed => 'Не удалось импортировать файл сохранения';

  @override
  String get noActiveSaveData => 'Нет активных данных для экспорта';

  @override
  String get saveFileExported => 'Файл сохранения экспортирован';

  @override
  String get exportSaveFileDialog => 'Экспорт файла сохранения';

  @override
  String get newValue => 'Новое значение';

  @override
  String get engineRejectedValue => 'Движок отклонил значение';

  @override
  String get teleportFailed => 'Не удалось выполнить переход';

  @override
  String get itemAdded => 'Предмет добавлен';

  @override
  String get couldNotAddItem => 'Не удалось добавить предмет';

  @override
  String get couldNotRemoveItem => 'Не удалось удалить предмет';

  @override
  String get jumpToLocationHint => 'Переход к нужной локации QSP в истории.';

  @override
  String get locationNameHint =>
      'Название локации (например, start, room, shop)...';

  @override
  String get newItemNameHint => 'Название нового предмета...';

  @override
  String get addVariableHint => 'Добавить переменную для наблюдения...';

  @override
  String get scanAllVariables => 'Сканировать все переменные игры';

  @override
  String get lockValue => 'Зафиксировать значение';

  @override
  String get unlock => 'Снять фиксацию';

  @override
  String get editValue => 'Изменить значение';

  @override
  String get noVariablesFound => 'Переменные не найдены';

  @override
  String get noLockedVariables => 'Нет зафиксированных переменных';

  @override
  String get noSnapshotYet => 'Снимка ещё нет. Изменения появятся здесь.';

  @override
  String get noChangesSinceSnapshot => 'Изменений после снимка нет';

  @override
  String get consoleFailed => 'Ошибка';

  @override
  String get previousSessionCrashed => 'Предыдущий сеанс завершился сбоем';

  @override
  String get crashIntro =>
      'В прошлом запуске Questopia столкнулась с необработанной ошибкой. Ниже можно скопировать диагностические данные для отчёта.';

  @override
  String get crashLogCopied => 'Журнал сбоя скопирован в буфер обмена';

  @override
  String get copyDetails => 'Копировать данные';

  @override
  String get closeSearch => 'Закрыть поиск';

  @override
  String get refreshCatalog => 'Обновить каталог';

  @override
  String get showAllGames => 'Показать все игры';

  @override
  String get showFavoritesOnly => 'Показать только избранное';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get removeFromFavorites => 'Убрать из избранного';

  @override
  String get deleteGame => 'Удалить игру';

  @override
  String get removeFromLibrary => 'Убрать из библиотеки';

  @override
  String get deleteGameTitle => 'Удаление игры';

  @override
  String deleteGameMessage(String title) {
    return 'Безвозвратно удалить игру \"$title\" и все её файлы с устройства?\n\nЭто действие необратимо.';
  }

  @override
  String removeFromLibraryMessage(String title) {
    return 'Убрать игру \"$title\" из библиотеки?\n\nПримечание: файлы игры на устройстве удалены НЕ будут.';
  }

  @override
  String get couldNotReachRepository => 'Не удалось связаться с репозиторием.';

  @override
  String get noGamesYet => 'Игры не найдены';

  @override
  String get noStatusInformation => 'Нет данных о состоянии';

  @override
  String get inventoryIsEmpty => 'Инвентарь пуст';

  @override
  String get sortComments => 'Комментарии';

  @override
  String get sortName => 'Название';

  @override
  String get sortUpdated => 'Обновление';

  @override
  String get sortCreated => 'Добавлено';

  @override
  String get sortLikes => 'Лайки';

  @override
  String get sortDownloads => 'Загрузки';

  @override
  String get sortPlays => 'Запуски';

  @override
  String get gameNotes => 'Заметки к игре';

  @override
  String get notesEmptyTitle => 'Заметок пока нет';

  @override
  String get notesEmptyHint =>
      'Записывайте подсказки, коды и решения головоломок. Заметки сохраняются только для этой игры.';

  @override
  String get notesHint => 'Напишите заметки здесь...';

  @override
  String get notesSaved => 'Заметки сохранены';

  @override
  String get notesDiscardTitle => 'Несохранённые заметки';

  @override
  String get notesDiscardMessage =>
      'У вас есть несохранённые изменения. Отменить их?';

  @override
  String get notesDiscard => 'Отменить';

  @override
  String get notesKeepEditing => 'Продолжить';

  @override
  String notesTabDefaultTitle(int index) {
    return 'Заметка $index';
  }

  @override
  String get notesAddTab => 'Новая заметка';

  @override
  String get notesRenameTab => 'Переименовать заметку';

  @override
  String get notesRenameTabTitle => 'Переименовать заметку';

  @override
  String get notesRenameTabHint => 'Название заметки';

  @override
  String get notesRenameTabEmpty => 'У заметки должно быть название';

  @override
  String get notesDeleteTab => 'Удалить заметку';

  @override
  String get notesDeleteTabTitle => 'Удалить заметку';

  @override
  String notesDeleteTabMessage(String title) {
    return 'Удалить «$title» и её текст? Это действие нельзя отменить.';
  }

  @override
  String get notesLastTabHint =>
      'Хотя бы одна заметка должна остаться открытой';

  @override
  String get notesUntitledTab => 'Заметка без названия';

  @override
  String get notesSwitchDiscardTitle => 'Несохранённые изменения';

  @override
  String get notesSwitchDiscardMessage =>
      'В этой заметке есть несохранённые изменения. Отменить их и переключиться?';

  @override
  String get notesSwitchDiscard => 'Переключить и отменить';

  @override
  String get notesTabSaved => 'Заметка сохранена';

  @override
  String get playStats => 'Статистика игры';

  @override
  String get playStatsTotal => 'Всего наиграно';

  @override
  String get playStatsLast => 'Последний запуск';

  @override
  String get playStatsNever => 'Ни разу не запускалась';

  @override
  String get neverPlayed => 'Ни разу не запускалась';

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String durationSeconds(int seconds) {
    return '$seconds с';
  }

  @override
  String get saveTimeJustNow => 'Только что';

  @override
  String saveTimeMinutesAgo(int minutes) {
    return '$minutes мин назад';
  }

  @override
  String saveTimeHoursAgo(int hours) {
    return '$hours ч назад';
  }

  @override
  String get saveTimeYesterday => 'Вчера';

  @override
  String saveTimeDaysAgo(int days) {
    return '$days дн назад';
  }

  @override
  String get emptySlotHint => 'Нет данных сохранения';

  @override
  String get searchHistoryTitle => 'Недавние запросы';

  @override
  String get searchHistoryClearAll => 'Очистить всё';

  @override
  String get searchHistoryClearTitle => 'Очистить историю поиска';

  @override
  String get searchHistoryClearMessage =>
      'Удалить все сохранённые поисковые запросы каталога?';

  @override
  String get searchHistoryRemove => 'Удалить из истории';

  @override
  String get searchHistoryCleared => 'История поиска очищена';

  @override
  String get languageAuto => 'Автоматически';

  @override
  String untitledRemoteGame(String id) {
    return 'Игра №$id';
  }

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать в Questopia';

  @override
  String get onboardingWelcomeBody =>
      'Ваш дом для интерактивной литературы на QSP. Добавляйте свои игры, продолжайте с места остановки и настройте приложение под себя.';

  @override
  String get onboardingLanguageTitle => 'Выберите язык';

  @override
  String get onboardingLanguageBody => 'Это можно изменить позже в настройках.';

  @override
  String get onboardingThemeTitle => 'Выберите тему';

  @override
  String get onboardingThemeBody =>
      'Выберите оформление, которое удобнее для глаз.';

  @override
  String get onboardingAccentTitle => 'Выберите цвет акцента';

  @override
  String get onboardingAccentBody =>
      'Динамический следует за обоями системы на поддерживаемых устройствах.';

  @override
  String get onboardingReadingTitle => 'Комфорт чтения';

  @override
  String get onboardingReadingBody =>
      'Настройте размер текста игры и вид поверхности для чтения.';

  @override
  String get onboardingReadingFontSize => 'Размер текста';

  @override
  String get onboardingBehaviorTitle => 'Игра и помощники';

  @override
  String get onboardingBehaviorBody =>
      'Включите нужные помощники чтения и ввода сразу.';

  @override
  String get onboardingFinishTitle => 'Всё готово';

  @override
  String get onboardingFinishBody =>
      'Эти настройки сохранены. Их можно изменить позже в настройках.';

  @override
  String get getStarted => 'Начать';

  @override
  String get onboardingRestart => 'Показать настройку снова';

  @override
  String get onboardingRestartHint =>
      'Запустить мастер первой настройки заново';
}
