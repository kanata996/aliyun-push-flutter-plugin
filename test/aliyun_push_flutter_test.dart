// ignore_for_file: deprecated_member_use_from_same_package

import 'package:aliyun_push_flutter/aliyun_push_flutter.dart';
import 'package:aliyun_push_flutter/aliyun_push_flutter_method_channel.dart';
import 'package:aliyun_push_flutter/aliyun_push_flutter_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAliyunPushFlutterPlatform
    with MockPlatformInterfaceMixin
    implements AliyunPushFlutterPlatform {
  final stringResult = 'mock-string';
  final boolResult = true;
  final listResult = const ['mock-item'];
  final channelStatusResult = AliyunPushChannelStatus.enabled;

  ({String method, Object? arguments})? lastCall;

  void _record(String method, [Object? arguments]) {
    lastCall = (method: method, arguments: arguments);
  }

  Future<void> _recordVoid(
    String method, [
    Object? arguments,
  ]) async {
    _record(method, arguments);
  }

  @override
  Future<void> addAlias(String alias) {
    return _recordVoid('addAlias', alias);
  }

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
    _record('addMessageReceiver', {
      'onNotification': onNotification,
      'onMessage': onMessage,
      'onNotificationOpened': onNotificationOpened,
      'onNotificationRemoved': onNotificationRemoved,
      'onAndroidNotificationReceivedInApp': onAndroidNotificationReceivedInApp,
      'onAndroidNotificationClickedWithNoAction':
          onAndroidNotificationClickedWithNoAction,
      'onIOSChannelOpened': onIOSChannelOpened,
      'onIOSRegisterDeviceTokenSuccess': onIOSRegisterDeviceTokenSuccess,
      'onIOSRegisterDeviceTokenFailed': onIOSRegisterDeviceTokenFailed,
    });
  }

  @override
  Future<void> bindAccount(String account) {
    return _recordVoid('bindAccount', account);
  }

  @override
  Future<void> bindDeviceTag(List<String> tags) {
    return _recordVoid('bindDeviceTag', tags);
  }

  @override
  Future<void> bindPhoneNumber(String phone) {
    return _recordVoid('bindPhoneNumber', phone);
  }

  @override
  Future<void> bindTag(
    List<String> tags, {
    int target = kAliyunTargetDevice,
    String? alias,
  }) {
    return _recordVoid('bindTag', {
      'tags': tags,
      'target': target,
      'alias': alias,
    });
  }

  @override
  Future<AliyunPushChannelStatus> checkAndroidPushChannelStatus() async {
    _record('checkAndroidPushChannelStatus');
    return channelStatusResult;
  }

  @override
  Future<void> clearNotifications() {
    return _recordVoid('clearNotifications');
  }

  @override
  Future<void> closeAndroidPushLog() {
    return _recordVoid('closeAndroidPushLog');
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
  }) {
    return _recordVoid('createAndroidChannel', {
      'id': id,
      'name': name,
      'importance': importance,
      'description': description,
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
      'vibrationPatterns': vibrationPatterns,
    });
  }

  @override
  Future<void> createAndroidChannelGroup(
    String id,
    String name,
    String desc,
  ) {
    return _recordVoid('createAndroidChannelGroup', {
      'id': id,
      'name': name,
      'desc': desc,
    });
  }

  @override
  Future<String> getApnsDeviceToken() async {
    _record('getApnsDeviceToken');
    return stringResult;
  }

  @override
  Future<String> getDeviceId() async {
    _record('getDeviceId');
    return stringResult;
  }

  @override
  Future<void> initAndroidThirdPush() {
    return _recordVoid('initAndroidThirdPush');
  }

  @override
  Future<void> initPush({
    String? appKey,
    String? appSecret,
  }) {
    return _recordVoid('initPush', {
      'appKey': appKey,
      'appSecret': appSecret,
    });
  }

  @override
  Future<bool> isAndroidNotificationEnabled({String? id}) async {
    _record('isAndroidNotificationEnabled', id);
    return boolResult;
  }

  @override
  Future<bool> isIOSChannelOpened() async {
    _record('isIOSChannelOpened');
    return boolResult;
  }

  @override
  Future<void> jumpToAndroidNotificationSettings({String? id}) async {
    _record('jumpToAndroidNotificationSettings', id);
  }

  @override
  Future<List<String>> listAlias() async {
    _record('listAlias');
    return listResult;
  }

  @override
  Future<List<String>> listDeviceTags() async {
    _record('listDeviceTags');
    return listResult;
  }

  @override
  Future<List<String>> listTags({
    int target = kAliyunTargetDevice,
  }) async {
    _record('listTags', target);
    return listResult;
  }

  @override
  Future<void> removeAlias(String alias) {
    return _recordVoid('removeAlias', alias);
  }

  @override
  Future<void> setAndroidLogLevel(int level) {
    return _recordVoid('setAndroidLogLevel', level);
  }

  @override
  Future<void> setAndroidBadgeNum(int num) {
    return _recordVoid('setAndroidBadgeNum', num);
  }

  @override
  Future<void> setIOSBadgeNum(int num) {
    return _recordVoid('setIOSBadgeNum', num);
  }

  @override
  Future<void> setIOSLogLevel(int level) {
    return _recordVoid('setIOSLogLevel', level);
  }

  @override
  Future<void> setIOSForegroundNoticeMode(ForegroundNoticeMode mode) {
    return _recordVoid('setIOSForegroundNoticeMode', mode);
  }

  @override
  Future<void> setNotificationInGroup(bool inGroup) {
    return _recordVoid('setNotificationInGroup', inGroup);
  }

  @override
  Future<void> setPluginLogEnabled(bool enabled) async {
    _record('setPluginLogEnabled', enabled);
  }

  @override
  Future<void> showIOSNoticeWhenForeground(bool enable) {
    return _recordVoid('showIOSNoticeWhenForeground', enable);
  }

  @override
  Future<void> syncIOSBadgeNum(int num) {
    return _recordVoid('syncIOSBadgeNum', num);
  }

  @override
  Future<void> turnOffAndroidPushChannel() {
    return _recordVoid('turnOffAndroidPushChannel');
  }

  @override
  Future<void> turnOnAndroidPushChannel() {
    return _recordVoid('turnOnAndroidPushChannel');
  }

  @override
  Future<void> turnOnIOSDebug() {
    return _recordVoid('turnOnIOSDebug');
  }

  @override
  Future<void> unbindAccount() {
    return _recordVoid('unbindAccount');
  }

  @override
  Future<void> unbindDeviceTag(List<String> tags) {
    return _recordVoid('unbindDeviceTag', tags);
  }

  @override
  Future<void> unbindPhoneNumber() {
    return _recordVoid('unbindPhoneNumber');
  }

  @override
  Future<void> unbindTag(
    List<String> tags, {
    int target = kAliyunTargetDevice,
    String? alias,
  }) {
    return _recordVoid('unbindTag', {
      'tags': tags,
      'target': target,
      'alias': alias,
    });
  }
}

