import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../controller/home_controller.dart';

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
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        centerTitle: false,
        title: Text("Devices (5)").marginOnly(top: 10),
        actions: [
          // IconButton(onPressed: () {}, icon: Icon(Ionicons.trash_bin_outline)),
        ],
        bottom: PreferredSize(
            child: Divider(
              color: AppColor.container,
            ),
            preferredSize: Size.fromHeight(5)),
      ),
      body: SingleChildScrollView(
        child: Stack(
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
                child: homeController.connectedDevices?.dhcp_list_info == null
                    ? SizedBox()
                    : GetBuilder(
                        init: homeController,
                        builder: (context) {
                          return Column(
                            children: [
                              Column(
                                children: List.from(homeController
                                    .connectedDevices!.dhcp_list_info
                                    .map((e) {
                                  return DeviceList(
                                    data: {
                                      'name': e.hostname,
                                      'ip': e.ip,
                                      'mac': e.mac,
                                      'selected': false,
                                      'blocked': false,
                                    },
                                    onclick: () {},
                                  ).marginOnly(bottom: 10);
                                })),
                              ),
                              Column(
                                children: List.from(homeController
                                    .blacklistDModel!.datas.maclist
                                    .map((e) {
                                  return DeviceList(
                                    data: {
                                      'name': e.mac,
                                      'selected': false,
                                      'blocked': true,
                                    },
                                    onclick: () {},
                                  ).marginOnly(bottom: 10);
                                })),
                              ),
                            ],
                          );
                        })),
          ],
        ),
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
            subtitle: data['blocked']
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "IP: ${data['ip']}",
                        style: TextStyle(
                          color: AppColor.dim,
                        ),
                      ),
                      Text(
                        "${data['mac']}",
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
