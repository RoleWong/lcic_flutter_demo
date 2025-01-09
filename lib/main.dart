import 'dart:io';

import 'package:flutter/material.dart';

import 'lcic_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('LCIC SDK Integration')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                await LCICSDK.initX5Core(''); // TODO: 将申请的 X5 内核 licenseKey 填入此处
                // 将上课信息填入下方
                await LCICSDK.joinClass(
                  schoolId: 0,  // TODO
                  classId: 0,  // TODO
                  userId: '',  // TODO
                  token: '',  // TODO
                );
              } catch (e) {
                print('Error: $e');
              }
            },
            child: const Text('Join Class'),
          ),
        ),
      ),
    );
  }
}
