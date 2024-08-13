import "../game_settings_view.dart";

class GameSettingConsts {
  static String appBarLabel = "Параметры";
  static String gameModeText = "Режим игры";
  static String colorPiecesText = "Цвет фигур";
  static String timeText = "Время";
  static String levelDifficultyText = "Уровень сложности";
  static String choseDiffModalHeader = "Уровень\nсложности бота";
  static String personalLevelDifficultyText = "Сложность бота";
  static String additionalSettingsText = "Дополнительно";
  static String startGameText = "Начать партию";
  static String gameWithComputerText = "С компьютером";
  static String gameWithHumanText = "С другом";
  static String gameWithTimeText = "С часами";
  static String gameWithoutTimeText = "Без часов";
  static String minutesSubtitle = "Минут на партию";
  static String secondsSubtitle = "Добавление секунд на ход";
  static String moveBackText = "Возврат ходов";
  static String threatsText = "Угрозы";
  static String hintsText = "Подсказки";
  static String easyDescription = "Подсказки и возврат хода";
  static String mediumDescription = "Только возврат хода";
  static String hardDescription = "Никакой помощи";
  static String personalityDescription = "Настрой под себя";
  static String longDashSymbol = "—";
  static int countOfDifficultyLevels = 3;

  static List<int> listOfDurations = [
    1,
    2,
    3,
    4,
    5,
    10,
    15,
    20,
    25,
    30,
    40,
    60,
    80,
    90,
    120
  ];

  static List<dynamic> listOfAdditions = [
    longDashSymbol,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    15,
    20,
    30,
    45,
    60
  ];

  static Map<LevelOfDifficulty, int> difficultyLevels = {
    LevelOfDifficulty.easy: 1,
    LevelOfDifficulty.medium: 3,
    LevelOfDifficulty.hard: 6,
  };

  static Map<LevelOfDifficulty, String> personalLevelOfDifficultyText = {
    LevelOfDifficulty.easy: "Лёгкий",
    LevelOfDifficulty.medium: "Средний",
    LevelOfDifficulty.hard: "Сложный",
  };

  static String dbCreateScript = """CREATE TABLE Settings (
  id INTEGER PRIMARY KEY, 
  withComputer INTEGER, 
  colorPieces INTEGER, 
  withoutTime INTEGER,
  durationGame INTEGER,
  addingOnMove INTEGER,
  levelOfDifficulty INTEGER,
  isPersonality INTEGER,
  isMoveBack INTEGER,
  isThreats INTEGER,
  isHints INTEGER
  )""";

  static String dbGetSettingsScript = "SELECT * FROM Settings";

  static String dbUpdateSettingsScript = """UPDATE Settings SET
  withComputer = ?,
  colorPieces = ?,
  withoutTime = ?,
  durationGame = ?,
  addingOnMove = ?,
  levelOfDifficulty = ?,
  isPersonality = ?,
  isMoveBack = ?,
  isThreats = ?,
  isHints = ?
  WHERE id = 1
  """;

  static String dbSetSettingsScript = """INSERT INTO Settings(
  withComputer,
  colorPieces,
  withoutTime,
  durationGame,
  addingOnMove,
  levelOfDifficulty,
  isPersonality,
  isMoveBack,
  isThreats,
  isHints
  ) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  """;
}