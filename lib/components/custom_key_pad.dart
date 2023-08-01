import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomKeyPad extends StatelessWidget {
  CustomKeyPad({
    Key? key,
    required RxList otp,
    required this.codeLength,
    this.emptypad,
    required this.onComplete,
    required this.onChange,
    this.color,
  })  : _otp = otp,
        super(key: key);

  final List<String> numbers = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "*",
    "0",
    "#"
  ];
  final RxList _otp;
  final int? codeLength;
  final Widget? emptypad;
  final VoidCallback onComplete;
  final ValueChanged onChange;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Get.height * 37 / 100,
        child: GridView.builder(
          itemCount: numbers.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6.0,
              mainAxisSpacing: 0.0,
              childAspectRatio: 1.4),
          itemBuilder: (BuildContext context, int index) {
            return IconButton(
              splashColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
              highlightColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
              onPressed: () {
                HapticFeedback.lightImpact();
                var value = numbers[index];
                if (value == "") return;
                if (value == "del") {
                  if (_otp.length == 0) return;
                  _otp.removeLast();
                  onChange(_otp.join());
                } else {
                  if (_otp.length != codeLength) {
                    _otp.add(value);
                    onChange(_otp.join());
                  }
                  if (_otp.length == codeLength) {
                    onComplete();
                  }
                }
              },
              icon: Center(
                  child: numbers[index] == "del"
                      ? Icon(
                          Icons.backspace,
                          color: color ?? null,
                        )
                      : numbers[index] == "" && emptypad != null
                          ? emptypad
                          : Text(
                              numbers[index],
                              style: TextStyle(
                                fontSize: 20,
                                color: color ?? null,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
            );
          },
        ),
      ),
    );
  }
}
