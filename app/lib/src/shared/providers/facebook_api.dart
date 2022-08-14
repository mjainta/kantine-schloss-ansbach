class FacebookApi {
  static FacebookApi get shared => FacebookApi();
  String get accessToken => _accessToken;
}

const _accessToken = String.fromEnvironment('FB_API_ACCESS_TOKEN');
