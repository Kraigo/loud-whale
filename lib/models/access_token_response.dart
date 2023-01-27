import 'dart:convert';

class AccessTokenResponse {
  String accessToken;
  String tokenType;
  String scope;
  int createdAt;
  AccessTokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.scope,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'tokenType': tokenType,
      'scope': scope,
      'createdAt': createdAt,
    };
  }

  factory AccessTokenResponse.fromMap(Map<String, dynamic> map) {
    return AccessTokenResponse(
      accessToken: map['access_token'] ?? '',
      tokenType: map['token_type'] ?? '',
      scope: map['scope'] ?? '',
      createdAt: map['create_at']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccessTokenResponse.fromJson(String source) => AccessTokenResponse.fromMap(json.decode(source));
}
