import 'dart:convert';
import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:router_manager/controller/sms_controller.dart';
import 'package:router_manager/core/app_export.dart';
import 'package:router_manager/data/model/response/sms_model.dart';

import '../../controller/home_controller.dart';

final smsConversationProvider = ChangeNotifierProvider<ChangeNotifier>((ref) {
  return ChangeNotifier();
});

// ignore: must_be_immutable
class SMSConversationScreen extends ConsumerWidget {
  const SMSConversationScreen({
    super.key,
    this.data,
  });

  final SMSGroupedModel? data;

  List<SMSModel> getSmsList(WidgetRef ref) {
    if (ref.read(smsProvider).sms_grouped_list != null) {
      var seen = ref
          .read(smsProvider)
          .sms_grouped_list!
          .where((e) => e.number == data?.number);

      if (seen.isNotEmpty) {
        return seen.first.smsList;
      } else {
        return [];
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    ref.watch(smsConversationProvider);
    var smsList = getSmsList(ref);

    ref.listen(smsProvider.select((value) => value.sms_total_count),
        (previous, next) {
      if (previous != next) {
        Logger().log('SMS UNREAD CHANGED');
        ref.read(smsConversationProvider).notifyListeners();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 70,
        title: Text(
                '${data?.number} ${data!.smsList.length > 1 ? "(${data?.smsList.length})" : ""}')
            .marginOnly(top: 10),
        actions: [],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5),
            child: Divider(
              color: AppColor.container,
            )),
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Expanded(
                            child: TextFormField(
                          // focusNode: focusNode,
                          minLines: 1,
                          maxLines: 4,
                          controller: ref.read(smsProvider).new_sms_controller,
                          decoration: const InputDecoration(
                              hintText: 'Enter your message...',
                              border: InputBorder.none),
                        )),
                        IconButton(
                            onPressed: () {
                              ref.read(smsProvider).sendSMS(SendSMSModel(
                                  message: ref
                                      .read(smsProvider)
                                      .new_sms_controller
                                      .text,
                                  number: data?.number ?? ''));
                              ref.read(smsProvider).new_sms_controller.clear();
                            },
                            icon: const Icon(Ionicons.send)),
                      ],
                    ),
                    if (Platform.isIOS && !keyboardVisible)
                      const SizedBox(height: 10),
                  ],
                ),
              ),
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