void main() {
  final originalPlatform = AliyunPushFlutterPlatform.instance;
  late AliyunPushFlutter plugin;
  late MockAliyunPushFlutterPlatform platform;

  setUp(() {
    plugin = AliyunPushFlutter();
    platform = MockAliyunPushFlutterPlatform();
    AliyunPushFlutterPlatform.instance = platform;
  });

  tearDown(() {
    AliyunPushFlutterPlatform.instance = originalPlatform;
  });

  void expectCall(String method, [Object? arguments]) {
    expect(platform.lastCall?.method, method);
    expect(platform.lastCall?.arguments, arguments);
  }

  Future<void> expectVoidCall(
    Future<void> result,
    String method, [
    Object? arguments,
  ]) async {
    await result;
    expectCall(method, arguments);
  }

  Future<void> expectListCall(
    Future<List<String>> result,
    String method, [
    Object? arguments,
  ]) async {
    expect(await result, platform.listResult);
    expectCall(method, arguments);
  }

  Future<void> expectChannelStatusCall(
    Future<AliyunPushChannelStatus> result,
    String method,
  ) async {
    expect(await result, platform.channelStatusResult);
    expectCall(method);
  }

  Future<void> expectStringCall(
    Future<String> result,
    String method,
  ) async {
    expect(await result, platform.stringResult);
    expectCall(method);
  }

  Future<void> expectBoolCall(
    Future<bool> result,
    String method, [
    Object? arguments,
  ]) async {
    expect(await result, platform.boolResult);
    expectCall(method, arguments);
  }

  test('uses the method-channel platform implementation by default', () {
    expect(originalPlatform, isA<MethodChannelAliyunPushFlutter>());
  });

  test('defines platform-specific log levels', () {
    expect(
      [
        kAliyunPushAndroidLogLevelError,
        kAliyunPushAndroidLogLevelInfo,
        kAliyunPushAndroidLogLevelDebug,
      ],
      [0, 1, 2],
    );
    expect(
      [
        kAliyunPushIOSLogLevelNone,
        kAliyunPushIOSLogLevelError,
        kAliyunPushIOSLogLevelWarn,
        kAliyunPushIOSLogLevelInfo,
        kAliyunPushIOSLogLevelDebug,
      ],
      [0, 1, 2, 3, 4],
    );
  });

  test('defines iOS foreground notice modes', () {
    expect(
      ForegroundNoticeMode.values.map((mode) => mode.value),
      [0, 1, 2],
    );
  });

  test('forwards all message receiver callbacks', () {
    Future<void> onNotification(Map<dynamic, dynamic> _) async {}
    Future<void> onMessage(Map<dynamic, dynamic> _) async {}
    Future<void> onNotificationOpened(Map<dynamic, dynamic> _) async {}
    Future<void> onNotificationRemoved(Map<dynamic, dynamic> _) async {}
    Future<void> onNotificationReceivedInApp(Map<dynamic, dynamic> _) async {}
    Future<void> onNotificationClickedWithNoAction(
      Map<dynamic, dynamic> _,
    ) async {}
    Future<void> onChannelOpened(Map<dynamic, dynamic> _) async {}
    Future<void> onRegisterDeviceTokenSuccess(Map<dynamic, dynamic> _) async {}
    Future<void> onRegisterDeviceTokenFailed(Map<dynamic, dynamic> _) async {}

    plugin.addMessageReceiver(
      onNotification: onNotification,
      onMessage: onMessage,
      onNotificationOpened: onNotificationOpened,
      onNotificationRemoved: onNotificationRemoved,
      onAndroidNotificationReceivedInApp: onNotificationReceivedInApp,
      onAndroidNotificationClickedWithNoAction:
          onNotificationClickedWithNoAction,
      onIOSChannelOpened: onChannelOpened,
      onIOSRegisterDeviceTokenSuccess: onRegisterDeviceTokenSuccess,
      onIOSRegisterDeviceTokenFailed: onRegisterDeviceTokenFailed,
    );

    expect(platform.lastCall?.method, 'addMessageReceiver');
    final callbacks = platform.lastCall?.arguments as Map<String, Object?>;
    expect(callbacks['onNotification'], same(onNotification));
    expect(callbacks['onMessage'], same(onMessage));
    expect(callbacks['onNotificationOpened'], same(onNotificationOpened));
    expect(callbacks['onNotificationRemoved'], same(onNotificationRemoved));
    expect(
      callbacks['onAndroidNotificationReceivedInApp'],
      same(onNotificationReceivedInApp),
    );
    expect(
      callbacks['onAndroidNotificationClickedWithNoAction'],
      same(onNotificationClickedWithNoAction),
    );
    expect(callbacks['onIOSChannelOpened'], same(onChannelOpened));
    expect(
      callbacks['onIOSRegisterDeviceTokenSuccess'],
      same(onRegisterDeviceTokenSuccess),
    );
    expect(
      callbacks['onIOSRegisterDeviceTokenFailed'],
      same(onRegisterDeviceTokenFailed),
    );
  });

  test('forwards initialization and device queries', () async {
    await expectVoidCall(
      plugin.initPush(appKey: 'app-key', appSecret: 'app-secret'),
      'initPush',
      {'appKey': 'app-key', 'appSecret': 'app-secret'},
    );
    await expectVoidCall(
      plugin.initAndroidThirdPush(),
      'initAndroidThirdPush',
    );
    await expectStringCall(plugin.getDeviceId(), 'getDeviceId');
    await expectStringCall(
      plugin.getApnsDeviceToken(),
      'getApnsDeviceToken',
    );
  });

  test('forwards account, phone, and alias operations', () async {
    await expectVoidCall(
      plugin.bindAccount('account'),
      'bindAccount',
      'account',
    );
    await expectVoidCall(plugin.unbindAccount(), 'unbindAccount');
    await expectVoidCall(
      plugin.bindPhoneNumber('13800138000'),
      'bindPhoneNumber',
      '13800138000',
    );
    await expectVoidCall(plugin.unbindPhoneNumber(), 'unbindPhoneNumber');
    await expectVoidCall(plugin.addAlias('alias'), 'addAlias', 'alias');
    await expectVoidCall(plugin.removeAlias('alias'), 'removeAlias', 'alias');
    await expectListCall(plugin.listAlias(), 'listAlias');
  });

  test('forwards device tag operations', () async {
    await expectVoidCall(
      plugin.bindDeviceTag(['tag-a']),
      'bindDeviceTag',
      ['tag-a'],
    );
    await expectVoidCall(
      plugin.unbindDeviceTag(['tag-b']),
      'unbindDeviceTag',
      ['tag-b'],
    );
    await expectListCall(plugin.listDeviceTags(), 'listDeviceTags');
  });

  test('keeps forwarding deprecated tag operations', () async {
    await expectVoidCall(
      plugin.bindTag(['tag-a']),
      'bindTag',
      {
        'tags': ['tag-a'],
        'target': kAliyunTargetDevice,
        'alias': null,
      },
    );
    await expectVoidCall(
      plugin.unbindTag(
        ['tag-b'],
        target: kAliyunTargetAlias,
        alias: 'alias',
      ),
      'unbindTag',
      {
        'tags': ['tag-b'],
        'target': kAliyunTargetAlias,
        'alias': 'alias',
      },
    );
    await expectListCall(
      plugin.listTags(),
      'listTags',
      kAliyunTargetDevice,
    );
    await expectListCall(
      plugin.listTags(target: kAliyunTargetAccount),
      'listTags',
      kAliyunTargetAccount,
    );
  });

  test('forwards Android notification operations', () async {
    await expectVoidCall(
      plugin.closeAndroidPushLog(),
      'closeAndroidPushLog',
    );
    await expectVoidCall(plugin.clearNotifications(), 'clearNotifications');
    await expectVoidCall(
      plugin.createAndroidChannel(
        'channel-id',
        'channel-name',
        4,
        'description',
        groupId: 'group-id',
        allowBubbles: true,
        light: true,
        lightColor: 0xff0000,
        showBadge: true,
        soundPath: 'sound.mp3',
        soundUsage: 5,
        soundContentType: 4,
        soundFlag: 1,
        vibration: true,
        vibrationPatterns: [100, 200],
      ),
      'createAndroidChannel',
      {
        'id': 'channel-id',
        'name': 'channel-name',
        'importance': 4,
        'description': 'description',
        'groupId': 'group-id',
        'allowBubbles': true,
        'light': true,
        'lightColor': 0xff0000,
        'showBadge': true,
        'soundPath': 'sound.mp3',
        'soundUsage': 5,
        'soundContentType': 4,
        'soundFlag': 1,
        'vibration': true,
        'vibrationPatterns': [100, 200],
      },
    );
    await expectVoidCall(
      plugin.createAndroidChannelGroup('group-id', 'group-name', 'group-desc'),
      'createAndroidChannelGroup',
      {
        'id': 'group-id',
        'name': 'group-name',
        'desc': 'group-desc',
      },
    );
    await expectBoolCall(
      plugin.isAndroidNotificationEnabled(id: 'channel-id'),
      'isAndroidNotificationEnabled',
      'channel-id',
    );

    await expectVoidCall(
      plugin.jumpToAndroidNotificationSettings(id: 'channel-id'),
      'jumpToAndroidNotificationSettings',
      'channel-id',
    );

    await expectVoidCall(
      plugin.setAndroidLogLevel(kAliyunPushAndroidLogLevelInfo),
      'setAndroidLogLevel',
      kAliyunPushAndroidLogLevelInfo,
    );
    await expectVoidCall(
      plugin.setAndroidBadgeNum(7),
      'setAndroidBadgeNum',
      7,
    );
    await expectVoidCall(
      plugin.setNotificationInGroup(true),
      'setNotificationInGroup',
      true,
    );
    await expectChannelStatusCall(
      plugin.checkAndroidPushChannelStatus(),
      'checkAndroidPushChannelStatus',
    );
    await expectVoidCall(
      plugin.turnOnAndroidPushChannel(),
      'turnOnAndroidPushChannel',
    );
    await expectVoidCall(
      plugin.turnOffAndroidPushChannel(),
      'turnOffAndroidPushChannel',
    );
  });

  test('forwards iOS operations', () async {
    await expectBoolCall(
      plugin.isIOSChannelOpened(),
      'isIOSChannelOpened',
    );
    await expectVoidCall(
      plugin.setIOSBadgeNum(3),
      'setIOSBadgeNum',
      3,
    );
    await expectVoidCall(
      plugin.syncIOSBadgeNum(4),
      'syncIOSBadgeNum',
      4,
    );
    await expectVoidCall(
      plugin.setIOSForegroundNoticeMode(
        ForegroundNoticeMode.showAndCallback,
      ),
      'setIOSForegroundNoticeMode',
      ForegroundNoticeMode.showAndCallback,
    );
    await expectVoidCall(
      plugin.showIOSNoticeWhenForeground(true),
      'setIOSForegroundNoticeMode',
      ForegroundNoticeMode.showOnly,
    );
    await expectVoidCall(
      plugin.showIOSNoticeWhenForeground(false),
      'setIOSForegroundNoticeMode',
      ForegroundNoticeMode.callbackOnly,
    );
    await expectVoidCall(
      plugin.turnOnIOSDebug(),
      'turnOnIOSDebug',
    );
    await expectVoidCall(
      plugin.setIOSLogLevel(kAliyunPushIOSLogLevelDebug),
      'setIOSLogLevel',
      kAliyunPushIOSLogLevelDebug,
    );
  });

  test('forwards plugin log setting', () async {
    await expectVoidCall(
      plugin.setPluginLogEnabled(true),
      'setPluginLogEnabled',
      true,
    );
  });
}
