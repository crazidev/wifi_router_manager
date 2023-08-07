import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:router_manager/core/app_export.dart';

import '../../controller/home_controller.dart';

// ignore: must_be_immutable
class SMSscreen extends StatelessWidget {
  SMSscreen({super.key});

  HomeController homeController = Get.put(HomeController());
  get smsList => homeController.smsList!.sms_list.reversed;

  var selectedList = [].obs;
  var selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Text("Device SMS (5/50)").marginOnly(top: 10),
        actions: [
          Obx(() {
            var i = selectedList.value;
            return Row(
              children: [
                selectAll
                    ? IconButton(
                        onPressed: () {
                          selectAll = false;
                          selectedList.clear();
                        },
                        icon: Icon(Icons.check_box_outlined))
                    : IconButton(
                        onPressed: () {
                          selectAll = true;
                          homeController.smsList!.sms_list.forEach((element) {
                            var data = utf8.decode(base64Decode(element));
                            selectedList.add(data.split(' ').elementAt(0));
                          });
                        },
                        icon: Icon(Icons.check_box_outline_blank)),
                if (selectedList.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                  title: Text('Confirm'),
                                  content:
                                      Text('Do you want to delete all sms?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        homeController.deleteSMS('', all: true);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ));
                      },
                      icon: Icon(Ionicons.trash_bin_outline)),
              ],
            );
          })
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
              opacity: AlwaysStoppedAnimation(0.1),
              width: 1400,
              // height: ,
            ),
          ),
          GetBuilder(
              init: homeController,
              id: 'sms',
              builder: (_) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(
                      () {
                        var i = selectedList.value;
                        return homeController.smsList?.sms_total == null ||
                                homeController.smsList?.sms_total == "0"
                            ? const SizedBox()
                            : ListView(
                                children: List.from(smsList.map((e) {
                                  var data = utf8.decode(base64Decode(e));

                                  var others =
                                      "${data.split(' ').elementAt(0)} ${data.split(' ').elementAt(1)} ${data.split(' ').elementAt(2)} ${data.split(' ').elementAt(3)} ${data.split(' ').elementAt(4)} ";

                                  var selected = false;

                                  selectedList.forEach((e) {
                                    if (e == data.split(' ').elementAt(0)) {
                                      selected = true;
                                    }
                                  });

                                  return DeviceList(
                                    selectedList: selectedList,
                                    data: {
                                      'id': data.split(' ').elementAt(0),
                                      'message': data.substring(others.length),
                                      'number': data.split(' ').elementAt(2),
                                      'date': data.split(' ').elementAt(3) +
                                          " " +
                                          data.split(' ').elementAt(4),
                                      'selected': selected,
                                      'read':
                                          data.split(' ').elementAt(1) == "1"
                                              ? true
                                              : false,
                                    },
                                    onDelete: (id) {
                                      showDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                                title: Text('Confirm'),
                                                content: Text(
                                                    'Do you want to delete this sms?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      homeController
                                                          .deleteSMS(id);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              ));
                                    },
                                    onclick: () {
                                      if (selectedList.isNotEmpty) {
                                        if (selected) {
                                          selectedList.remove(
                                              data.split(' ').elementAt(0));
                                        } else {
                                          selectedList.add(
                                              data.split(' ').elementAt(0));
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: Text(data
                                                      .split(' ')
                                                      .elementAt(2)),
                                                  content: Text(data.substring(
                                                      others.length)),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Close'),
                                                    ),
                                                    // TextButton(
                                                    //   onPressed: () {},
                                                    //   child: Text('Reply'),
                                                    // ),
                                                  ],
                                                ));
                                        homeController.setReadSMS(
                                            data.split(' ').elementAt(0));
                                      }
                                    },
                                  ).marginOnly(bottom: 10);
                                })),
                              );
                      },
                    ));
              }),
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
    required this.selectedList,
    required this.onDelete,
  });

  final dynamic data;
  final Function() onclick;
  final ValueChanged onDelete;

  final RxList selectedList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: data['selected'] ? 30 : 0,
            margin: EdgeInsets.only(right: data['selected'] ? 10 : 0),
            child: data['selected'] ? Icon(Ionicons.checkmark_circle) : null),
        Expanded(
          child: ListTile(
            onTap: onclick,
            onLongPress: () {
              selectedList.add(data['id']);
            },
            selected: data['selected'],
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: AppColor.container,
            iconColor: AppColor.dim,
            leading: data['read']
                ? Icon(
                    SimpleLineIcons.bubble,
                  )
                : Badge(
                    child: Icon(
                      SimpleLineIcons.bubble,
                    ),
                  ),
            title: Text(
              data['message'],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            minLeadingWidth: 40,
            // trailing:
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data['number']}",
                      style: TextStyle(
                        color: AppColor.dim,
                      ),
                    ),
                    Text(
                      "${data['date']}",
                      style: TextStyle(
                        color: AppColor.dim,
                      ),
                    ),
                  ],
                ),
                if (!data['selected'])
                  IconButton(
                      onPressed: () => onDelete(data['id']),
                      icon: Icon(Ionicons.trash_outline)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
