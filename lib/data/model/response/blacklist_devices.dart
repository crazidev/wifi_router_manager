import 'dart:convert';

import 'package:flutter/foundation.dart';

class BlacklistDModel {
  final Datas datas;
  final bool success;
  final int cmd;
  final String method;
  final String sessionId;
  BlacklistDModel({
    required this.datas,
    required this.success,
    required this.cmd,
    required this.method,
    required this.sessionId,
  });

  BlacklistDModel copyWith({
    Datas? datas,
    bool? success,
    int? cmd,
    String? method,
    String? sessionId,
  }) {
    return BlacklistDModel(
      datas: datas ?? this.datas,
      success: success ?? this.success,
      cmd: cmd ?? this.cmd,
      method: method ?? this.method,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'datas': datas.toMap(),
      'success': success,
      'cmd': cmd,
      'method': method,
      'sessionId': sessionId,
    };
  }

  factory BlacklistDModel.fromMap(Map<String, dynamic> map) {
    return BlacklistDModel(
      datas: Datas.fromMap(map['datas'] as Map<String, dynamic>),
      success: map['success'] as bool,
      cmd: map['cmd'].toInt() as int,
      method: map['method'] as String,
      sessionId: map['sessionId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlacklistDModel.fromJson(String source) =>
      BlacklistDModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BlacklistDModel(datas: $datas, success: $success, cmd: $cmd, method: $method, sessionId: $sessionId)';
  }

  @override
  bool operator ==(covariant BlacklistDModel other) {
    if (identical(this, other)) return true;

    return other.datas == datas &&
        other.success == success &&
        other.cmd == cmd &&
        other.method == method &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    return datas.hashCode ^
        success.hashCode ^
        cmd.hashCode ^
        method.hashCode ^
        sessionId.hashCode;
  }
}

class Datas {
  final List<Maclist> maclist;
  final String macfilter;
  Datas({
    required this.maclist,
    required this.macfilter,
  });

  Datas copyWith({
    List<Maclist>? maclist,
    String? macfilter,
  }) {
    return Datas(
      maclist: maclist ?? this.maclist,
      macfilter: macfilter ?? this.macfilter,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'maclist': maclist.map((x) => x.toMap()).toList(),
      'macfilter': macfilter,
    };
  }

  factory Datas.fromMap(Map<String, dynamic> map) {
    return Datas(
      maclist: List<Maclist>.from(
        (map['maclist'] as List<dynamic>).map<Maclist>(
          (x) => Maclist.fromMap(x as Map<String, dynamic>),
        ),
      ),
      macfilter: map['macfilter'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Datas.fromJson(String source) =>
      Datas.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Datas(maclist: $maclist, macfilter: $macfilter)';

  @override
  bool operator ==(covariant Datas other) {
    if (identical(this, other)) return true;

    return listEquals(other.maclist, maclist) && other.macfilter == macfilter;
  }

  @override
  int get hashCode => maclist.hashCode ^ macfilter.hashCode;
}

class Maclist {
  final String mac;
  Maclist({
    required this.mac,
  });

  Maclist copyWith({
    String? mac,
  }) {
    return Maclist(
      mac: mac ?? this.mac,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mac': mac,
    };
  }

  factory Maclist.fromMap(Map<String, dynamic> map) {
    return Maclist(
      mac: map['mac'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Maclist.fromJson(String source) =>
      Maclist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Maclist(mac: $mac)';

  @override
  bool operator ==(covariant Maclist other) {
    if (identical(this, other)) return true;

    return other.mac == mac;
  }

  @override
  int get hashCode => mac.hashCode;
}
