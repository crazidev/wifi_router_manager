import 'dart:convert';

// {"success":true,"cmd":350,"need_reply":"1","message":"004f0075007200200063006f006400650073002000680061007600650020006300680061006e006700650064002e0046006f0072000d000a0031002e004400610074006100200050006c0061006e00730020003300310032000d000a0032002e005200650063006800610072006700650020003300310031000d000a0033002e0042006f00720072006f0077002000410069007200740069006d00650020003300300033000d000a0034002e0044006100740061002000420061006c0020003300320033000d000a0035002e0041006300630074002000420061006c0020003300310030000d000a0036002e004d0054004e0020005300680061007200650020003300320031000d000a0037002e0056004100530020003300300035000d000a0038002e004e0049004e0020003900390036000a000a"}

class UssdModel {
  final bool success;
  final int cmd;
  final String need_reply;
  final String message;
  UssdModel({
    required this.success,
    required this.cmd,
    required this.need_reply,
    required this.message,
  });

  UssdModel copyWith({
    bool? success,
    int? cmd,
    String? need_reply,
    String? message,
  }) {
    return UssdModel(
      success: success ?? this.success,
      cmd: cmd ?? this.cmd,
      need_reply: need_reply ?? this.need_reply,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'cmd': cmd,
      'need_reply': need_reply,
      'message': message,
    };
  }

  factory UssdModel.fromMap(Map<String, dynamic> map) {
    return UssdModel(
      success: map['success'] as bool,
      cmd: map['cmd'].toInt() as int,
      need_reply: map['need_reply'] as String,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UssdModel.fromJson(String source) =>
      UssdModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UssdModel(success: $success, cmd: $cmd, need_reply: $need_reply, message: $message)';
  }

  @override
  bool operator ==(covariant UssdModel other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.cmd == cmd &&
        other.need_reply == need_reply &&
        other.message == message;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        cmd.hashCode ^
        need_reply.hashCode ^
        message.hashCode;
  }
}
