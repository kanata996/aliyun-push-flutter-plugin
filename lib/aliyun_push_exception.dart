/// MethodChannel 没有找到对应平台实现。
const kAliyunPushMissingPluginCode = 'missing_plugin';

/// 原生平台返回了不符合插件协议的数据。
const kAliyunPushInvalidResponseCode = 'invalid_response';

/// 推送通道的开关状态。
enum AliyunPushChannelStatus {
  /// 推送通道已开启。
  enabled,

  /// 推送通道已关闭。
  disabled,
}

/// 阿里云推送操作失败。
final class AliyunPushException implements Exception {
  /// 创建一个阿里云推送异常。
  const AliyunPushException({
    required this.code,
    required this.message,
    required this.operation,
    this.cause,
  });

  /// 原生 SDK 或插件返回的错误码。
  final String code;

  /// 错误信息。
  final String message;

  /// 失败的插件 API 名称。
  final String operation;

  /// 导致当前异常的底层异常。
  final Object? cause;

  @override
  String toString() {
    return 'AliyunPushException($code, $operation): $message';
  }
}
