import 'dart:io';
import 'package:flutter/services.dart';

class LCICSDK {
  static const MethodChannel _channel = MethodChannel('lcic_sdk');

  static Future<String?> initX5Core(String licenseKey) async {
    if (Platform.isAndroid) {
      return null;
    }
    return await _channel.invokeMethod<String>('initX5Core', {"licenseKey": licenseKey});
  }

  static Future<void> joinClass({
    required int schoolId,
    required String userId,
    required String token,
    required int classId,
    String? language,
    String? scene,
    bool? preferPortrait,
  }) async {
    try {
      final args = {
        'schoolId': schoolId,
        'userId': userId,
        'token': token,
        'classId': classId,
        'language': language,
        'scene': scene,
        'preferPortrait': preferPortrait,
      };
      await _channel.invokeMethod('joinClass', args);
    } on PlatformException catch (e) {
      throw 'Failed to join class: ${e.message}';
    }
  }
}
