import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:router_manager/controller/sms_controller.dart';
import 'package:router_manager/core/app_export.dart';

import '../../controller/home_controller.dart';

// ignore: must_be_immutable
class SMSConversationScreen extends ConsumerWidget {
  SMSConversationScreen({
    super.key,
    this.data,
  });

  final SMSGroupedModel? data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var smsList = data?.smsList.toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Text(
                '${data?.number} ${data!.smsList.length > 1 ? "(${data?.smsList.length})" : ""}')
            .marginOnly(top: 10),
        actions: [],
        bottom: PreferredSize(
            child: Divider(
              color: AppColor.container,
            ),
            preferredSize: const Size.fromHeight(5)),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: -300,
            child: Image.asset(
              'assets/5076404.jpg',
              // fit: BoxFit.,
              opacity: const AlwaysStoppedAnimation(0.1),
              width: 1400,
              // height: ,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  reverse: true,
                  padding: EdgeInsets.all(10),
                  itemCount: smsList.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    var sms = smsList[index];
                    return ChatList(data: sms);
                    // DeviceList(data: sms);
                  },
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.purple.withOpacity(0.1),
              //   ),
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Row(
              //         children: [
              //           IconButton(
              //               onPressed: () {},
              //               icon: const Icon(Ionicons.attach_outline)),
              //           Expanded(
              //               child: TextFormField(
              //             // focusNode: focusNode,
              //             minLines: 1,
              //             maxLines: 4,
              //             controller: TextEditingController(),
              //             decoration: const InputDecoration(
              //                 hintText: 'Enter your message...',
              //                 border: InputBorder.none),
              //           )),
              //           IconButton(
              //               onPressed: () {}, icon: const Icon(Ionicons.send)),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
    this.data,
  });

  final SMSModel? data;
  get isSent => data?.isSent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          !isSent ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 5),
          decoration: BoxDecoration(
            // color: const Color.fromARGB(58, 158, 158, 158).withOpacity(0.4),
            color: isSent
                ? Colors.yellow.withOpacity(0.1)
                : AppColor.container.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          constraints: BoxConstraints(maxWidth: width * 75 / 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data!.content,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    data!.date,
                    // DateFormat.jm().format(data!.createdAt!),
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColor.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      return InkWell(
                          onTap: () {
                            ref.read(smsProvider).deleteSMS([data!]);
                          },
                          child: Icon(
                            Ionicons.trash_outline,
                            size: 14,
                            color: AppColor.primary,
                          ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
