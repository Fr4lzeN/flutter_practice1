class AppSettings {
  final bool isDarkTheme;
  final bool notificationsEnabled;
  final String language;
  final int defaultPriority;
  final bool showCompletedTasks;

  AppSettings({
    this.isDarkTheme = false,
    this.notificationsEnabled = true,
    this.language = 'ru',
    this.defaultPriority = 2,
    this.showCompletedTasks = true,
  });

  AppSettings copyWith({
    bool? isDarkTheme,
    bool? notificationsEnabled,
    String? language,
    int? defaultPriority,
    bool? showCompletedTasks,
  }) {
    return AppSettings(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      defaultPriority: defaultPriority ?? this.defaultPriority,
      showCompletedTasks: showCompletedTasks ?? this.showCompletedTasks,
    );
  }
}
