/// API configuration
class ApiConfig {
  // Base URLs
  static const String _devBaseUrl = 'http://localhost:8080';
  static const String _stagingBaseUrl = 'https://staging-api.mamoai.com';
  static const String _prodBaseUrl = 'https://api.mamoai.com';

  static String get baseUrl {
    const env = String.fromEnvironment('ENV', defaultValue: 'development');
    switch (env) {
      case 'production':
        return _prodBaseUrl;
      case 'staging':
        return _stagingBaseUrl;
      default:
        return _devBaseUrl;
    }
  }

  // API Endpoints
  static String get apiVersion => '/api/v2';

  // Incidents
  static String incidentsPath(String incidentId) =>
      '$apiVersion/incidents/$incidentId/actions';

  // Videos
  static String videoFilePath(String videoId) =>
      '$apiVersion/videos/$videoId/file';

  // Headers
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // GraphQL (if needed)
  static String get graphqlEndpoint => '$baseUrl$apiVersion/graphql';
}
