import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'aliyun_push_flutter_method_channel.dart';
import 'aliyun_push_flutter.dart';

typedef PushCallback = Future<dynamic> Function(Map<dynamic, dynamic> message);

abstract class AliyunPushFlutterPlatform extends PlatformInterface {
  /// Constructs a AliyunPushFlutterPlatform.
  AliyunPushFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static AliyunPushFlutterPlatform _instance = MethodChannelAliyunPushFlutter();

  /// The default instance of [AliyunPushFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelAliyunPushFlutter].
  static AliyunPushFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AliyunPushFlutterPlatform] when
  /// they register themselves.
  static set instance(AliyunPushFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

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
    throw UnimplementedError('addMessageReceiver() has not been implemented.');
  }

  /// 注册推送
  Future<void> initPush({
    String? appKey,
    String? appSecret,
  }) async {
    throw UnimplementedError('initPush() has not been implemented.');
  }

  /// 注册厂商通道
  Future<void> initAndroidThirdPush() async {
    throw UnimplementedError(
        'initAndroidThirdPush() has not been implemented.');
  }

  /// 关闭 Android 推送日志
  Future<void> closeAndroidPushLog() async {
    throw UnimplementedError('closeAndroidPushLog() has not been implemented.');
  }

  /// 获取 deviceId
  Future<String> getDeviceId() async {
    throw UnimplementedError('getDeviceId() has not been implemented.');
  }

  /// 设置 Android log 的级别
  Future<void> setAndroidLogLevel(int level) async {
    throw UnimplementedError('setAndroidLogLevel() has not been implemented.');
  }

  /// Android 设置角标数
  Future<void> setAndroidBadgeNum(int num) async {
    throw UnimplementedError('setAndroidBadgeNum() has not been implemented.');
  }

  /// 绑定账号
  Future<void> bindAccount(String account) async {
    throw UnimplementedError('bindAccount() has not been implemented.');
  }

  /// 解绑账号
  Future<void> unbindAccount() async {
    throw UnimplementedError('unbindAccount() has not been implemented.');
  }

  /// 添加别名
  Future<void> addAlias(String alias) async {
    throw UnimplementedError('addAlias() has not been implemented.');
  }

  /// 移除别名
  Future<void> removeAlias(String alias) async {
    throw UnimplementedError('removeAlias() has not been implemented.');
  }

  /// 查询绑定别名
  Future<List<String>> listAlias() async {
    throw UnimplementedError('listAlias() has not been implemented.');
  }

  /// 绑定设备标签。
  Future<void> bindDeviceTag(List<String> tags) {
    // ignore: deprecated_member_use_from_same_package
    return bindTag(tags, target: kAliyunTargetDevice);
  }

  /// 添加标签。
  @Deprecated('Use bindDeviceTag instead.')
  Future<void> bindTag(List<String> tags,
      {int target = kAliyunTargetDevice, String? alias}) async {
    throw UnimplementedError('bindTag() has not been implemented.');
  }

  /// 解绑设备标签。
  Future<void> unbindDeviceTag(List<String> tags) {
    // ignore: deprecated_member_use_from_same_package
    return unbindTag(tags, target: kAliyunTargetDevice);
  }

  /// 移除标签。
  @Deprecated('Use unbindDeviceTag instead.')
  Future<void> unbindTag(List<String> tags,
      {int target = kAliyunTargetDevice, String? alias}) async {
    throw UnimplementedError('unbindTag() has not been implemented.');
  }

  /// 查询当前设备绑定的标签。
  Future<List<String>> listDeviceTags() {
    // ignore: deprecated_member_use_from_same_package
    return listTags(target: kAliyunTargetDevice);
  }

  /// 查询标签列表。
  @Deprecated('Use listDeviceTags instead.')
  Future<List<String>> listTags({int target = kAliyunTargetDevice}) async {
    throw UnimplementedError('listTags() has not been implemented.');
  }

  /// 绑定手机号码
  Future<void> bindPhoneNumber(String phone) async {
    throw UnimplementedError('bindPhoneNumber() has not been implemented.');
  }

  /// 解绑手机号码
  Future<void> unbindPhoneNumber() async {
    throw UnimplementedError('unbindPhoneNumber() has not been implemented.');
  }

  /// 设置通知分组展示，只支持 Android
  Future<void> setNotificationInGroup(bool inGroup) async {
    throw UnimplementedError(
        'setNotificationInGroup() has not been implemented.');
  }

  /// 清除所有通知
  Future<void> clearNotifications() async {
    throw UnimplementedError('clearNotifications() has not been implemented.');
  }

  /// 创建 Android 平台的NotificationChannel
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
    throw UnimplementedError(
        'createAndroidChannel() has not been implemented.');
  }

  /// 创建通知通道的分组
  Future<void> createAndroidChannelGroup(
    String id,
    String name,
    String desc,
  ) async {
    throw UnimplementedError(
        'createAndroidChannelGroup() has not been implemented.');
  }

  /// 检查通知状态
  Future<bool> isAndroidNotificationEnabled({String? id}) async {
    throw UnimplementedError(
        'isAndroidNotificationEnabled() has not been implemented.');
  }

  /// 跳转到通知设置页面
  Future<void> jumpToAndroidNotificationSettings({String? id}) async {
    throw UnimplementedError(
        'jumpToAndroidNotificationSettings() has not been implemented.');
  }

  /// 已废弃，请改用 setIOSLogLevel(4) 开启 iOS Debug 日志。
  @Deprecated(
      "Use setIOSLogLevel(4) instead. The underlying iOS SDK turnOnDebug API is deprecated.")
  Future<void> turnOnIOSDebug() async {
    throw UnimplementedError('turnOnIOSDebug() has not been implemented.');
  }

  /// 设置 iOS log 级别
  Future<void> setIOSLogLevel(int level) async {
    throw UnimplementedError('setIOSLogLevel() has not been implemented.');
  }

  /// 设置 iOS App 处于前台时的通知处理模式。
  Future<void> setIOSForegroundNoticeMode(ForegroundNoticeMode mode) async {
    throw UnimplementedError(
        'setIOSForegroundNoticeMode() has not been implemented.');
  }

  /// App处于前台时是否显示通知。
  ///
  /// 已废弃，请改用 [setIOSForegroundNoticeMode]。
  @Deprecated(
      'Use setIOSForegroundNoticeMode with ForegroundNoticeMode instead.')
  Future<void> showIOSNoticeWhenForeground(bool enable) async {
    return setIOSForegroundNoticeMode(
      enable
          ? ForegroundNoticeMode.showOnly
          : ForegroundNoticeMode.callbackOnly,
    );
  }

  /// iOS 设置角标数
  Future<void> setIOSBadgeNum(int num) async {
    throw UnimplementedError('setIOSBadgeNum() has not been implemented.');
  }

  /// iOS 同步角标数
  Future<void> syncIOSBadgeNum(int num) async {
    throw UnimplementedError('syncIOSBadgeNum() has not been implemented.');
  }

  /// 获取 APNs Token
  Future<String> getApnsDeviceToken() async {
    throw UnimplementedError('getApnsDeviceToken() has not been implemented.');
  }

  /// iOS 通知通道是否已打开
  Future<bool> isIOSChannelOpened() async {
    throw UnimplementedError('isIOSChannelOpened() has not been implemented.');
  }

  /// 设置是否开启插件日志
  Future<void> setPluginLogEnabled(bool enabled) async {
    throw UnimplementedError('setPluginLogEnabled() has not been implemented.');
  }

  /// Android 查询推送通道状态
  Future<AliyunPushChannelStatus> checkAndroidPushChannelStatus() async {
    throw UnimplementedError(
        'checkAndroidPushChannelStatus() has not been implemented.');
  }

  /// Android 开启推送通道
  Future<void> turnOnAndroidPushChannel() async {
    throw UnimplementedError(
        'turnOnAndroidPushChannel() has not been implemented.');
  }

  /// Android 关闭推送通道
  Future<void> turnOffAndroidPushChannel() async {
    throw UnimplementedError(
        'turnOffAndroidPushChannel() has not been implemented.');
  }
}
