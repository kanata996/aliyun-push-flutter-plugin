import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'aliyun_push_flutter_platform_interface.dart';
import 'aliyun_push_flutter.dart';

/// An implementation of [AliyunPushFlutterPlatform] that uses method channels.
class MethodChannelAliyunPushFlutter extends AliyunPushFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('aliyun_push');

  /// 发出通知的回调
  PushCallback? _onNotification;

  /// 应用处于前台时通知到达回调
  PushCallback? _onAndroidNotificationReceivedInApp;

  /// 推送消息的回调方法
  PushCallback? _onMessage;

  /// 从通知栏打开通知的扩展处理
  PushCallback? _onNotificationOpened;

  /// 通知删除回调
  PushCallback? _onNotificationRemoved;

  /// 无动作通知点击回调
  PushCallback? _onAndroidNotificationClickedWithNoAction;

  /// iOS 通知打开回调
  PushCallback? _onIOSChannelOpened;

  /// APNs 注册成功回调
  PushCallback? _onIOSRegisterDeviceTokenSuccess;

  /// APNs 注册失败回调
  PushCallback? _onIOSRegisterDeviceTokenFailed;

  @override
  void addMessageReceiver({
    PushCallback? onNotification,
    PushCallback? onMessage,
    PushCallback? onNotificationOpened,
    PushCallback? onNotificationRemoved,
    PushCallback? onAndroidNotificationReceivedInApp,
    PushCallback? onAndroidNotificationClickedWithNoAction,
    PushCallback? onIOSChannelOpened,
    PushCallback? onIOSRegisterDeviceTokenSuccess,
    PushCallback? onIOSRegisterDeviceTokenFailed,
  }) {
    _onNotification = onNotification;
    _onAndroidNotificationReceivedInApp = onAndroidNotificationReceivedInApp;
    _onMessage = onMessage;
    _onNotificationOpened = onNotificationOpened;
    _onNotificationRemoved = onNotificationRemoved;
    _onAndroidNotificationClickedWithNoAction =
        onAndroidNotificationClickedWithNoAction;
    _onIOSChannelOpened = onIOSChannelOpened;
    _onIOSRegisterDeviceTokenSuccess = onIOSRegisterDeviceTokenSuccess;
    _onIOSRegisterDeviceTokenFailed = onIOSRegisterDeviceTokenFailed;

    methodChannel.setMethodCallHandler(_methodCallHandler);
    if (Platform.isAndroid) {
      methodChannel.invokeMethod<void>('messageReceiverReady').ignore();
    }
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    final arguments = call.arguments;
    if (arguments is! Map) {
      return;
    }
    final message = Map<dynamic, dynamic>.from(arguments);

    switch (call.method) {
      case 'onNotification':
        return _onNotification?.call(message);
      case 'onNotificationReceivedInApp':
        return _onAndroidNotificationReceivedInApp?.call(message);
      case 'onMessage':
        return _onMessage?.call(message);
      case 'onNotificationOpened':
        return _onNotificationOpened?.call(message);
      case 'onNotificationRemoved':
        return _onNotificationRemoved?.call(message);
      case 'onNotificationClickedWithNoAction':
        return _onAndroidNotificationClickedWithNoAction?.call(message);
      case 'onChannelOpened':
        return _onIOSChannelOpened?.call(message);
      case 'onRegisterDeviceTokenSuccess':
        return _onIOSRegisterDeviceTokenSuccess?.call(message);
      case 'onRegisterDeviceTokenFailed':
        return _onIOSRegisterDeviceTokenFailed?.call(message);
    }
  }

  @override
  Future<Map<dynamic, dynamic>> bindAccount(String account) async {
    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('bindAccount', {'account': account});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> bindPhoneNumber(String phone) async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('bindPhoneNumber', {'phone': phone});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> bindTag(List<String> tags,
      {int target = kAliyunTargetDevice, String? alias}) async {
    Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
        'bindTag', {'tags': tags, 'target': target, 'alias': alias});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> clearNotifications() async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('clearNotifications');
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> closeAndroidPushLog() async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('closePushLog');
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> createAndroidChannel(
    String id,
    String name,
    int importance,
    String description, {
    String? groupId,
    bool? allowBubbles,
    bool? light,
    int? lightColor,
    bool? showBadge,
    String? soundPath,
    int? soundUsage,
    int? soundContentType,
    int? soundFlag,
    bool? vibration,
    List<int>? vibrationPatterns,
  }) async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('createChannel', {
      'id': id,
      'name': name,
      'importance': importance,
      'desc': description,
      'groupId': groupId,
      'allowBubbles': allowBubbles,
      'light': light,
      'lightColor': lightColor,
      'showBadge': showBadge,
      'soundPath': soundPath,
      'soundUsage': soundUsage,
      'soundContentType': soundContentType,
      'soundFlag': soundFlag,
      'vibration': vibration,
      'vibrationPattern': vibrationPatterns,
    });
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> createAndroidChannelGroup(
      String id, String name, String desc) async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
        'createChannelGroup', {'id': id, 'name': name, 'desc': desc});
    return result;
  }

  @override
  Future<String> getApnsDeviceToken() async {
    if (!Platform.isIOS) {
      return 'Only support iOS';
    }

    final apnsDeviceToken =
        await methodChannel.invokeMethod<String>('getApnsDeviceToken');
    return apnsDeviceToken ?? '';
  }

  @override
  Future<String> getDeviceId() async {
    final deviceId = await methodChannel.invokeMethod<String>('getDeviceId');
    return deviceId ?? '';
  }

  @override
  Future<Map<dynamic, dynamic>> initAndroidThirdPush() async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> initResult =
        await methodChannel.invokeMethod('initThirdPush');
    return initResult;
  }

  @override
  Future<Map<dynamic, dynamic>> initPush({
    String? appKey,
    String? appSecret,
  }) async {
    if (Platform.isIOS) {
      Map<dynamic, dynamic> initResult =
          await methodChannel.invokeMethod('initPushSdk', {
        'appKey': appKey,
        'appSecret': appSecret,
      });

      return initResult;
    } else {
      Map<dynamic, dynamic> initResult =
          await methodChannel.invokeMethod('initPush');
      return initResult;
    }
  }

  @override
  Future<bool> isAndroidNotificationEnabled({String? id}) async {
    if (!Platform.isAndroid) {
      return false;
    }

    final enabled = await methodChannel
        .invokeMethod<bool>('isNotificationEnabled', {'id': id});
    return enabled ?? false;
  }

  @override
  Future<bool> isIOSChannelOpened() async {
    if (!Platform.isIOS) {
      return false;
    }

    final opened = await methodChannel.invokeMethod<bool>('isChannelOpened');
    return opened ?? false;
  }

  @override
  void jumpToAndroidNotificationSettings({String? id}) {
    if (!Platform.isAndroid) {
      return;
    }

    methodChannel.invokeMethod<void>(
      'jumpToNotificationSettings',
      {'id': id},
    ).ignore();
  }

  @override
  Future<Map<dynamic, dynamic>> listAlias() async {
    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('listAlias');
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> listTags(
      {int target = kAliyunTargetDevice}) async {
    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('listTags', {'target': target});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> removeAlias(String alias) async {
    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('removeAlias', {'alias': alias});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> setAndroidLogLevel(int level) async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('setLogLevel', {'level': level});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> setAndroidBadgeNum(int num) async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('setBadgeNum', {'badgeNum': num});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> setIOSBadgeNum(int num) async {
    if (!Platform.isIOS) {
      return {
        'code': kAliyunPushOnlyIOS,
        'errorMsg': 'Only support iOS',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('setBadgeNum', {'badgeNum': num});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> setNotificationInGroup(bool inGroup) async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result = await methodChannel
        .invokeMethod('setNotificationInGroup', {'inGroup': inGroup});
    return result;
  }

  @override
  void setPluginLogEnabled(bool enabled) {
    methodChannel.invokeMethod<void>(
        'setPluginLogEnabled', {'enabled': enabled}).ignore();
  }

  @override
  Future<Map<dynamic, dynamic>> showIOSNoticeWhenForeground(bool enable) async {
    if (!Platform.isIOS) {
      return {
        'code': kAliyunPushOnlyIOS,
        'errorMsg': 'Only support iOS',
      };
    }

    Map<dynamic, dynamic> result = await methodChannel
        .invokeMethod('showNoticeWhenForeground', {'enable': enable});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> syncIOSBadgeNum(int num) async {
    if (!Platform.isIOS) {
      return {
        'code': kAliyunPushOnlyIOS,
        'errorMsg': 'Only support iOS',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('syncBadgeNum', {'badgeNum': num});
    return result;
  }

  @Deprecated(
      "Use setIOSLogLevel(4) instead. The underlying iOS SDK turnOnDebug API is deprecated.")
  @override
  Future<Map<dynamic, dynamic>> turnOnIOSDebug() async {
    if (!Platform.isIOS) {
      return {
        'code': kAliyunPushOnlyIOS,
        'errorMsg': 'Only support iOS',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('turnOnDebug');
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> setIOSLogLevel(int level) async {
    if (!Platform.isIOS) {
      return {
        'code': kAliyunPushOnlyIOS,
        'errorMsg': 'Only support iOS',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('setIOSLogLevel', {'level': level});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> unbindAccount() async {
    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('unbindAccount');
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> unbindPhoneNumber() async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('unbindPhoneNumber');
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> unbindTag(List<String> tags,
      {int target = kAliyunTargetDevice, String? alias}) async {
    Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
        'unbindTag', {'tags': tags, 'target': target, 'alias': alias});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> addAlias(String alias) async {
    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('addAlias', {'alias': alias});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> checkAndroidPushChannelStatus() async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('checkPushChannelStatus');
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> turnOnAndroidPushChannel() async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('turnOnPushChannel');
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> turnOffAndroidPushChannel() async {
    if (!Platform.isAndroid) {
      return {
        'code': kAliyunPushOnlyAndroid,
        'errorMsg': 'Only support Android',
      };
    }

    Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('turnOffPushChannel');
    return result;
  }
}
