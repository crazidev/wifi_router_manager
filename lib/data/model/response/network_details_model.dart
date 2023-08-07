import 'dart:convert';

import 'package:equatable/equatable.dart';

class NetworkDModel extends Equatable {
  final bool success;
  final int cmd;
  final String? network_type_str;
  final String? signal_lvl;
  final String? sim_status;
  final String lock_pin_flag;
  final String lock_puk_flag;
  final String lock_device_flag;
  final String lock_plmn_flag;
  final String idu_dev_type;
  final String board_type;
  final String data_switch;
  final String roam_status;
  final String flowLimitFlag;
  final String volteStatus;
  final String? network_operator;
  final String? network_status;
  final String wlan5g_switch;
  final String wlan5g_switch_0;
  final String wifi_show_display_config;
  final String voice_type;
  final String mesh_agent;
  final String current_card_type;
  final String wanMode;
  NetworkDModel({
    required this.success,
    required this.cmd,
    required this.network_type_str,
    required this.signal_lvl,
    required this.sim_status,
    required this.lock_pin_flag,
    required this.lock_puk_flag,
    required this.lock_device_flag,
    required this.lock_plmn_flag,
    required this.idu_dev_type,
    required this.board_type,
    required this.data_switch,
    required this.roam_status,
    required this.flowLimitFlag,
    required this.volteStatus,
    required this.network_operator,
    required this.network_status,
    required this.wlan5g_switch,
    required this.wlan5g_switch_0,
    required this.wifi_show_display_config,
    required this.voice_type,
    required this.mesh_agent,
    required this.current_card_type,
    required this.wanMode,
  });

  NetworkDModel copyWith({
    bool? success,
    int? cmd,
    String? network_type_str,
    String? signal_lvl,
    String? sim_status,
    String? lock_pin_flag,
    String? lock_puk_flag,
    String? lock_device_flag,
    String? lock_plmn_flag,
    String? idu_dev_type,
    String? board_type,
    String? data_switch,
    String? roam_status,
    String? flowLimitFlag,
    String? volteStatus,
    String? network_operator,
    String? network_status,
    String? wlan5g_switch,
    String? wlan5g_switch_0,
    String? wifi_show_display_config,
    String? voice_type,
    String? mesh_agent,
    String? current_card_type,
    String? wanMode,
  }) {
    return NetworkDModel(
      success: success ?? this.success,
      cmd: cmd ?? this.cmd,
      network_type_str: network_type_str ?? this.network_type_str,
      signal_lvl: signal_lvl ?? this.signal_lvl,
      sim_status: sim_status ?? this.sim_status,
      lock_pin_flag: lock_pin_flag ?? this.lock_pin_flag,
      lock_puk_flag: lock_puk_flag ?? this.lock_puk_flag,
      lock_device_flag: lock_device_flag ?? this.lock_device_flag,
      lock_plmn_flag: lock_plmn_flag ?? this.lock_plmn_flag,
      idu_dev_type: idu_dev_type ?? this.idu_dev_type,
      board_type: board_type ?? this.board_type,
      data_switch: data_switch ?? this.data_switch,
      roam_status: roam_status ?? this.roam_status,
      flowLimitFlag: flowLimitFlag ?? this.flowLimitFlag,
      volteStatus: volteStatus ?? this.volteStatus,
      network_operator: network_operator ?? this.network_operator,
      network_status: network_status ?? this.network_status,
      wlan5g_switch: wlan5g_switch ?? this.wlan5g_switch,
      wlan5g_switch_0: wlan5g_switch_0 ?? this.wlan5g_switch_0,
      wifi_show_display_config:
          wifi_show_display_config ?? this.wifi_show_display_config,
      voice_type: voice_type ?? this.voice_type,
      mesh_agent: mesh_agent ?? this.mesh_agent,
      current_card_type: current_card_type ?? this.current_card_type,
      wanMode: wanMode ?? this.wanMode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'cmd': cmd,
      'network_type_str': network_type_str,
      'signal_lvl': signal_lvl,
      'sim_status': sim_status,
      'lock_pin_flag': lock_pin_flag,
      'lock_puk_flag': lock_puk_flag,
      'lock_device_flag': lock_device_flag,
      'lock_plmn_flag': lock_plmn_flag,
      'idu_dev_type': idu_dev_type,
      'board_type': board_type,
      'data_switch': data_switch,
      'roam_status': roam_status,
      'flowLimitFlag': flowLimitFlag,
      'volteStatus': volteStatus,
      'network_operator': network_operator,
      'network_status': network_status,
      'wlan5g_switch': wlan5g_switch,
      'wlan5g_switch_0': wlan5g_switch_0,
      'wifi_show_display_config': wifi_show_display_config,
      'voice_type': voice_type,
      'mesh_agent': mesh_agent,
      'current_card_type': current_card_type,
      'wanMode': wanMode,
    };
  }

