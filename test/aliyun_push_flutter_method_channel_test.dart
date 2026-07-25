import 'dart:async';

import 'package:aliyun_push_flutter/aliyun_push_flutter.dart';
import 'package:aliyun_push_flutter/aliyun_push_flutter_method_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('aliyun_push');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late MethodChannelAliyunPushFlutter platform;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    platform = MethodChannelAliyunPushFlutter();
    messenger.setMockMethodCallHandler(channel, (_) async => null);
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    platform.methodChannel.setMethodCallHandler(null);
    messenger.setMockMethodCallHandler(channel, null);
  });

  Future<ByteData?> sendPlatformCall(String method, Object? arguments) {
    return messenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(MethodCall(method, arguments)),
      null,
    );
  }

  test('ignores events without a registered callback', () async {
    Map<dynamic, dynamic>? receivedMessage;
    platform.addMessageReceiver(
      onMessage: (message) async => receivedMessage = message,
    );

    await sendPlatformCall('onNotification', {'title': 'ignored'});
    await sendPlatformCall('onMessage', {'title': 'received'});

    expect(receivedMessage, {'title': 'received'});
  });

  test('ignores callback events with malformed arguments', () async {
    platform.addMessageReceiver(onMessage: (_) async {});

    await sendPlatformCall('onMessage', 'invalid');
  });

  test('dispatches each event to its registered callback', () async {
    final receivedEvents = <String, Map<dynamic, dynamic>>{};
    final events = [
      'onNotification',
      'onNotificationReceivedInApp',
      'onMessage',
      'onNotificationOpened',
      'onNotificationRemoved',
      'onNotificationClickedWithNoAction',
      'onChannelOpened',
      'onRegisterDeviceTokenSuccess',
      'onRegisterDeviceTokenFailed',
    ];
    Future<void> record(
      String event,
      Map<dynamic, dynamic> message,
    ) async {
      receivedEvents[event] = message;
    }

    platform.addMessageReceiver(
      onNotification: (message) => record('onNotification', message),
      onAndroidNotificationReceivedInApp: (message) =>
          record('onNotificationReceivedInApp', message),
      onMessage: (message) => record('onMessage', message),
      onNotificationOpened: (message) =>
          record('onNotificationOpened', message),
      onNotificationRemoved: (message) =>
          record('onNotificationRemoved', message),
      onAndroidNotificationClickedWithNoAction: (message) =>
          record('onNotificationClickedWithNoAction', message),
      onIOSChannelOpened: (message) => record('onChannelOpened', message),
      onIOSRegisterDeviceTokenSuccess: (message) =>
          record('onRegisterDeviceTokenSuccess', message),
      onIOSRegisterDeviceTokenFailed: (message) =>
          record('onRegisterDeviceTokenFailed', message),
    );

    for (final event in events) {
      await sendPlatformCall(event, {'event': event});
    }

    expect(receivedEvents, {
      for (final event in events) event: {'event': event},
    });
  });

  test('decodes Android notification extraMap JSON strings', () async {
    Map<dynamic, dynamic>? receivedMessage;
    platform.addMessageReceiver(
      onNotificationOpened: (message) async => receivedMessage = message,
    );

    await sendPlatformCall('onNotificationOpened', {
      'title': 'title',
      'extraMap': '{"page":"detail","id":"42"}',
    });

    expect(receivedMessage, {
      'title': 'title',
      'extraMap': {'page': 'detail', 'id': '42'},
    });
  });

  test('keeps Android notification extraMap maps', () async {
    Map<dynamic, dynamic>? receivedMessage;
    platform.addMessageReceiver(
      onNotification: (message) async => receivedMessage = message,
    );

    await sendPlatformCall('onNotification', {
      'extraMap': {'page': 'home'},
    });

    expect(receivedMessage, {
      'extraMap': {'page': 'home'},
    });
  });

  test('normalizes empty Android notification extraMap values', () async {
    final receivedMessages = <Map<dynamic, dynamic>>[];
    platform.addMessageReceiver(
      onNotificationOpened: (message) async => receivedMessages.add(message),
    );

    await sendPlatformCall('onNotificationOpened', {'extraMap': ''});
    await sendPlatformCall('onNotificationOpened', {'extraMap': null});

    expect(receivedMessages, [
      {'extraMap': <String, dynamic>{}},
      {'extraMap': <String, dynamic>{}},
    ]);
  });

  test('preserves malformed Android extraMap strings for diagnostics',
      () async {
    Map<dynamic, dynamic>? receivedMessage;
    platform.addMessageReceiver(
      onAndroidNotificationClickedWithNoAction: (message) async =>
          receivedMessage = message,
    );

    await sendPlatformCall('onNotificationClickedWithNoAction', {
      'extraMap': 'invalid JSON',
    });

    expect(receivedMessage, {
      'extraMap': <String, dynamic>{},
      'extraMapRaw': 'invalid JSON',
    });
  });

  test('does not normalize iOS notification payload fields', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    Map<dynamic, dynamic>? receivedMessage;
    platform.addMessageReceiver(
      onNotificationOpened: (message) async => receivedMessage = message,
    );

    await sendPlatformCall('onNotificationOpened', {
      'extraMap': '{"custom":"value"}',
    });

    expect(receivedMessage, {
      'extraMap': '{"custom":"value"}',
    });
  });

  test('forwards plugin log setting to the platform', () async {
    final nativeCall = Completer<MethodCall>();
    messenger.setMockMethodCallHandler(channel, (call) async {
      nativeCall.complete(call);
      return null;
    });

    await platform.setPluginLogEnabled(true);

    expect(
      await nativeCall.future,
      isMethodCall(
        'setPluginLogEnabled',
        arguments: {'enabled': true},
      ),
    );
  });

  test('forwards iOS foreground notice modes to the platform', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return {'code': kAliyunPushSuccessCode};
    });

    await platform.setIOSForegroundNoticeMode(
      ForegroundNoticeMode.callbackOnly,
    );
    await platform.setIOSForegroundNoticeMode(ForegroundNoticeMode.showOnly);
    await platform.setIOSForegroundNoticeMode(
      ForegroundNoticeMode.showAndCallback,
    );
    // ignore: deprecated_member_use_from_same_package
    await platform.showIOSNoticeWhenForeground(true);
    // ignore: deprecated_member_use_from_same_package
    await platform.showIOSNoticeWhenForeground(false);

    expect(calls, [
      isMethodCall(
        'showNoticeWhenForeground',
        arguments: {'mode': ForegroundNoticeMode.callbackOnly.value},
      ),
      isMethodCall(
        'showNoticeWhenForeground',
        arguments: {'mode': ForegroundNoticeMode.showOnly.value},
      ),
      isMethodCall(
        'showNoticeWhenForeground',
        arguments: {'mode': ForegroundNoticeMode.showAndCallback.value},
      ),
      isMethodCall(
        'showNoticeWhenForeground',
        arguments: {'mode': ForegroundNoticeMode.showOnly.value},
      ),
      isMethodCall(
        'showNoticeWhenForeground',
        arguments: {'mode': ForegroundNoticeMode.callbackOnly.value},
      ),
    ]);
  });

  test('rejects a missing device id', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'getDeviceId');
      return null;
    });

    await expectLater(
      platform.getDeviceId(),
      throwsA(
        isA<AliyunPushException>()
            .having(
              (error) => error.code,
              'code',
              kAliyunPushInvalidResponseCode,
            )
            .having((error) => error.operation, 'operation', 'getDeviceId'),
      ),
    );
  });

  test('rejects third-party push initialization outside Android', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    var nativeCallCount = 0;
    messenger.setMockMethodCallHandler(channel, (_) async {
      nativeCallCount += 1;
      return null;
    });

    await expectLater(
      platform.initAndroidThirdPush(),
      throwsA(
        isA<AliyunPushException>()
            .having((error) => error.code, 'code', kAliyunPushOnlyAndroid)
            .having(
              (error) => error.operation,
              'operation',
              'initAndroidThirdPush',
            ),
      ),
    );
    expect(nativeCallCount, 0);
  });

  test('completes commands when the native result succeeds', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call, isMethodCall('bindAccount', arguments: {'account': 'user'}));
      return {'code': kAliyunPushSuccessCode};
    });

    await platform.bindAccount('user');
  });

  test('maps device tag APIs to the existing native channel methods', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      if (call.method == 'listTags') {
        return {
          'code': kAliyunPushSuccessCode,
          'tagsList': 'alpha,beta',
        };
      }
      return {'code': kAliyunPushSuccessCode};
    });

    await platform.bindDeviceTag(['alpha']);
    await platform.unbindDeviceTag(['beta']);
    expect(await platform.listDeviceTags(), ['alpha', 'beta']);

    expect(calls, [
      isMethodCall(
        'bindTag',
        arguments: {
          'tags': ['alpha'],
          'target': kAliyunTargetDevice,
          'alias': null,
        },
      ),
      isMethodCall(
        'unbindTag',
        arguments: {
          'tags': ['beta'],
          'target': kAliyunTargetDevice,
          'alias': null,
        },
      ),
      isMethodCall(
        'listTags',
        arguments: {'target': kAliyunTargetDevice},
      ),
    ]);
  });

  test('throws AliyunPushException when the native result fails', () async {
    messenger.setMockMethodCallHandler(channel, (_) async {
      return {'code': 'PUSH_10107', 'errorMsg': 'network unavailable'};
    });

    await expectLater(
      platform.bindAccount('user'),
      throwsA(
        isA<AliyunPushException>()
            .having((error) => error.code, 'code', 'PUSH_10107')
            .having(
              (error) => error.message,
              'message',
              'network unavailable',
            )
            .having((error) => error.operation, 'operation', 'bindAccount'),
      ),
    );
  });

  test('wraps method channel failures', () async {
    messenger.setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'channel_error', message: 'broken');
    });

    await expectLater(
      platform.bindAccount('user'),
      throwsA(
        isA<AliyunPushException>()
            .having((error) => error.code, 'code', 'channel_error')
            .having((error) => error.message, 'message', 'broken')
            .having((error) => error.cause, 'cause', isA<PlatformException>()),
      ),
    );
  });

  test('normalizes Android comma-separated aliases', () async {
    messenger.setMockMethodCallHandler(channel, (_) async {
      return {
        'code': kAliyunPushSuccessCode,
        'aliasList': 'alpha, beta,,',
      };
    });

    expect(await platform.listAlias(), ['alpha', 'beta']);
  });

  test('normalizes iOS tag arrays', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    messenger.setMockMethodCallHandler(channel, (_) async {
      return {
        'code': kAliyunPushSuccessCode,
        'tagsList': ['alpha', 'beta'],
      };
    });

    expect(await platform.listTags(), ['alpha', 'beta']);
  });

  test('maps Android push channel status to an enum', () async {
    messenger.setMockMethodCallHandler(channel, (_) async {
      return {
        'code': kAliyunPushSuccessCode,
        'status': 'on',
      };
    });

    expect(
      await platform.checkAndroidPushChannelStatus(),
      AliyunPushChannelStatus.enabled,
    );
  });
}
