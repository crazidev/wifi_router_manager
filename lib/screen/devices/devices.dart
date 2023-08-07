import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/core/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/home_controller.dart';
import '../../core/app_constant.dart';

class Devices extends StatelessWidget {
  Devices({super.key});

  HomeController homeController = Get.put(HomeController());

  var selectedBlackList = [].obs;
  var selectedWhiteList = [].obs;
  var deviceIP = '';
  // var selectAll = false;

  var isExpanded = false.obs;

  setIP() async {
    await NetworkInterface.list(
            type: InternetAddressType.IPv4, includeLinkLocal: true)
        .then((value) {
      deviceIP = value.last.addresses.first.address;
    });
  }

  refreshState() {
    homeController.update(['devices']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        centerTitle: false,
        title: GetBuilder(
            id: 'stats',
            init: homeController,
            builder: (context) {
              return Text(
                      "Devices (${homeController.connectedDevices?.dhcp_list_info.length ?? "0"})")
                  .marginOnly(top: 10);
            }),
        actions: [
          Obx(() => Row(
                children: [
                  if (selectedBlackList.isNotEmpty) ...[
                    TextButton(
                        onPressed: () async {
                          if (selectedBlackList.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (_) => CupertinoAlertDialog(
                                      content: Text(
                                          'Are you sure you unblock this ${selectedBlackList.length > 1 ? "devices" : "device"}??'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Helper().showPreloader(context,
                                                title: "Restarting Router");
                                            selectedBlackList.clear();
                                            homeController.unblockDevices(
                                                selectedBlackList);
                                            Timer(const Duration(seconds: 3),
                                                () {
                                              Navigator.pop(context);
                                              CherryToast.success(
                                                title: const Text(
                                                    'This devices have been unblocked'),
                                                shadowColor: AppColor.bg,
                                                animationType:
                                                    AnimationType.fromTop,
                                                animationDuration:
                                                    const Duration(
                                                        milliseconds: 700),
                                                backgroundColor:
                                                    AppColor.container,
                                              ).show(context);
                                            });
                                          },
                                          child: const Text('Unblock'),
                                        ),
                                      ],
                                    ));
                          }
                        },
                        child: Text("Unblock (${selectedBlackList.length})")),
                  ],
                  if (selectedWhiteList.isNotEmpty) ...[
                    TextButton(
                        onPressed: () async {
                          if (selectedWhiteList.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (_) => CupertinoAlertDialog(
                                      content: Text(
                                          'Are you sure you block this ${selectedWhiteList.length > 1 ? "devices" : "device"}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Helper().showPreloader(context,
                                                title: "Restarting Router");
                                            selectedWhiteList.clear();
                                            homeController.blockDevices(
                                                selectedWhiteList);
                                            Timer(const Duration(seconds: 3),
                                                () {
                                              Navigator.pop(context);
                                              CherryToast.success(
                                                title: const Text(
                                                    'This devices have been blocked from using the router'),
                                                shadowColor: AppColor.bg,
                                                animationType:
                                                    AnimationType.fromTop,
                                                animationDuration:
                                                    const Duration(
                                                        milliseconds: 700),
                                                backgroundColor:
                                                    AppColor.container,
                                              ).show(context);
                                            });
                                          },
                                          child: const Text('Block'),
                                        ),
                                      ],
                                    ));
                          }
                        },
                        child: Text("Block (${selectedWhiteList.length})"))
                  ]
                ],
              )),
          PopupMenuButton(
            // surfaceTintColor: AppColor.bg,
            position: PopupMenuPosition.under,
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text("Clear Custom Names"),
                value: 0,
              ),
              // PopupMenuItem(child: Text("Clear Devices")),
            ],
            onSelected: (value) {
              if (value == 0) {
                homeController.prefs
                    .remove(AppConstant.customDeviceName)
                    .then((value) {
                  CherryToast.success(
                    title: const Text('Cleared succesfully'),
                    shadowColor: AppColor.bg,
                    animationType: AnimationType.fromTop,
                    animationDuration: const Duration(milliseconds: 700),
                    backgroundColor: AppColor.container,
                  ).show(context);
                });
              }
            },
          )
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
                        id: 'devices',
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

                                    if (deviceIP == '') {
                                      setIP();
                                    }

                                    selectedWhiteList.forEach((e2) {
                                      if (e.mac == e2) {
                                        selected = true;
                                      }
                                    });

                                    String? customName;

                                    List<String>? list = homeController.prefs
                                        .getStringList(
                                            AppConstant.customDeviceName);

                                    if (list != null)
                                      // ignore: curly_braces_in_flow_control_structures
                                      for (var i = 0; i < list.length; i++) {
                                        if (jsonDecode(
                                                list.elementAt(i))['mac'] ==
                                            e.mac) {
                                          customName = jsonDecode(
                                              list.elementAt(i))['name'];
                                        }
                                      }

                                    return DeviceList(
                                      data: {
                                        'name': () {
                                          if (customName != null) {
                                            return customName;
                                          } else {
                                            return e.hostname == "*"
                                                ? e.ip
                                                : e.hostname;
                                          }
                                        }(),
                                        'ip': e.ip,
                                        'mac': e.mac,
                                        'selected': selected,
                                        'blocked': false,
                                      },
                                      lable: deviceIP == e.ip
                                          ? "This device"
                                          : null,
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
                                              isExpanded: isExpanded.value,
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

                                                      String? customName;

                                                      List<String>? list =
                                                          homeController.prefs
                                                              .getStringList(
                                                                  AppConstant
                                                                      .customDeviceName);

                                                      if (list != null) {
                                                        for (var i = 0;
                                                            i < list.length;
                                                            i++) {
                                                          if (jsonDecode(list
                                                                      .elementAt(
                                                                          i))[
                                                                  'mac'] ==
                                                              data.mac) {
                                                            customName =
                                                                jsonDecode(list
                                                                        .elementAt(
                                                                            i))[
                                                                    'name'];
                                                          }
                                                        }
                                                      }

                                                      return DeviceList(
                                                        data: {
                                                          'name': customName ??
                                                              data.mac,
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
    this.lable,
  });

  final dynamic data;
  final Function() onclick;
  final ValueChanged onSwitch;
  final Function() onLongPress;
  final String? lable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: data['selected'] ? 30 : 0,
            margin: EdgeInsets.only(right: data['selected'] ? 10 : 0),
            child: data['selected']
                ? const Icon(Ionicons.checkmark_circle)
                : null),
        Expanded(
          child: Slidable(
            enabled: () {
              if (!data['blocked'] || !data['selected']) {
                return false;
              }
              return true;
            }(),
            endActionPane: ActionPane(motion: const ScrollMotion(), children: [
              SlidableAction(
                onPressed: (_) {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          data: data,
                        );
                      });
                },
                label: 'Edit',
                backgroundColor: AppColor.dim,
                icon: FontAwesome.edit,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              )
            ]),
            child: ListTile(
              onTap: onclick,
              onLongPress: onLongPress,
              selected: data['selected'],
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: AppColor.container,
              iconColor: AppColor.dim,
              leading: const Icon(
                SimpleLineIcons.screen_desktop,
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      data['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              minLeadingWidth: 40,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!data['selected'] && !data['blocked'])
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  data: data,
                                );
                              });
                        },
                        icon: const Icon(
                          FontAwesome.edit,
                          size: 18,
                        )),
                  AvatarGlow(
                    endRadius: 18,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${data['mac']}".toUpperCase(),
                              style: TextStyle(
                                color: AppColor.dim,
                              ),
                            ),
                          ],
                        ),
                        if (lable != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColor.primary.withOpacity(0.1)),
                            child: Text(
                              lable!,
                              style: TextStyle(
                                  fontSize: 9, color: AppColor.primary),
                            ),
                          )
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class Dialog extends StatelessWidget {
  Dialog({
    Key? key,
    this.data,
    // required this.controller,
  }) : super(key: key);

  // final HomeController controller;
  final dynamic data;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController reply = TextEditingController(text: data['name']);

    return AlertDialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      title: Text(data['name']),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('IP Address: '),
              Text(data['ip'], style: TextStyle(color: AppColor.dim))
            ],
          ),
          Row(
            children: [
              const Text('MAC: '),
              Text(data['mac'].toString().toUpperCase(),
                  style: TextStyle(color: AppColor.dim))
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: reply,
              onSubmitted: (value) async {
                if (reply.text == "") return;
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                labelText: 'Custom name',
                fillColor: AppColor.bottomNavBG,
                border: InputBorder.none,
                filled: true,
                isDense: true,
              ),
            ),
          ).marginOnly(bottom: 10),
          Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  SharedPreferences.getInstance().then((value) {
                    List<String>? list =
                        value.getStringList(AppConstant.customDeviceName);

                    /// if the list dosent exist on the shared prefernce, create new list and save the current data
                    if (list != null && list.isNotEmpty) {
                      /// if element already exist in the list, delete element
                      for (var i = 0; i < list.length; i++) {
                        if (jsonDecode(list.elementAt(i))['mac'] ==
                            data['mac']) {
                          list.removeAt(i);
                        }
                      }

                      /// save the list to the shared preference
                      value
                          .setStringList(AppConstant.customDeviceName, list)
                          .then((value) {});
                    }

                    Navigator.of(context).pop();
                    CherryToast.success(
                      title: const Text(
                          'This device has been reset to its default name'),
                      shadowColor: AppColor.bg,
                      animationType: AnimationType.fromTop,
                      animationDuration: const Duration(milliseconds: 700),
                      backgroundColor: AppColor.container,
                    ).show(context);
                  });
                },
                child: const Text(
                  'Reset name',
                  // style: TextStyle(color: AppColor.dim),
                ),
              ),
            ],
          )
        ],
      ),
      contentPadding: const EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
      ),
      // actionsPadding: const EdgeInsets.only(bottom: 10, right: 5),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close')),
        TextButton(
            onPressed: () async {
              SharedPreferences.getInstance().then((value) {
                List<String>? list =
                    value.getStringList(AppConstant.customDeviceName);

                ///
                /// create a new json mac from device data, and set name to the new data from the textform
                var newData = {'mac': data['mac'], 'name': reply.text};

                ///
                /// if the list dosent exist on the shared prefernce, create new list and save the current data
                if (list == null || list.isEmpty) {
                  value.setStringList(
                      AppConstant.customDeviceName, [jsonEncode(newData)]);
                } else {
                  ///
                  /// if element already exist in the list, delete element
                  for (var i = 0; i < list.length; i++) {
                    if (jsonDecode(list.elementAt(i))['mac'] == data['mac']) {
                      list.removeAt(i);
                    }
                  }

                  // add the new name to the list
                  list.add(jsonEncode(newData));

                  // save the list to the shared preference
                  value
                      .setStringList(AppConstant.customDeviceName, list)
                      .then((value) {});
                }
              });

              Navigator.of(context).pop();
              CherryToast.success(
                title: Text('This device has been renamed to (${reply.text})'),
                shadowColor: AppColor.bg,
                animationType: AnimationType.fromTop,
                animationDuration: const Duration(milliseconds: 700),
                backgroundColor: AppColor.container,
              ).show(context);
            },
            child: const Text('Save'))
      ],
    );
  }
}
