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

    platform.setPluginLogEnabled(true);

    expect(
      await nativeCall.future,
      isMethodCall(
        'setPluginLogEnabled',
        arguments: {'enabled': true},
      ),
    );
  });

  test('returns an empty device id when the platform returns null', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'getDeviceId');
      return null;
    });

    expect(await platform.getDeviceId(), isEmpty);
  });

  test('rejects third-party push initialization outside Android', () async {
    var nativeCallCount = 0;
    messenger.setMockMethodCallHandler(channel, (_) async {
      nativeCallCount += 1;
      return null;
    });

    final result = await platform.initAndroidThirdPush();

    expect(result, {
      'code': kAliyunPushOnlyAndroid,
      'errorMsg': 'Only support Android',
    });
    expect(nativeCallCount, 0);
  });
}
