import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class Devices extends StatelessWidget {
  Devices({super.key});

  List devices = [
    {
      'name': 'MacBook Pro',
      'ip': '192.333.452.2',
      'mac': '34:dd:d4:4f:45',
      'selected': false,
      'blocked': false,
    },
    {
      'name': 'Crazibeat Phone',
      'ip': '192.333.452.2',
      'mac': '34:dd:d4:4f:45',
      'selected': false,
      'blocked': true,
    },
    {
      'name': 'Richie Phone',
      'ip': '192.333.452.2',
      'mac': '34:dd:d4:4f:45',
      'selected': false,
      'blocked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        title: Text("Connected Devices (5)").marginOnly(top: 10),
        actions: [
          // IconButton(onPressed: () {}, icon: Icon(Ionicons.trash_bin_outline)),
        ],
        bottom: PreferredSize(
            child: Divider(
              color: AppColor.container,
            ),
            preferredSize: Size.fromHeight(5)),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: -300,
            child: Image.asset(
              'assets/5076404.jpg',
              // fit: BoxFit.,
              opacity: AlwaysStoppedAnimation(0.2),
              width: 1400,
              // height: ,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.from(devices.map((e) => DeviceList(
                    data: e,
                    onclick: () {},
                  ).marginOnly(bottom: 10))),
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({
    super.key,
    this.data,
    required this.onclick,
  });

  final dynamic data;
  final Function() onclick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
            duration: Duration(milliseconds: 400),
            width: data['selected'] ? 30 : 0,
            margin: EdgeInsets.only(right: data['selected'] ? 10 : 0),
            child: data['selected'] ? Icon(Ionicons.checkmark_circle) : null),
        Expanded(
          child: ListTile(
            onTap: onclick,
            selected: data['selected'],
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: AppColor.container,
            iconColor: AppColor.dim,
            leading: Icon(
              SimpleLineIcons.screen_desktop,
            ),
            title: Text(
              data['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            minLeadingWidth: 40,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {}, icon: Icon(Ionicons.trash_outline)),
                SizedBox(
                    width: 40,
                    child: FittedBox(
                        child: Switch(
                            value: !data['blocked'], onChanged: (value) {}))),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "IP: ${data['ip']}",
                  style: TextStyle(
                    color: AppColor.dim,
                  ),
                ),
                Text(
                  "MAC: ${data['mac']}",
                  style: TextStyle(
                    color: AppColor.dim,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
