import 'package:aliyun_push_flutter/aliyun_push_flutter.dart';
import 'package:aliyun_push_flutter/aliyun_push_flutter_method_channel.dart';
import 'package:aliyun_push_flutter/aliyun_push_flutter_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAliyunPushFlutterPlatform
    with MockPlatformInterfaceMixin
    implements AliyunPushFlutterPlatform {
  final mapResult = <dynamic, dynamic>{'code': 'mock'};
  final stringResult = 'mock-string';
  final boolResult = true;

  ({String method, Object? arguments})? lastCall;

  void _record(String method, [Object? arguments]) {
    lastCall = (method: method, arguments: arguments);
  }

  Future<Map<dynamic, dynamic>> _recordMap(
    String method, [
    Object? arguments,
  ]) async {
    _record(method, arguments);
    return mapResult;
  }

  @override
  Future<Map<dynamic, dynamic>> addAlias(String alias) {
    return _recordMap('addAlias', alias);
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
  Future<Map<dynamic, dynamic>> bindAccount(String account) {
    return _recordMap('bindAccount', account);
  }

  @override
  Future<Map<dynamic, dynamic>> bindPhoneNumber(String phone) {
    return _recordMap('bindPhoneNumber', phone);
  }

  @override
  Future<Map<dynamic, dynamic>> bindTag(
    List<String> tags, {
    int target = kAliyunTargetDevice,
    String? alias,
  }) {
    return _recordMap('bindTag', {
      'tags': tags,
      'target': target,
      'alias': alias,
    });
  }

  @override
  Future<Map<dynamic, dynamic>> checkAndroidPushChannelStatus() {
    return _recordMap('checkAndroidPushChannelStatus');
  }

  @override
  Future<Map<dynamic, dynamic>> clearNotifications() {
    return _recordMap('clearNotifications');
  }

  @override
  Future<Map<dynamic, dynamic>> closeAndroidPushLog() {
    return _recordMap('closeAndroidPushLog');
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
  }) {
    return _recordMap('createAndroidChannel', {
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
  Future<Map<dynamic, dynamic>> createAndroidChannelGroup(
    String id,
    String name,
    String desc,
  ) {
    return _recordMap('createAndroidChannelGroup', {
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
  Future<Map<dynamic, dynamic>> initAndroidThirdPush() {
    return _recordMap('initAndroidThirdPush');
  }

  @override
  Future<Map<dynamic, dynamic>> initPush({
    String? appKey,
    String? appSecret,
  }) {
    return _recordMap('initPush', {
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
  void jumpToAndroidNotificationSettings({String? id}) {
    _record('jumpToAndroidNotificationSettings', id);
  }

  @override
  Future<Map<dynamic, dynamic>> listAlias() {
    return _recordMap('listAlias');
  }

  @override
  Future<Map<dynamic, dynamic>> listTags({
    int target = kAliyunTargetDevice,
  }) {
    return _recordMap('listTags', target);
  }

  @override
  Future<Map<dynamic, dynamic>> removeAlias(String alias) {
    return _recordMap('removeAlias', alias);
  }

  @override
  Future<Map<dynamic, dynamic>> setAndroidLogLevel(int level) {
    return _recordMap('setAndroidLogLevel', level);
  }

  @override
  Future<Map<dynamic, dynamic>> setAndroidBadgeNum(int num) {
    return _recordMap('setAndroidBadgeNum', num);
  }

  @override
  Future<Map<dynamic, dynamic>> setIOSBadgeNum(int num) {
    return _recordMap('setIOSBadgeNum', num);
  }

  @override
  Future<Map<dynamic, dynamic>> setIOSLogLevel(int level) {
    return _recordMap('setIOSLogLevel', level);
  }

  @override
  Future<Map<dynamic, dynamic>> setNotificationInGroup(bool inGroup) {
    return _recordMap('setNotificationInGroup', inGroup);
  }

  @override
  void setPluginLogEnabled(bool enabled) {
    _record('setPluginLogEnabled', enabled);
  }

  @override
  Future<Map<dynamic, dynamic>> showIOSNoticeWhenForeground(bool enable) {
    return _recordMap('showIOSNoticeWhenForeground', enable);
  }

  @override
  Future<Map<dynamic, dynamic>> syncIOSBadgeNum(int num) {
    return _recordMap('syncIOSBadgeNum', num);
  }

  @override
  Future<Map<dynamic, dynamic>> turnOffAndroidPushChannel() {
    return _recordMap('turnOffAndroidPushChannel');
  }

  @override
  Future<Map<dynamic, dynamic>> turnOnAndroidPushChannel() {
    return _recordMap('turnOnAndroidPushChannel');
  }

  @override
  Future<Map<dynamic, dynamic>> turnOnIOSDebug() {
    return _recordMap('turnOnIOSDebug');
  }

  @override
  Future<Map<dynamic, dynamic>> unbindAccount() {
    return _recordMap('unbindAccount');
  }

  @override
  Future<Map<dynamic, dynamic>> unbindPhoneNumber() {
    return _recordMap('unbindPhoneNumber');
  }

  @override
  Future<Map<dynamic, dynamic>> unbindTag(
    List<String> tags, {
    int target = kAliyunTargetDevice,
    String? alias,
  }) {
    return _recordMap('unbindTag', {
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

  Future<void> expectMapCall(
    Future<Map<dynamic, dynamic>> result,
    String method, [
    Object? arguments,
  ]) async {
    expect(await result, same(platform.mapResult));
    expectCall(method, arguments);
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
    await expectMapCall(
      plugin.initPush(appKey: 'app-key', appSecret: 'app-secret'),
      'initPush',
      {'appKey': 'app-key', 'appSecret': 'app-secret'},
    );
    await expectMapCall(
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
    await expectMapCall(
      plugin.bindAccount('account'),
      'bindAccount',
      'account',
    );
    await expectMapCall(plugin.unbindAccount(), 'unbindAccount');
    await expectMapCall(
      plugin.bindPhoneNumber('13800138000'),
      'bindPhoneNumber',
      '13800138000',
    );
    await expectMapCall(plugin.unbindPhoneNumber(), 'unbindPhoneNumber');
    await expectMapCall(plugin.addAlias('alias'), 'addAlias', 'alias');
    await expectMapCall(plugin.removeAlias('alias'), 'removeAlias', 'alias');
    await expectMapCall(plugin.listAlias(), 'listAlias');
  });

  test('forwards tag operations and default targets', () async {
    await expectMapCall(
      plugin.bindTag(['tag-a']),
      'bindTag',
      {
        'tags': ['tag-a'],
        'target': kAliyunTargetDevice,
        'alias': null,
      },
    );
    await expectMapCall(
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
    await expectMapCall(
      plugin.listTags(),
      'listTags',
      kAliyunTargetDevice,
    );
    await expectMapCall(
      plugin.listTags(target: kAliyunTargetAccount),
      'listTags',
      kAliyunTargetAccount,
    );
  });

  test('forwards Android notification operations', () async {
    await expectMapCall(
      plugin.closeAndroidPushLog(),
      'closeAndroidPushLog',
    );
    await expectMapCall(plugin.clearNotifications(), 'clearNotifications');
    await expectMapCall(
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
    await expectMapCall(
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

    plugin.jumpToAndroidNotificationSettings(id: 'channel-id');
    expectCall('jumpToAndroidNotificationSettings', 'channel-id');

    await expectMapCall(
      plugin.setAndroidLogLevel(kAliyunPushAndroidLogLevelInfo),
      'setAndroidLogLevel',
      kAliyunPushAndroidLogLevelInfo,
    );
    await expectMapCall(
      plugin.setAndroidBadgeNum(7),
      'setAndroidBadgeNum',
      7,
    );
    await expectMapCall(
      plugin.setNotificationInGroup(true),
      'setNotificationInGroup',
      true,
    );
    await expectMapCall(
      plugin.checkAndroidPushChannelStatus(),
      'checkAndroidPushChannelStatus',
    );
    await expectMapCall(
      plugin.turnOnAndroidPushChannel(),
      'turnOnAndroidPushChannel',
    );
    await expectMapCall(
      plugin.turnOffAndroidPushChannel(),
      'turnOffAndroidPushChannel',
    );
  });

  test('forwards iOS operations', () async {
    await expectBoolCall(
      plugin.isIOSChannelOpened(),
      'isIOSChannelOpened',
    );
    await expectMapCall(
      plugin.setIOSBadgeNum(3),
      'setIOSBadgeNum',
      3,
    );
    await expectMapCall(
      plugin.syncIOSBadgeNum(4),
      'syncIOSBadgeNum',
      4,
    );
    await expectMapCall(
      plugin.showIOSNoticeWhenForeground(true),
      'showIOSNoticeWhenForeground',
      true,
    );
    await expectMapCall(
      plugin.turnOnIOSDebug(),
      'turnOnIOSDebug',
    );
    await expectMapCall(
      plugin.setIOSLogLevel(kAliyunPushIOSLogLevelDebug),
      'setIOSLogLevel',
      kAliyunPushIOSLogLevelDebug,
    );
  });

  test('forwards plugin log setting', () {
    plugin.setPluginLogEnabled(true);

    expectCall('setPluginLogEnabled', true);
  });
}
