import 'dart:convert';

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
    if (defaultTargetPlatform == TargetPlatform.android) {
      methodChannel.invokeMethod<void>('messageReceiverReady').ignore();
    }
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    final arguments = call.arguments;
    if (arguments is! Map) {
      return;
    }
    final message = Map<dynamic, dynamic>.from(arguments);
    if (defaultTargetPlatform == TargetPlatform.android) {
      _normalizeAndroidExtraMap(message);
    }

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

  void _normalizeAndroidExtraMap(Map<dynamic, dynamic> message) {
    if (!message.containsKey('extraMap')) {
      return;
    }

    final extraMap = message['extraMap'];
    if (extraMap is Map) {
      message['extraMap'] = extraMap.map<String, dynamic>(
        (key, value) => MapEntry(key.toString(), value),
      );
      return;
    }

    if (extraMap is String && extraMap.isNotEmpty) {
      try {
        final decoded = jsonDecode(extraMap);
        if (decoded is Map) {
          message['extraMap'] = decoded.map<String, dynamic>(
            (key, value) => MapEntry(key.toString(), value),
          );
          return;
        }
      } on FormatException {
        // Preserve the original value below for diagnostics.
      }
    }

    message['extraMap'] = <String, dynamic>{};
    if (extraMap is String && extraMap.isNotEmpty) {
      message['extraMapRaw'] = extraMap;
    }
  }

  Future<Object?> _invokeMethod(
    String operation,
    String method, [
    Object? arguments,
  ]) async {
    try {
      return await methodChannel.invokeMethod<Object?>(method, arguments);
    } on PlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AliyunPushException(
          code: error.code,
          message: error.message ?? 'Platform operation failed',
          operation: operation,
          cause: error,
        ),
        stackTrace,
      );
    } on MissingPluginException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AliyunPushException(
          code: kAliyunPushMissingPluginCode,
          message: error.toString(),
          operation: operation,
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  Future<Map<Object?, Object?>> _invokeResultMap(
    String operation,
    String method, [
    Object? arguments,
  ]) async {
    final value = await _invokeMethod(operation, method, arguments);
    if (value is! Map) {
      throw _invalidResponse(operation, 'Expected a result Map');
    }

    final result = Map<Object?, Object?>.from(value);
    final code = result['code'];
    if (code is! String || code.isEmpty) {
      throw _invalidResponse(operation, 'Missing result code');
    }
    if (code != kAliyunPushSuccessCode) {
      final errorMessage = result['errorMsg'];
      throw AliyunPushException(
        code: code,
        message: errorMessage is String && errorMessage.isNotEmpty
            ? errorMessage
            : 'Operation failed',
        operation: operation,
      );
    }
    return result;
  }

  Future<void> _invokeCommand(
    String operation,
    String method, [
    Object? arguments,
  ]) async {
    await _invokeResultMap(operation, method, arguments);
  }

  Future<String> _invokeString(String operation, String method) async {
    final value = await _invokeMethod(operation, method);
    if (value is! String || value.isEmpty) {
      throw _invalidResponse(operation, 'Expected a non-empty String');
    }
    return value;
  }

  Future<bool> _invokeBool(
    String operation,
    String method, [
    Object? arguments,
  ]) async {
    final value = await _invokeMethod(operation, method, arguments);
    if (value is! bool) {
      throw _invalidResponse(operation, 'Expected a bool');
    }
    return value;
  }

  List<String> _readStringList(
    Map<Object?, Object?> result,
    String key,
    String operation,
  ) {
    final value = result[key];
    if (value is List) {
      if (value.any((item) => item is! String)) {
        throw _invalidResponse(operation, 'Expected $key to contain Strings');
      }
      return List<String>.unmodifiable(value.cast<String>());
    }
    if (value is String) {
      return List<String>.unmodifiable(
        value
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty),
      );
    }
    throw _invalidResponse(operation, 'Expected $key to be a list');
  }

  AliyunPushChannelStatus _readChannelStatus(
    Map<Object?, Object?> result,
    String operation,
  ) {
    return switch (result['status']) {
      'on' => AliyunPushChannelStatus.enabled,
      'off' => AliyunPushChannelStatus.disabled,
      _ => throw _invalidResponse(operation, 'Unknown push channel status'),
    };
  }

  AliyunPushException _invalidResponse(String operation, String message) {
    return AliyunPushException(
      code: kAliyunPushInvalidResponseCode,
      message: message,
      operation: operation,
    );
  }

  void _requireAndroid(String operation) {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw AliyunPushException(
        code: kAliyunPushOnlyAndroid,
        message: 'Only support Android',
        operation: operation,
      );
    }
  }

  void _requireIOS(String operation) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      throw AliyunPushException(
        code: kAliyunPushOnlyIOS,
        message: 'Only support iOS',
        operation: operation,
      );
    }
  }

  @override
  Future<void> bindAccount(String account) {
    return _invokeCommand(
      'bindAccount',
      'bindAccount',
      {'account': account},
    );
  }

  @override
  Future<void> bindPhoneNumber(String phone) async {
    _requireAndroid('bindPhoneNumber');
    await _invokeCommand(
      'bindPhoneNumber',
      'bindPhoneNumber',
      {'phone': phone},
    );
  }

  @override
  Future<void> bindTag(
    List<String> tags, {
    int target = kAliyunTargetDevice,
    String? alias,
  }) {
    return _invokeCommand(
      'bindTag',
      'bindTag',
      {'tags': tags, 'target': target, 'alias': alias},
    );
  }

  @override
  Future<void> clearNotifications() async {
    _requireAndroid('clearNotifications');
    await _invokeCommand('clearNotifications', 'clearNotifications');
  }

  @override
  Future<void> closeAndroidPushLog() async {
    _requireAndroid('closeAndroidPushLog');
    await _invokeCommand('closeAndroidPushLog', 'closePushLog');
  }

  @override
  Future<void> createAndroidChannel(
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
    _requireAndroid('createAndroidChannel');
    await _invokeCommand('createAndroidChannel', 'createChannel', {
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
  }

  @override
  Future<void> createAndroidChannelGroup(
    String id,
    String name,
    String desc,
  ) async {
    _requireAndroid('createAndroidChannelGroup');
    await _invokeCommand(
      'createAndroidChannelGroup',
      'createChannelGroup',
      {'id': id, 'name': name, 'desc': desc},
    );
  }

  @override
  Future<String> getApnsDeviceToken() async {
    _requireIOS('getApnsDeviceToken');
    return _invokeString('getApnsDeviceToken', 'getApnsDeviceToken');
  }

  @override
  Future<String> getDeviceId() {
    return _invokeString('getDeviceId', 'getDeviceId');
  }

  @override
  Future<void> initAndroidThirdPush() async {
    _requireAndroid('initAndroidThirdPush');
    await _invokeCommand('initAndroidThirdPush', 'initThirdPush');
  }

  @override
  Future<void> initPush({
    String? appKey,
    String? appSecret,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _invokeCommand(
        'initPush',
        'initPushSdk',
        {'appKey': appKey, 'appSecret': appSecret},
      );
      return;
    }
    _requireAndroid('initPush');
    await _invokeCommand('initPush', 'initPush');
  }

  @override
  Future<bool> isAndroidNotificationEnabled({String? id}) async {
    _requireAndroid('isAndroidNotificationEnabled');
    return _invokeBool(
      'isAndroidNotificationEnabled',
      'isNotificationEnabled',
      {'id': id},
    );
  }

  @override
  Future<bool> isIOSChannelOpened() async {
    _requireIOS('isIOSChannelOpened');
    return _invokeBool('isIOSChannelOpened', 'isChannelOpened');
  }

  @override
  Future<void> jumpToAndroidNotificationSettings({String? id}) async {
    _requireAndroid('jumpToAndroidNotificationSettings');
    await _invokeMethod(
      'jumpToAndroidNotificationSettings',
      'jumpToNotificationSettings',
      {'id': id},
    );
  }

  @override
  Future<List<String>> listAlias() async {
    const operation = 'listAlias';
    final result = await _invokeResultMap(operation, 'listAlias');
    return _readStringList(result, 'aliasList', operation);
  }

  @override
  Future<List<String>> listTags({
    int target = kAliyunTargetDevice,
  }) async {
    const operation = 'listTags';
    final result = await _invokeResultMap(
      operation,
      'listTags',
      {'target': target},
    );
    return _readStringList(result, 'tagsList', operation);
  }

  @override
  Future<void> removeAlias(String alias) {
    return _invokeCommand(
      'removeAlias',
      'removeAlias',
      {'alias': alias},
    );
  }

  @override
  Future<void> setAndroidLogLevel(int level) async {
    _requireAndroid('setAndroidLogLevel');
    await _invokeCommand(
      'setAndroidLogLevel',
      'setLogLevel',
      {'level': level},
    );
  }

  @override
  Future<void> setAndroidBadgeNum(int num) async {
    _requireAndroid('setAndroidBadgeNum');
    await _invokeCommand(
      'setAndroidBadgeNum',
      'setBadgeNum',
      {'badgeNum': num},
    );
  }

  @override
  Future<void> setIOSBadgeNum(int num) async {
    _requireIOS('setIOSBadgeNum');
    await _invokeCommand(
      'setIOSBadgeNum',
      'setBadgeNum',
      {'badgeNum': num},
    );
  }

  @override
  Future<void> setNotificationInGroup(bool inGroup) async {
    _requireAndroid('setNotificationInGroup');
    await _invokeCommand(
      'setNotificationInGroup',
      'setNotificationInGroup',
      {'inGroup': inGroup},
    );
  }

  @override
  Future<void> setPluginLogEnabled(bool enabled) async {
    await _invokeMethod(
      'setPluginLogEnabled',
      'setPluginLogEnabled',
      {'enabled': enabled},
    );
  }

  @override
  Future<void> setIOSForegroundNoticeMode(ForegroundNoticeMode mode) async {
    _requireIOS('setIOSForegroundNoticeMode');
    await _invokeCommand(
      'setIOSForegroundNoticeMode',
      'showNoticeWhenForeground',
      {'mode': mode.value},
    );
  }

  @override
  @Deprecated(
      'Use setIOSForegroundNoticeMode with ForegroundNoticeMode instead.')
  Future<void> showIOSNoticeWhenForeground(bool enable) {
    return setIOSForegroundNoticeMode(
      enable
          ? ForegroundNoticeMode.showOnly
          : ForegroundNoticeMode.callbackOnly,
    );
  }

  @override
  Future<void> syncIOSBadgeNum(int num) async {
    _requireIOS('syncIOSBadgeNum');
    await _invokeCommand(
      'syncIOSBadgeNum',
      'syncBadgeNum',
      {'badgeNum': num},
    );
  }

  @Deprecated(
      "Use setIOSLogLevel(4) instead. The underlying iOS SDK turnOnDebug API is deprecated.")
  @override
  Future<void> turnOnIOSDebug() async {
    _requireIOS('turnOnIOSDebug');
    await _invokeCommand('turnOnIOSDebug', 'turnOnDebug');
  }

  @override
  Future<void> setIOSLogLevel(int level) async {
    _requireIOS('setIOSLogLevel');
    await _invokeCommand(
      'setIOSLogLevel',
      'setIOSLogLevel',
      {'level': level},
    );
  }

  @override
  Future<void> unbindAccount() {
    return _invokeCommand('unbindAccount', 'unbindAccount');
  }

  @override
  Future<void> unbindPhoneNumber() async {
    _requireAndroid('unbindPhoneNumber');
    await _invokeCommand('unbindPhoneNumber', 'unbindPhoneNumber');
  }

  @override
  Future<void> unbindTag(
    List<String> tags, {
    int target = kAliyunTargetDevice,
    String? alias,
  }) {
    return _invokeCommand(
      'unbindTag',
      'unbindTag',
      {'tags': tags, 'target': target, 'alias': alias},
    );
  }

  @override
  Future<void> addAlias(String alias) {
    return _invokeCommand(
      'addAlias',
      'addAlias',
      {'alias': alias},
    );
  }

  @override
  Future<AliyunPushChannelStatus> checkAndroidPushChannelStatus() async {
    _requireAndroid('checkAndroidPushChannelStatus');
    const operation = 'checkAndroidPushChannelStatus';
    final result = await _invokeResultMap(
      operation,
      'checkPushChannelStatus',
    );
    return _readChannelStatus(result, operation);
  }

  @override
  Future<void> turnOnAndroidPushChannel() async {
    _requireAndroid('turnOnAndroidPushChannel');
    await _invokeCommand('turnOnAndroidPushChannel', 'turnOnPushChannel');
  }

  @override
  Future<void> turnOffAndroidPushChannel() async {
    _requireAndroid('turnOffAndroidPushChannel');
    await _invokeCommand('turnOffAndroidPushChannel', 'turnOffPushChannel');
  }
}
