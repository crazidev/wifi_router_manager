import 'dart:convert';

class FetchTokenModal {
  final bool success;
  final int cmd;
  final String buffer;
  final String token;
  final String netx_login_time;

  FetchTokenModal({
    required this.success,
    required this.cmd,
    required this.buffer,
    required this.token,
    required this.netx_login_time,
  });

  FetchTokenModal copyWith({
    bool? success,
    int? cmd,
    String? buffer,
    String? token,
    String? netx_login_time,
  }) {
    return FetchTokenModal(
      success: success ?? this.success,
      cmd: cmd ?? this.cmd,
      buffer: buffer ?? this.buffer,
      token: token ?? this.token,
      netx_login_time: netx_login_time ?? this.netx_login_time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'cmd': cmd,
      'buffer': buffer,
      'token': token,
      'netx_login_time': netx_login_time,
    };
  }

  factory FetchTokenModal.fromMap(Map<String, dynamic> map) {
    return FetchTokenModal(
      success: map['success'] as bool,
      cmd: map['cmd'].toInt() as int,
      buffer: map['buffer'] as String,
      token: map['token'] as String,
      netx_login_time: map['netx_login_time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FetchTokenModal.fromJson(String source) =>
      FetchTokenModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FetchTokenModal(success: $success, cmd: $cmd, buffer: $buffer, token: $token, netx_login_time: $netx_login_time)';
  }

  @override
  bool operator ==(covariant FetchTokenModal other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.cmd == cmd &&
        other.buffer == buffer &&
        other.token == token &&
        other.netx_login_time == netx_login_time;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        cmd.hashCode ^
        buffer.hashCode ^
        token.hashCode ^
        netx_login_time.hashCode;
  }
}