  factory NetworkDModel.fromMap(Map<String, dynamic> map) {
    return NetworkDModel(
      success: map['success'] as bool,
      cmd: map['cmd'].toInt() as int,
      network_type_str: map['network_type_str'] as String,
      signal_lvl: map['signal_lvl'] as String,
      sim_status: map['sim_status'] as String,
      lock_pin_flag: map['lock_pin_flag'] as String,
      lock_puk_flag: map['lock_puk_flag'] as String,
      lock_device_flag: map['lock_device_flag'] as String,
      lock_plmn_flag: map['lock_plmn_flag'] as String,
      idu_dev_type: map['idu_dev_type'] as String,
      board_type: map['board_type'] as String,
      data_switch: map['data_switch'] as String,
      roam_status: map['roam_status'] as String,
      flowLimitFlag: map['flowLimitFlag'] as String,
      volteStatus: map['volteStatus'] as String,
      network_operator: map['network_operator'] as String,
      network_status: map['network_status'] as String,
      wlan5g_switch: map['wlan5g_switch'] as String,
      wlan5g_switch_0: map['wlan5g_switch_0'] as String,
      wifi_show_display_config: map['wifi_show_display_config'] as String,
      voice_type: map['voice_type'] as String,
      mesh_agent: map['mesh_agent'] as String,
      current_card_type: map['current_card_type'] as String,
      wanMode: map['wanMode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NetworkDModel.fromJson(String source) =>
      NetworkDModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NetworkDModel(success: $success, cmd: $cmd, network_type_str: $network_type_str, signal_lvl: $signal_lvl, sim_status: $sim_status, lock_pin_flag: $lock_pin_flag, lock_puk_flag: $lock_puk_flag, lock_device_flag: $lock_device_flag, lock_plmn_flag: $lock_plmn_flag, idu_dev_type: $idu_dev_type, board_type: $board_type, data_switch: $data_switch, roam_status: $roam_status, flowLimitFlag: $flowLimitFlag, volteStatus: $volteStatus, network_operator: $network_operator, network_status: $network_status, wlan5g_switch: $wlan5g_switch, wlan5g_switch_0: $wlan5g_switch_0, wifi_show_display_config: $wifi_show_display_config, voice_type: $voice_type, mesh_agent: $mesh_agent, current_card_type: $current_card_type, wanMode: $wanMode)';
  }

  @override
  bool operator ==(covariant NetworkDModel other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.cmd == cmd &&
        other.network_type_str == network_type_str &&
        other.signal_lvl == signal_lvl &&
        other.sim_status == sim_status &&
        other.lock_pin_flag == lock_pin_flag &&
        other.lock_puk_flag == lock_puk_flag &&
        other.lock_device_flag == lock_device_flag &&
        other.lock_plmn_flag == lock_plmn_flag &&
        other.idu_dev_type == idu_dev_type &&
        other.board_type == board_type &&
        other.data_switch == data_switch &&
        other.roam_status == roam_status &&
        other.flowLimitFlag == flowLimitFlag &&
        other.volteStatus == volteStatus &&
        other.network_operator == network_operator &&
        other.network_status == network_status &&
        other.wlan5g_switch == wlan5g_switch &&
        other.wlan5g_switch_0 == wlan5g_switch_0 &&
        other.wifi_show_display_config == wifi_show_display_config &&
        other.voice_type == voice_type &&
        other.mesh_agent == mesh_agent &&
        other.current_card_type == current_card_type &&
        other.wanMode == wanMode;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        cmd.hashCode ^
        network_type_str.hashCode ^
        signal_lvl.hashCode ^
        sim_status.hashCode ^
        lock_pin_flag.hashCode ^
        lock_puk_flag.hashCode ^
        lock_device_flag.hashCode ^
        lock_plmn_flag.hashCode ^
        idu_dev_type.hashCode ^
        board_type.hashCode ^
        data_switch.hashCode ^
        roam_status.hashCode ^
        flowLimitFlag.hashCode ^
        volteStatus.hashCode ^
        network_operator.hashCode ^
        network_status.hashCode ^
        wlan5g_switch.hashCode ^
        wlan5g_switch_0.hashCode ^
        wifi_show_display_config.hashCode ^
        voice_type.hashCode ^
        mesh_agent.hashCode ^
        current_card_type.hashCode ^
        wanMode.hashCode;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
