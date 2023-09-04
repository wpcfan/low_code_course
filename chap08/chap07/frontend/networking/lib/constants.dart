class Constants {
  static const String lowCodeBaseUrl = String.fromEnvironment(
    'LOWCODE_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );
}
