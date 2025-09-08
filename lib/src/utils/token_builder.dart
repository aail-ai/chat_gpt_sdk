class TokenBuilder {
  TokenBuilder._();

  static final _instance = TokenBuilder._();

  static TokenBuilder get build => _instance;

  ///token
  String _token = '';

  ///refresh token future
  Future<String?>?  Function()? _refreshToken;

  ///org
  String? _orgId;

  ///set token
  void setToken(String token) {
    _token = token;
  }

  void setRefreshToken(Future<String?>?  Function()? refreshToken) {
    _refreshToken = refreshToken;
  }

  ///set orgId
  void setOrgId(String? orgId) => _orgId = orgId;

  ///get token
  String? get token => _token;

  ///get token refresh
  Future<String?>?  Function()? get refreshToken => _refreshToken;

  ///get orgID
  String? get orgId => _orgId;
}
