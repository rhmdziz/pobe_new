class ApiConstants {
  const ApiConstants._();

  static const String _baseHost = 'http://192.168.1.49:8000';

  // Base endpoints
  static const String newsUrl = '$_baseHost/newss/';
  static const String newsCommentsUrl = '$_baseHost/newscomment/';
  static const String haltesUrl = '$_baseHost/haltes/';
  static const String busRoutesUrl = '$_baseHost/busroutes/';
  static const String busSchedulesUrl = '$_baseHost/busscheduls/';
  static const String reportsUrl = '$_baseHost/reports/';
  static const String userProfileUrl = '$_baseHost/api/users/me/';

  // Auth endpoints
  static const String authTokenUrl = '$_baseHost/api/token/';
  static const String signupUrl = '$_baseHost/api/signup/';

  // AQI endpoints
  static const String aqiBaseUrl = 'https://api.waqi.info/feed/A417100/';
  static const String aqiToken = '9f59127ff5cd375ecfd300353d1e7e5bbf73ce2f';

  // Category endpoints (adjust as needed to match backend)
  static const String toGoBaseUrl = _baseHost;
  static const String toGoReviewPath = '/foodreviews/';
  static const Map<String, String> toGoEndpoints = {
    'Food': '/foods/',
    'Shopping': '/shoppings/',
    'Mall': '/malls/',
    'Hospital': '/hospitals/',
    'Sport': '/sports/',
    'Entertain': '/entertains/',
  };
}
