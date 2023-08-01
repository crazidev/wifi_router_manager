import 'dart:convert';

class LoginModel {
  final bool success;
  final int cmd;
  final String user_level;
  final String AUTH;
  final String sessionId;
  LoginModel({
    required this.success,
    required this.cmd,
    required this.user_level,
    required this.AUTH,
    required this.sessionId,
  });

  LoginModel copyWith({
    bool? success,
    int? cmd,
    String? user_level,
    String? AUTH,
    String? sessionId,
  }) {
    return LoginModel(
      success: success ?? this.success,
      cmd: cmd ?? this.cmd,
      user_level: user_level ?? this.user_level,
      AUTH: AUTH ?? this.AUTH,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'cmd': cmd,
      'user_level': user_level,
      'AUTH': AUTH,
      'sessionId': sessionId,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      success: map['success'] as bool,
      cmd: map['cmd'].toInt() as int,
      user_level: map['user_level'] as String,
      AUTH: map['AUTH'] as String,
      sessionId: map['sessionId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) =>
      LoginModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LoginModel(success: $success, cmd: $cmd, user_level: $user_level, AUTH: $AUTH, sessionId: $sessionId)';
  }

  @override
  bool operator ==(covariant LoginModel other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.cmd == cmd &&
        other.user_level == user_level &&
        other.AUTH == AUTH &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        cmd.hashCode ^
        user_level.hashCode ^
        AUTH.hashCode ^
        sessionId.hashCode;
  }
}
