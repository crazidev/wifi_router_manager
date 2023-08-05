import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:router_manager/core/app_export.dart';

import '../../controller/home_controller.dart';

class Devices extends StatelessWidget {
  Devices({super.key});

  HomeController homeController = Get.put(HomeController());

  var selectedBlackList = [].obs;
  var selectedWhiteList = [].obs;
  // var selectAll = false;

  var isExpanded = false.obs;
  // get thisDevice async => await NetworkInterface.list(
  //                                 type: InternetAddressType.IPv4,
  //                                 includeLinkLocal: true)
  //                             .then((value) =>
  //                                 value.last.addresses.first.address);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        centerTitle: false,
        title: Text(
                "Devices (${homeController.connectedDevices?.dhcp_list_info.length ?? "0"})")
            .marginOnly(top: 10),
        actions: [
          Obx(() => Row(
                children: [
                  if (selectedBlackList.isNotEmpty) ...[
                    TextButton(
                        onPressed: () async {
                          if (selectedBlackList.isNotEmpty) {
                            homeController.unblockDevices(selectedBlackList);
                          }
                        },
                        child: Text("Unblock (${selectedBlackList.length})"))
                  ],
                  if (selectedWhiteList.isNotEmpty) ...[
                    TextButton(
                        onPressed: () async {
                          if (selectedWhiteList.isNotEmpty) {
                            homeController.blockDevices(selectedWhiteList);
                          }
                        },
                        child: Text("Block (${selectedWhiteList.length})"))
                  ]
                ],
              ))
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5),
            child: Divider(
              color: AppColor.container,
            )),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: homeController.connectedDevices?.dhcp_list_info == null
                    ? const SizedBox()
                    : GetBuilder(
                        init: homeController,
                        builder: (_) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Column(
                                  children: List.from(homeController
                                      .connectedDevices!.dhcp_list_info
                                      .map((e) {
                                    var selected = false;

                                    selectedWhiteList.forEach((e2) {
                                      if (e.mac == e2) {
                                        selected = true;
                                      }
                                    });
                                    return DeviceList(
                                      data: {
                                        'name': e.hostname,
                                        'ip': e.ip,
                                        'mac': e.mac,
                                        'selected': selected,
                                        'blocked': false,
                                      },
                                      onclick: () {
                                        if (selectedWhiteList.isNotEmpty) {
                                          if (selected) {
                                            selectedWhiteList.remove(e.mac);
                                          } else {
                                            selectedWhiteList.add(e.mac);
                                          }
                                        }
                                      },
                                      onSwitch: (value) {},
                                      onLongPress: () {
                                        if (selectedBlackList.isNotEmpty) {
                                          selectedBlackList.clear();
                                        }

                                        selectedWhiteList.add(e.mac);
                                      },
                                    ).marginOnly(bottom: 10);
                                  })),
                                ),
                              ),
                              Obx(() {
                                var i = selectedBlackList;
                                return homeController
                                            .blacklistDModel?.datas.maclist ==
                                        null
                                    ? const SizedBox()
                                    : ExpansionPanelList(
                                        expandedHeaderPadding: EdgeInsets.zero,
                                        animationDuration:
                                            const Duration(milliseconds: 300),
                                        elevation: 0,
                                        expansionCallback: (index, value) {
                                          isExpanded.value = !isExpanded.value;
                                        },
                                        children: [
                                          ExpansionPanel(
                                              backgroundColor:
                                                  Colors.transparent,
                                              isExpanded: true,
                                              headerBuilder:
                                                  (BuildContext context,
                                                      bool expanded) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Blocked (${homeController.blacklistDModel!.datas.maclist.length})",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge,
                                                    ).marginOnly(
                                                        top: 20, bottom: 10),
                                                  ],
                                                );
                                              },
                                              body: Obx(() {
                                                var i = selectedBlackList.value;
                                                return Column(children: [
                                                  for (var i = 0;
                                                      i <
                                                          homeController
                                                              .blacklistDModel!
                                                              .datas
                                                              .maclist
                                                              .length;
                                                      i++)
                                                    Builder(builder: (context) {
                                                      var data = homeController
                                                          .blacklistDModel!
                                                          .datas
                                                          .maclist
                                                          .elementAt(i);

                                                      var selected = false;

                                                      selectedBlackList
                                                          .forEach((e) {
                                                        if (e == data.mac) {
                                                          selected = true;
                                                        }
                                                      });
                                                      return DeviceList(
                                                        data: {
                                                          'name': data.mac,
                                                          'selected': selected,
                                                          'blocked': true,
                                                        },
                                                        onclick: () {
                                                          if (selectedBlackList
                                                              .isNotEmpty) {
                                                            if (selected) {
                                                              selectedBlackList
                                                                  .remove(
                                                                      data.mac);
                                                            } else {
                                                              selectedBlackList
                                                                  .add(
                                                                      data.mac);
                                                            }
                                                          }
                                                        },
                                                        onSwitch: (value) {},
                                                        onLongPress: () {
                                                          if (selectedWhiteList
                                                              .isNotEmpty) {
                                                            selectedWhiteList
                                                                .clear();
                                                          }
                                                          selectedBlackList
                                                              .add(data.mac);
                                                        },
                                                      ).marginOnly(bottom: 10);
                                                    }),
                                                ]);
                                              })),
                                        ],
                                      );
                              }),
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
    required this.onSwitch,
    required this.onLongPress,
  });

  final dynamic data;
  final Function() onclick;
  final ValueChanged onSwitch;
  final Function() onLongPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: data['selected'] ? 30 : 0,
            margin: EdgeInsets.only(right: data['selected'] ? 10 : 0),
            child: data['selected']
                ? const Icon(Ionicons.checkmark_circle)
                : null),
        Expanded(
          child: ListTile(
            onTap: onclick,
            onLongPress: onLongPress,
            selected: data['selected'],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: AppColor.container,
            iconColor: AppColor.dim,
            leading: const Icon(
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
                // IconButton(
                //     onPressed: () {}, icon: Icon(Ionicons.trash_outline)),
                AvatarGlow(
                  endRadius: 20,
                  animate: data['blocked'] ? false : true,
                  glowColor: Colors.green,
                  showTwoGlows: false,
                  child: Icon(
                    Icons.circle_sharp,
                    color: data['blocked'] ? AppColor.dim : Colors.green,
                    size: 10,
                  ),
                )
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
