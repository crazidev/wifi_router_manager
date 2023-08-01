import 'dart:convert';

class SmsModel {
  final bool success;
  final int cmd;
  final List sms_list;
  final String sms_total;
  final String sms_unread;
  final String receive_full;
  final String send_full;
  SmsModel({
    required this.success,
    required this.cmd,
    required this.sms_list,
    required this.sms_total,
    required this.sms_unread,
    required this.receive_full,
    required this.send_full,
  });

  SmsModel copyWith({
    bool? success,
    int? cmd,
    List? sms_list,
    String? sms_total,
    String? sms_unread,
    String? receive_full,
    String? send_full,
  }) {
    return SmsModel(
      success: success ?? this.success,
      cmd: cmd ?? this.cmd,
      sms_list: sms_list ?? this.sms_list,
      sms_total: sms_total ?? this.sms_total,
      sms_unread: sms_unread ?? this.sms_unread,
      receive_full: receive_full ?? this.receive_full,
      send_full: send_full ?? this.send_full,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'cmd': cmd,
      'sms_list': sms_list,
      'sms_total': sms_total,
      'sms_unread': sms_unread,
      'receive_full': receive_full,
      'send_full': send_full,
    };
  }

  factory SmsModel.fromMap(Map<String, dynamic> map) {
    return SmsModel(
      success: map['success'] as bool,
      cmd: map['cmd'].toInt() as int,
      sms_list: map['sms_list'].toString().split(','),
      sms_total: map['sms_total'] as String,
      sms_unread: map['sms_unread'] as String,
      receive_full: map['receive_full'] as String,
      send_full: map['send_full'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SmsModel.fromJson(String source) =>
      SmsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SmsModel(success: $success, cmd: $cmd, sms_list: $sms_list, sms_total: $sms_total, sms_unread: $sms_unread, receive_full: $receive_full, send_full: $send_full)';
  }

  @override
  bool operator ==(covariant SmsModel other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.cmd == cmd &&
        other.sms_list == sms_list &&
        other.sms_total == sms_total &&
        other.sms_unread == sms_unread &&
        other.receive_full == receive_full &&
        other.send_full == send_full;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        cmd.hashCode ^
        sms_list.hashCode ^
        sms_total.hashCode ^
        sms_unread.hashCode ^
        receive_full.hashCode ^
        send_full.hashCode;
  }
}
