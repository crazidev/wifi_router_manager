import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

// ignore: must_be_immutable
class SMSscreen extends StatelessWidget {
  SMSscreen({super.key});

  List devices = [
    {
      'message':
          'You have 504.10MB of Data left. To access your data when you exhaust it, dial *312*1# or click on http://engage1.mtn.ng to buy a new plan',
      'number': '081232812',
      'date': '23 Oct 2002',
      'selected': false,
      'read': true,
    },
    {
      'message': 'G-334093 is your Google verification code.',
      'number': '081232812',
      'date': '23 Oct 2002',
      'selected': false,
      'read': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        title: Text("Device SMS (5/50)").marginOnly(top: 10),
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
              opacity: AlwaysStoppedAnimation(0.1),
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
                      "Phone: ${data['number']}",
                      style: TextStyle(
                        color: AppColor.dim,
                      ),
                    ),
                    Text(
                      "Date: ${data['date']}",
                      style: TextStyle(
                        color: AppColor.dim,
                      ),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Ionicons.trash_outline)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
