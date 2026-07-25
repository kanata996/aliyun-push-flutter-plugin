import 'aliyun_push_flutter_platform_interface.dart';
import 'aliyun_push_exception.dart';

export 'aliyun_push_exception.dart';

/// 失败
const kAliyunPushFailedCode = "10002";

/// Android LogLevel error
const kAliyunPushAndroidLogLevelError = 0;

/// Android LogLevel info
const kAliyunPushAndroidLogLevelInfo = 1;

/// Android LogLevel debug
const kAliyunPushAndroidLogLevelDebug = 2;

/// iOS LogLevel none
const kAliyunPushIOSLogLevelNone = 0;

/// iOS LogLevel error
const kAliyunPushIOSLogLevelError = 1;

/// iOS LogLevel warn
const kAliyunPushIOSLogLevelWarn = 2;

/// iOS LogLevel info
const kAliyunPushIOSLogLevelInfo = 3;

/// iOS LogLevel debug
const kAliyunPushIOSLogLevelDebug = 4;

/// iOS 前台通知处理模式。
enum ForegroundNoticeMode {
  /// 仅触发回调，不展示通知。
  callbackOnly(0),

  /// 仅展示通知，不触发回调。
  showOnly(1),

  /// 展示通知且触发回调。
  showAndCallback(2);

  /// 传递给 iOS 原生实现的模式值。
  final int value;

  const ForegroundNoticeMode(this.value);
}

/// Android LogLevel debug
@Deprecated('Use kAliyunPushAndroidLogLevelDebug instead.')
const kAliyunPushLogLevelDebug = kAliyunPushAndroidLogLevelDebug;

/// Android LogLevel error
@Deprecated('Use kAliyunPushAndroidLogLevelError instead.')
const kAliyunPushLogLevelError = kAliyunPushAndroidLogLevelError;

/// Android LogLevel info
@Deprecated('Use kAliyunPushAndroidLogLevelInfo instead.')
const kAliyunPushLogLevelInfo = kAliyunPushAndroidLogLevelInfo;

/// 不支持
const kAliyunPushNotSupport = "10005";

/// 仅支持Android
const kAliyunPushOnlyAndroid = "10003";

/// 仅支持iOS
const kAliyunPushOnlyIOS = "10004";

/// 参数错误
const kAliyunPushParamsIllegal = "10001";

/// 成功
const kAliyunPushSuccessCode = "10000";

/// 本设备绑定账号
@Deprecated(
    'Account tags are no longer recommended. Use the device tag APIs instead.')
const kAliyunTargetAccount = 2;

/// 别名
@Deprecated(
    'Alias tags are no longer recommended. Use the device tag APIs instead.')
const kAliyunTargetAlias = 3;

/// 本设备
const kAliyunTargetDevice = 1;

