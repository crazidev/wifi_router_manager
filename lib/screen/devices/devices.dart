// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:router_manager/controller/devices_controller.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/core/helper.dart';
import 'package:router_manager/devices/mtn_mifi.dart';
import 'package:router_manager/main.dart';

import '../../controller/home_controller.dart';
import '../../core/app_constant.dart';

class DeviceData {
  final String name;
  final String mac_addr;
  final String ip_addr;
  final bool selected;
  final bool blocked;
  DeviceData({
    required this.name,
    required this.mac_addr,
    required this.ip_addr,
    required this.selected,
    required this.blocked,
  });
}

class Devices extends ConsumerStatefulWidget {
  const Devices({super.key});

  @override
  ConsumerState<Devices> createState() => _DevicesState();
}

class _DevicesState extends ConsumerState<Devices> {
  var selectedBlackList = [].obs;
  var selectedWhiteList = [].obs;
  var deviceIP = '';
  // var selectAll = false;

  var isExpanded = false.obs;

  setIP() async {}

  refreshState() {}

  @override
  Widget build(BuildContext context) {
    var devices = ref.watch(deviceProvider.select((value) => value.devices));
    var blockedDevice = ref.watch(fetchBlockDevicesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        centerTitle: false,
        title: Consumer(
          builder: (context, ref, child) {
            return Text("Devices (${devices?.length})");
          },
        ).marginOnly(top: 10),
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
                                            // Helper().showPreloader(context,
                                            //     title: "Restarting Router");
                                            ref
                                                .read(deviceProvider.notifier)
                                                .unblockDevices(
                                                    selectedBlackList.value);
                                            selectedBlackList.clear();

                                            CherryToast.success(
                                              title: const Text(
                                                  'This devices have been unblocked'),
                                              shadowColor: AppColor.bg,
                                              animationType:
                                                  AnimationType.fromTop,
                                              toastDuration: const Duration(
                                                  milliseconds: 1700),
                                              animationDuration: const Duration(
                                                  milliseconds: 300),
                                              backgroundColor:
                                                  AppColor.container,
                                            ).show(context);
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
                                            ref
                                                .read(deviceProvider.notifier)
                                                .blockDevices(
                                                    selectedWhiteList.value);
                                            selectedWhiteList.clear();

                                            CherryToast.success(
                                              title: const Text(
                                                  'This devices have been blocked from using the router'),
                                              shadowColor: AppColor.bg,
                                              animationType:
                                                  AnimationType.fromTop,
                                              toastDuration: const Duration(
                                                  milliseconds: 1700),
                                              animationDuration: const Duration(
                                                  milliseconds: 300),
                                              backgroundColor:
                                                  AppColor.container,
                                            ).show(context);
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
              // PopupMenuItem(child: Text("Clear Devices"), value: 1),
            ],
            onSelected: (value) {
              // * Clear custom device names from shared preference
              if (value == 0) {
                ref
                    .read(sharedPreferencesProvider)
                    .remove(AppConstant.customDeviceName)
                    .then((value) {
                  CherryToast.success(
                    title: const Text('Cleared succesfully'),
                    shadowColor: AppColor.bg,
                    animationType: AnimationType.fromTop,
                    toastDuration: const Duration(milliseconds: 1700),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: AppColor.container,
                  ).show(context);
                });
              }

              // * Clear all blocked devices
              // if (value == 1) {}
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
                child: devices == null
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Column(
                              children: List.from(devices.map((e) {
                                var selected = false;

                                if (deviceIP == '') {
                                  setIP();
                                }

                                selectedWhiteList.forEach((e2) {
                                  if (e.mac_addr == e2) {
                                    selected = true;
                                  }
                                });

                                String? customName;

                                List<String>? list = ref
                                    .read(sharedPreferencesProvider)
                                    .getStringList(
                                        AppConstant.customDeviceName);

                                if (list != null)
                                  // ignore: curly_braces_in_flow_control_structures
                                  for (var i = 0; i < list.length; i++) {
                                    if (jsonDecode(
                                            list.elementAt(i))['mac_addr'] ==
                                        e.mac_addr) {
                                      customName =
                                          jsonDecode(list.elementAt(i))['name'];
                                    }
                                  }

                                return DeviceList(
                                  data: DeviceData(
                                    name: () {
                                      if (customName != null) {
                                        return customName;
                                      } else {
                                        return e.hostname == "*"
                                            ? e.ip_addr
                                            : e.hostname;
                                      }
                                    }()!,
                                    mac_addr: e.mac_addr,
                                    ip_addr: e.ip_addr,
                                    selected: selected,
                                    blocked: false,
                                  ),
                                  lable: deviceIP == e.ip_addr
                                      ? "This device"
                                      : null,
                                  onclick: () {
                                    if (selectedWhiteList.isNotEmpty) {
                                      if (selected) {
                                        selectedWhiteList.remove(e.mac_addr);
                                      } else {
                                        selectedWhiteList.add(e.mac_addr);
                                      }
                                    }
                                  },
                                  onSwitch: (value) {},
                                  onLongPress: () {
                                    if (selectedBlackList.isNotEmpty) {
                                      selectedBlackList.clear();
                                    }

                                    selectedWhiteList.add(e.mac_addr);
                                  },
                                ).marginOnly(bottom: 10);
                              })),
                            ),
                          ),
                          Obx(() {
                            var i = selectedBlackList.value;
                            return ExpansionPanelList(
                              expandedHeaderPadding: EdgeInsets.zero,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              elevation: 0,
                              expansionCallback: (index, value) {
                                isExpanded.value = !isExpanded.value;
                              },
                              children: [
                                ExpansionPanel(
                                    backgroundColor: Colors.transparent,
                                    isExpanded: !isExpanded.value,
                                    headerBuilder:
                                        (BuildContext context, bool expanded) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Blocked (${blockedDevice.value?.length})",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ).marginOnly(top: 20, bottom: 10),
                                        ],
                                      );
                                    },
                                    body: blockedDevice.when(
                                        error: (error, stacks) =>
                                            Text(error.toString()),
                                        loading: () =>
                                            CupertinoActivityIndicator(),
                                        data: (value) => Column(children: [
                                              for (var i = 0;
                                                  i < value.length;
                                                  i++)
                                                Builder(builder: (context) {
                                                  var data = value.elementAt(i);

                                                  var selected = false;

                                                  selectedBlackList
                                                      .forEach((e) {
                                                    if (e == data.mac_addr) {
                                                      selected = true;
                                                    }
                                                  });

                                                  String? customName;

                                                  List<String>? list = ref
                                                      .read(
                                                          sharedPreferencesProvider)
                                                      .getStringList(AppConstant
                                                          .customDeviceName);

                                                  if (list != null) {
                                                    for (var i = 0;
                                                        i < list.length;
                                                        i++) {
                                                      if (jsonDecode(list
                                                                  .elementAt(
                                                                      i))[
                                                              'mac_addr'] ==
                                                          data.mac_addr) {
                                                        customName = jsonDecode(
                                                            list.elementAt(
                                                                i))['name'];
                                                      }
                                                    }
                                                  }

                                                  return DeviceList(
                                                    data: DeviceData(
                                                      name: customName ??
                                                          data.hostname!,
                                                      mac_addr: data.mac_addr,
                                                      ip_addr: '',
                                                      selected: selected,
                                                      blocked: true,
                                                    ),
                                                    onclick: () {
                                                      if (selectedBlackList
                                                          .isNotEmpty) {
                                                        if (selected) {
                                                          selectedBlackList
                                                              .remove(data
                                                                  .mac_addr);
                                                        } else {
                                                          selectedBlackList.add(
                                                              data.mac_addr);
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
                                                          .add(data.mac_addr);
                                                    },
                                                  ).marginOnly(bottom: 10);
                                                }),
                                            ]))),
                              ],
                            );
                          }),
                        ],
                      )),
          ],
        ),
      ),
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({
    super.key,
    required this.data,
    required this.onclick,
    required this.onSwitch,
    required this.onLongPress,
    this.lable,
  });

  final DeviceData data;
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
            width: data.selected ? 30 : 0,
            margin: EdgeInsets.only(right: data.selected ? 10 : 0),
            child:
                data.selected ? const Icon(Ionicons.checkmark_circle) : null),
        Expanded(
          child: Slidable(
            enabled: () {
              if (data.blocked || data.selected) {
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
              selected: data.selected,
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
                      data.name,
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
                  if (!data.blocked)
                    if (!data.selected)
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
                    animate: data.blocked ? false : true,
                    glowColor: Colors.green,
                    showTwoGlows: false,
                    child: Icon(
                      Icons.circle_sharp,
                      color: data.blocked ? AppColor.dim : Colors.green,
                      size: 10,
                    ),
                  )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!data.blocked)
                    Text(
                      "IP: ${data.ip_addr}",
                      style: TextStyle(
                        color: AppColor.dim,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${data.mac_addr}".toUpperCase(),
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
                        style: TextStyle(fontSize: 9, color: AppColor.primary),
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
              const Text('ip_addr Address: '),
              Text(data.ip_addr, style: TextStyle(color: AppColor.dim))
            ],
          ),
          Row(
            children: [
              const Text('mac_addr: '),
              Text(data.mac_addr.toString().toUpperCase(),
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
                        if (jsonDecode(list.elementAt(i))['mac_addr'] ==
                            data.mac_addr) {
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
                      toastDuration: const Duration(milliseconds: 1700),
                      animationDuration: const Duration(milliseconds: 300),
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
                /// create a new json mac_addr from device data, and set name to the new data from the textform
                var newData = {'mac_addr': data.mac_addr, 'name': reply.text};

                ///
                /// if the list dosent exist on the shared prefernce, create new list and save the current data
                if (list == null || list.isEmpty) {
                  value.setStringList(
                      AppConstant.customDeviceName, [jsonEncode(newData)]);
                } else {
                  ///
                  /// if element already exist in the list, delete element
                  for (var i = 0; i < list.length; i++) {
                    if (jsonDecode(list.elementAt(i))['mac_addr'] ==
                        data.mac_addr) {
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
                toastDuration: const Duration(milliseconds: 1700),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: AppColor.container,
              ).show(context);
            },
            child: const Text('Save'))
      ],
    );
  }
}
