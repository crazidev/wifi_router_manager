import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class ConnectedDModel {
  final bool success;
  final int cmd;
  final String lanIp;
  final String maxNum4;
  final String txPower4;
  final String maxNum5;
  final String txPower5;
  final String ssid24;
  final String ssid58;
  final String wifi24g_maxNum_0;
  final String wifi58g_maxNum_0;
  final List<Dhcp_list_info> dhcp_list_info;
  final String uptime;
  final String RSRP;
  final String RSRP_5G;
  final String sentSpeed;
  final String receiveSpeed;
  final String module_imei;
  final String IMSI;
  final String device_sn;
  final String RSSI;
  final String RSSI_5G;
  final String wan_ip;
  final String fake_version;
  final String hwversion;
  final String network_type_str;
  final String signal_lvl;
  final String ulSpeed;
  final String dlSpeed;
  final String sim_status;
  ConnectedDModel({
    required this.success,
    required this.cmd,
    required this.lanIp,
    required this.maxNum4,
    required this.txPower4,
    required this.maxNum5,
    required this.txPower5,
    required this.ssid24,
    required this.ssid58,
    required this.wifi24g_maxNum_0,
    required this.wifi58g_maxNum_0,
    required this.dhcp_list_info,
    required this.uptime,
    required this.RSRP,
    required this.RSRP_5G,
    required this.sentSpeed,
    required this.receiveSpeed,
    required this.module_imei,
    required this.IMSI,
    required this.device_sn,
    required this.RSSI,
    required this.RSSI_5G,
    required this.wan_ip,
    required this.fake_version,
    required this.hwversion,
    required this.network_type_str,
    required this.signal_lvl,
    required this.ulSpeed,
    required this.dlSpeed,
    required this.sim_status,
  });

  ConnectedDModel copyWith({
    bool? success,
    int? cmd,
    String? lanIp,
    String? maxNum4,
    String? txPower4,
    String? maxNum5,
    String? txPower5,
    String? ssid24,
    String? ssid58,
    String? wifi24g_maxNum_0,
    String? wifi58g_maxNum_0,
    List<Dhcp_list_info>? dhcp_list_info,
    String? uptime,
    String? RSRP,
    String? RSRP_5G,
    String? sentSpeed,
    String? receiveSpeed,
    String? module_imei,
    String? IMSI,
    String? device_sn,
    String? RSSI,
    String? RSSI_5G,
    String? wan_ip,
    String? fake_version,
    String? hwversion,
    String? network_type_str,
    String? signal_lvl,
    String? ulSpeed,
    String? dlSpeed,
    String? sim_status,
  }) {
    return ConnectedDModel(
      success: success ?? this.success,
      cmd: cmd ?? this.cmd,
      lanIp: lanIp ?? this.lanIp,
      maxNum4: maxNum4 ?? this.maxNum4,
      txPower4: txPower4 ?? this.txPower4,
      maxNum5: maxNum5 ?? this.maxNum5,
      txPower5: txPower5 ?? this.txPower5,
      ssid24: ssid24 ?? this.ssid24,
      ssid58: ssid58 ?? this.ssid58,
      wifi24g_maxNum_0: wifi24g_maxNum_0 ?? this.wifi24g_maxNum_0,
      wifi58g_maxNum_0: wifi58g_maxNum_0 ?? this.wifi58g_maxNum_0,
      dhcp_list_info: dhcp_list_info ?? this.dhcp_list_info,
      uptime: uptime ?? this.uptime,
      RSRP: RSRP ?? this.RSRP,
      RSRP_5G: RSRP_5G ?? this.RSRP_5G,
      sentSpeed: sentSpeed ?? this.sentSpeed,
      receiveSpeed: receiveSpeed ?? this.receiveSpeed,
      module_imei: module_imei ?? this.module_imei,
      IMSI: IMSI ?? this.IMSI,
      device_sn: device_sn ?? this.device_sn,
      RSSI: RSSI ?? this.RSSI,
      RSSI_5G: RSSI_5G ?? this.RSSI_5G,
      wan_ip: wan_ip ?? this.wan_ip,
      fake_version: fake_version ?? this.fake_version,
      hwversion: hwversion ?? this.hwversion,
      network_type_str: network_type_str ?? this.network_type_str,
      signal_lvl: signal_lvl ?? this.signal_lvl,
      ulSpeed: ulSpeed ?? this.ulSpeed,
      dlSpeed: dlSpeed ?? this.dlSpeed,
      sim_status: sim_status ?? this.sim_status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'cmd': cmd,
      'lanIp': lanIp,
      'maxNum4': maxNum4,
      'txPower4': txPower4,
      'maxNum5': maxNum5,
      'txPower5': txPower5,
      'ssid24': ssid24,
      'ssid58': ssid58,
      'wifi24g_maxNum_0': wifi24g_maxNum_0,
      'wifi58g_maxNum_0': wifi58g_maxNum_0,
      'dhcp_list_info': dhcp_list_info.map((x) => x.toMap()).toList(),
      'uptime': uptime,
      'RSRP': RSRP,
      'RSRP_5G': RSRP_5G,
      'sentSpeed': sentSpeed,
      'receiveSpeed': receiveSpeed,
      'module_imei': module_imei,
      'IMSI': IMSI,
      'device_sn': device_sn,
      'RSSI': RSSI,
      'RSSI_5G': RSSI_5G,
      'wan_ip': wan_ip,
      'fake_version': fake_version,
      'hwversion': hwversion,
      'network_type_str': network_type_str,
      'signal_lvl': signal_lvl,
      'ulSpeed': ulSpeed,
      'dlSpeed': dlSpeed,
      'sim_status': sim_status,
    };
  }

  factory ConnectedDModel.fromMap(Map<String, dynamic> map) {
    return ConnectedDModel(
      success: map['success'] as bool,
      cmd: map['cmd'].toInt() as int,
      lanIp: map['lanIp'] as String,
      maxNum4: map['maxNum4'] as String,
      txPower4: map['txPower4'] as String,
      maxNum5: map['maxNum5'] as String,
      txPower5: map['txPower5'] as String,
      ssid24: map['ssid24'] as String,
      ssid58: map['ssid58'] as String,
      wifi24g_maxNum_0: map['wifi24g_maxNum_0'] as String,
      wifi58g_maxNum_0: map['wifi58g_maxNum_0'] as String,
      dhcp_list_info: List<Dhcp_list_info>.from(
        (map['dhcp_list_info'] as List<dynamic>).map<Dhcp_list_info>(
          (x) => Dhcp_list_info.fromMap(x as Map<String, dynamic>),
        ),
      ),
      uptime: map['uptime'] as String,
      RSRP: map['RSRP'] as String,
      RSRP_5G: map['RSRP_5G'] as String,
      sentSpeed: map['sentSpeed'] as String,
      receiveSpeed: map['receiveSpeed'] as String,
      module_imei: map['module_imei'] as String,
      IMSI: map['IMSI'] as String,
      device_sn: map['device_sn'] as String,
      RSSI: map['RSSI'] as String,
      RSSI_5G: map['RSSI_5G'] as String,
      wan_ip: map['wan_ip'] as String,
      fake_version: map['fake_version'] as String,
      hwversion: map['hwversion'] as String,
      network_type_str: map['network_type_str'] as String,
      signal_lvl: map['signal_lvl'] as String,
      ulSpeed: map['ulSpeed'] as String,
      dlSpeed: map['dlSpeed'] as String,
      sim_status: map['sim_status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConnectedDModel.fromJson(String source) =>
      ConnectedDModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ConnectedDModel(success: $success, cmd: $cmd, lanIp: $lanIp, maxNum4: $maxNum4, txPower4: $txPower4, maxNum5: $maxNum5, txPower5: $txPower5, ssid24: $ssid24, ssid58: $ssid58, wifi24g_maxNum_0: $wifi24g_maxNum_0, wifi58g_maxNum_0: $wifi58g_maxNum_0, dhcp_list_info: $dhcp_list_info, uptime: $uptime, RSRP: $RSRP, RSRP_5G: $RSRP_5G, sentSpeed: $sentSpeed, receiveSpeed: $receiveSpeed, module_imei: $module_imei, IMSI: $IMSI, device_sn: $device_sn, RSSI: $RSSI, RSSI_5G: $RSSI_5G, wan_ip: $wan_ip, fake_version: $fake_version, hwversion: $hwversion, network_type_str: $network_type_str, signal_lvl: $signal_lvl, ulSpeed: $ulSpeed, dlSpeed: $dlSpeed, sim_status: $sim_status)';
  }

  @override
  bool operator ==(covariant ConnectedDModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.success == success &&
        other.cmd == cmd &&
        other.lanIp == lanIp &&
        other.maxNum4 == maxNum4 &&
        other.txPower4 == txPower4 &&
        other.maxNum5 == maxNum5 &&
        other.txPower5 == txPower5 &&
        other.ssid24 == ssid24 &&
        other.ssid58 == ssid58 &&
        other.wifi24g_maxNum_0 == wifi24g_maxNum_0 &&
        other.wifi58g_maxNum_0 == wifi58g_maxNum_0 &&
        listEquals(other.dhcp_list_info, dhcp_list_info) &&
        other.uptime == uptime &&
        other.RSRP == RSRP &&
        other.RSRP_5G == RSRP_5G &&
        other.sentSpeed == sentSpeed &&
        other.receiveSpeed == receiveSpeed &&
        other.module_imei == module_imei &&
        other.IMSI == IMSI &&
        other.device_sn == device_sn &&
        other.RSSI == RSSI &&
        other.RSSI_5G == RSSI_5G &&
        other.wan_ip == wan_ip &&
        other.fake_version == fake_version &&
        other.hwversion == hwversion &&
        other.network_type_str == network_type_str &&
        other.signal_lvl == signal_lvl &&
        other.ulSpeed == ulSpeed &&
        other.dlSpeed == dlSpeed &&
        other.sim_status == sim_status;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        cmd.hashCode ^
        lanIp.hashCode ^
        maxNum4.hashCode ^
        txPower4.hashCode ^
        maxNum5.hashCode ^
        txPower5.hashCode ^
        ssid24.hashCode ^
        ssid58.hashCode ^
        wifi24g_maxNum_0.hashCode ^
        wifi58g_maxNum_0.hashCode ^
        dhcp_list_info.hashCode ^
        uptime.hashCode ^
        RSRP.hashCode ^
        RSRP_5G.hashCode ^
        sentSpeed.hashCode ^
        receiveSpeed.hashCode ^
        module_imei.hashCode ^
        IMSI.hashCode ^
        device_sn.hashCode ^
        RSSI.hashCode ^
        RSSI_5G.hashCode ^
        wan_ip.hashCode ^
        fake_version.hashCode ^
        hwversion.hashCode ^
        network_type_str.hashCode ^
        signal_lvl.hashCode ^
        ulSpeed.hashCode ^
        dlSpeed.hashCode ^
        sim_status.hashCode;
  }
}

class Dhcp_list_info {
  final String mac;
  final String ip;
  final String hostname;
  final String interface;
  final String expires;
  final String flow;
  Dhcp_list_info({
    required this.mac,
    required this.ip,
    required this.hostname,
    required this.interface,
    required this.expires,
    required this.flow,
  });

  Dhcp_list_info copyWith({
    String? mac,
    String? ip,
    String? hostname,
    String? interface,
    String? expires,
    String? flow,
  }) {
    return Dhcp_list_info(
      mac: mac ?? this.mac,
      ip: ip ?? this.ip,
      hostname: hostname ?? this.hostname,
      interface: interface ?? this.interface,
      expires: expires ?? this.expires,
      flow: flow ?? this.flow,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mac': mac,
      'ip': ip,
      'hostname': hostname,
      'interface': interface,
      'expires': expires,
      'flow': flow,
    };
  }

  factory Dhcp_list_info.fromMap(Map<String, dynamic> map) {
    return Dhcp_list_info(
      mac: map['mac'] as String,
      ip: map['ip'] as String,
      hostname: map['hostname'] as String,
      interface: map['interface'] as String,
      expires: map['expires'] as String,
      flow: map['flow'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Dhcp_list_info.fromJson(String source) =>
      Dhcp_list_info.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Dhcp_list_info(mac: $mac, ip: $ip, hostname: $hostname, interface: $interface, expires: $expires, flow: $flow)';
  }

  @override
  bool operator ==(covariant Dhcp_list_info other) {
    if (identical(this, other)) return true;

    return other.mac == mac &&
        other.ip == ip &&
        other.hostname == hostname &&
        other.interface == interface &&
        other.expires == expires &&
        other.flow == flow;
  }

  @override
  int get hashCode {
    return mac.hashCode ^
        ip.hashCode ^
        hostname.hashCode ^
        interface.hashCode ^
        expires.hashCode ^
        flow.hashCode;
  }
}