/// 阿里云推送插件入口。
///
/// 所有实例共享同一个平台实现和消息回调注册状态。
class AliyunPushFlutter {
  /// 注册消息回调。
  ///
  /// 再次调用会替换此前注册的全部回调，未传入的回调会被清空。
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
    return AliyunPushFlutterPlatform.instance.addMessageReceiver(
      onNotification: onNotification,
      onMessage: onMessage,
      onNotificationOpened: onNotificationOpened,
      onNotificationRemoved: onNotificationRemoved,
      onAndroidNotificationReceivedInApp: onAndroidNotificationReceivedInApp,
      onAndroidNotificationClickedWithNoAction:
          onAndroidNotificationClickedWithNoAction,
      onIOSChannelOpened: onIOSChannelOpened,
      onIOSRegisterDeviceTokenSuccess: onIOSRegisterDeviceTokenSuccess,
      onIOSRegisterDeviceTokenFailed: onIOSRegisterDeviceTokenFailed,
    );
  }

  /// 添加别名
  Future<void> addAlias(String alias) async {
    return AliyunPushFlutterPlatform.instance.addAlias(alias);
  }

  /// 绑定账号
  Future<void> bindAccount(String account) async {
    return AliyunPushFlutterPlatform.instance.bindAccount(account);
  }

  /// 绑定手机号码
  Future<void> bindPhoneNumber(String phone) async {
    return AliyunPushFlutterPlatform.instance.bindPhoneNumber(phone);
  }

  /// 绑定设备标签。
  Future<void> bindDeviceTag(List<String> tags) async {
    return AliyunPushFlutterPlatform.instance.bindDeviceTag(tags);
  }

  /// 添加标签。
  ///
  /// 已废弃，请改用 [bindDeviceTag]。账号和别名维度的标签操作不再建议使用。
  @Deprecated('Use bindDeviceTag instead.')
  Future<void> bindTag(List<String> tags,
      {int target = kAliyunTargetDevice, String? alias}) async {
    return AliyunPushFlutterPlatform.instance
        .bindTag(tags, target: target, alias: alias);
  }

  /// 清除所有通知
  Future<void> clearNotifications() async {
    return AliyunPushFlutterPlatform.instance.clearNotifications();
  }

  /// 关闭 Android 推送日志
  Future<void> closeAndroidPushLog() async {
    return AliyunPushFlutterPlatform.instance.closeAndroidPushLog();
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
    return AliyunPushFlutterPlatform.instance.createAndroidChannel(
      id,
      name,
      importance,
      description,
      groupId: groupId,
      allowBubbles: allowBubbles,
      light: light,
      lightColor: lightColor,
      showBadge: showBadge,
      soundPath: soundPath,
      soundUsage: soundUsage,
      soundContentType: soundContentType,
      soundFlag: soundFlag,
      vibration: vibration,
      vibrationPatterns: vibrationPatterns,
    );
  }

  /// 创建通知通道的分组
  Future<void> createAndroidChannelGroup(
    String id,
    String name,
    String desc,
  ) async {
    return AliyunPushFlutterPlatform.instance
        .createAndroidChannelGroup(id, name, desc);
  }

  /// 获取APNs Token
  Future<String> getApnsDeviceToken() async {
    return AliyunPushFlutterPlatform.instance.getApnsDeviceToken();
  }

  /// 获取 deviceId
  Future<String> getDeviceId() async {
    return AliyunPushFlutterPlatform.instance.getDeviceId();
  }

  /// 注册厂商通道
  Future<void> initAndroidThirdPush() async {
    return AliyunPushFlutterPlatform.instance.initAndroidThirdPush();
  }

  /// 注册推送
  Future<void> initPush({String? appKey, String? appSecret}) async {
    return AliyunPushFlutterPlatform.instance
        .initPush(appKey: appKey, appSecret: appSecret);
  }

  /// 检查通知状态
  Future<bool> isAndroidNotificationEnabled({String? id}) async {
    return AliyunPushFlutterPlatform.instance
        .isAndroidNotificationEnabled(id: id);
  }

  /// iOS 通知通道是否已打开
  Future<bool> isIOSChannelOpened() async {
    return AliyunPushFlutterPlatform.instance.isIOSChannelOpened();
  }

  /// 跳转到通知设置页面
  Future<void> jumpToAndroidNotificationSettings({String? id}) async {
    return AliyunPushFlutterPlatform.instance
        .jumpToAndroidNotificationSettings(id: id);
  }

  /// 查询绑定别名
  Future<List<String>> listAlias() async {
    return AliyunPushFlutterPlatform.instance.listAlias();
  }

  /// 查询当前设备绑定的标签。
  Future<List<String>> listDeviceTags() async {
    return AliyunPushFlutterPlatform.instance.listDeviceTags();
  }

  /// 查询标签列表。
  ///
  /// 已废弃，请改用 [listDeviceTags]。
  @Deprecated('Use listDeviceTags instead.')
  Future<List<String>> listTags({int target = kAliyunTargetDevice}) async {
    return AliyunPushFlutterPlatform.instance.listTags(target: target);
  }

  /// 移除别名
  Future<void> removeAlias(String alias) async {
    return AliyunPushFlutterPlatform.instance.removeAlias(alias);
  }

  /// 设置 Android log 的级别
  Future<void> setAndroidLogLevel(int level) async {
    return AliyunPushFlutterPlatform.instance.setAndroidLogLevel(level);
  }

  /// Android 设置角标数
  Future<void> setAndroidBadgeNum(int num) async {
    return AliyunPushFlutterPlatform.instance.setAndroidBadgeNum(num);
  }

  /// 设置角标数
  Future<void> setIOSBadgeNum(int num) async {
    return AliyunPushFlutterPlatform.instance.setIOSBadgeNum(num);
  }

  /// 设置通知分组展示，只支持 Android
  Future<void> setNotificationInGroup(bool inGroup) async {
    return AliyunPushFlutterPlatform.instance.setNotificationInGroup(inGroup);
  }

  /// 设置插件日志
  Future<void> setPluginLogEnabled(bool enabled) async {
    return AliyunPushFlutterPlatform.instance.setPluginLogEnabled(enabled);
  }

  /// 设置 iOS App 处于前台时的通知处理模式。
  Future<void> setIOSForegroundNoticeMode(ForegroundNoticeMode mode) async {
    return AliyunPushFlutterPlatform.instance.setIOSForegroundNoticeMode(mode);
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

  /// 同步角标数
  Future<void> syncIOSBadgeNum(int num) async {
    return AliyunPushFlutterPlatform.instance.syncIOSBadgeNum(num);
  }

  /// 已废弃，请改用 setIOSLogLevel(4) 开启 iOS Debug 日志。
  @Deprecated(
      "Use setIOSLogLevel(4) instead. The underlying iOS SDK turnOnDebug API is deprecated.")
  Future<void> turnOnIOSDebug() async {
    return AliyunPushFlutterPlatform.instance.turnOnIOSDebug();
  }

  /// 设置 iOS log 的级别
  Future<void> setIOSLogLevel(int level) async {
    return AliyunPushFlutterPlatform.instance.setIOSLogLevel(level);
  }

  /// 解绑账号
  Future<void> unbindAccount() async {
    return AliyunPushFlutterPlatform.instance.unbindAccount();
  }

  /// 解绑手机号码
  Future<void> unbindPhoneNumber() async {
    return AliyunPushFlutterPlatform.instance.unbindPhoneNumber();
  }

  /// 解绑设备标签。
  Future<void> unbindDeviceTag(List<String> tags) async {
    return AliyunPushFlutterPlatform.instance.unbindDeviceTag(tags);
  }

  /// 移除标签。
  ///
  /// 已废弃，请改用 [unbindDeviceTag]。账号和别名维度的标签操作不再建议使用。
  @Deprecated('Use unbindDeviceTag instead.')
  Future<void> unbindTag(List<String> tags,
      {int target = kAliyunTargetDevice, String? alias}) async {
    return AliyunPushFlutterPlatform.instance
        .unbindTag(tags, target: target, alias: alias);
  }

  /// Android 查询推送通道状态
  Future<AliyunPushChannelStatus> checkAndroidPushChannelStatus() async {
    return AliyunPushFlutterPlatform.instance.checkAndroidPushChannelStatus();
  }

  /// Android 开启推送通道
  Future<void> turnOnAndroidPushChannel() async {
    return AliyunPushFlutterPlatform.instance.turnOnAndroidPushChannel();
  }

  /// Android 关闭推送通道
  Future<void> turnOffAndroidPushChannel() async {
    return AliyunPushFlutterPlatform.instance.turnOffAndroidPushChannel();
  }
}
