import 'package:flutter/material.dart';
import 'package:aliyun_push_flutter/aliyun_push_flutter.dart';

import 'base_state.dart';
import 'common_widget.dart';

class IOSPage extends StatefulWidget {
  const IOSPage({super.key});

  @override
  State<IOSPage> createState() => _IOSPageState();
}

class _IOSPageState extends BaseState<IOSPage> {
  final _aliyunPush = AliyunPushFlutter();

  final TextEditingController _badgeController = TextEditingController();

  String _apnsToken = "";

  @override
  void dispose() {
    super.dispose();

    _badgeController.dispose();
  }

  Widget _setDebugLogBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('通知日志设置'));
    children.add(const SizedBox(height: 20));

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.setIOSLogLevel(4);
          showOkDialog('打开Debug日志成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('打开Debug日志失败: ${error.message}');
        }
      },
      child: const Text('打开debug日志'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        var result = await _aliyunPush.getApnsDeviceToken();
        setState(() {
          _apnsToken = result;
        });
      },
      child: const Text('查询ApnsToken'),
    ));

    if (_apnsToken.isNotEmpty) {
      children.add(Text('ApnsToken: $_apnsToken'));
    }

    children.add(FilledButton(
      onPressed: () async {
        var opened = await _aliyunPush.isIOSChannelOpened();
        if (opened) {
          showOkDialog('通知通道已打开');
        } else {
          showErrorDialog('通知通道未打开');
        }
      },
      child: const Text('通知通道是否已打开'),
    ));

    return cardBuilder(Column(children: children));
  }

  Widget _setNoticeWhenForegroundBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('设置前台通知处理模式'));
    children.add(const SizedBox(height: 20));

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.setIOSForegroundNoticeMode(
            ForegroundNoticeMode.callbackOnly,
          );
          showOkDialog('设置前台仅回调成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('设置前台仅回调失败: ${error.message}');
        }
      },
      child: const Text('仅回调，不展示通知'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.setIOSForegroundNoticeMode(
            ForegroundNoticeMode.showOnly,
          );
          showOkDialog('设置前台仅展示成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('设置前台仅展示失败: ${error.message}');
        }
      },
      child: const Text('仅展示通知，不回调'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.setIOSForegroundNoticeMode(
            ForegroundNoticeMode.showAndCallback,
          );
          showOkDialog('设置前台展示且回调成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('设置前台展示且回调失败: ${error.message}');
        }
      },
      child: const Text('展示通知且回调'),
    ));

    return cardBuilder(Column(children: children));
  }

  Widget _setBadgeBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('设置角标'));
    children.add(const SizedBox(height: 20));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: '角标数量',
        hintText: '角标数量',
      ),
      controller: _badgeController,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var badge = _badgeController.text;

        if (badge.isNotEmpty) {
          int badgeNum = int.parse(badge);
          try {
            await _aliyunPush.setIOSBadgeNum(badgeNum);
            showOkDialog('设置角标数量$badgeNum成功');
          } on AliyunPushException catch (error) {
            showErrorDialog('设置角标失败: ${error.message}');
          }
        } else {
          showWarningDialog('请填写角标数量');
        }
      },
      child: const Text('设置角标数量'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        var badge = _badgeController.text;

        if (badge.isNotEmpty) {
          int badgeNum = int.parse(badge);
          try {
            await _aliyunPush.syncIOSBadgeNum(badgeNum);
            showOkDialog('同步角标数量$badgeNum成功');
          } on AliyunPushException catch (error) {
            showErrorDialog('同步角标失败: ${error.message}');
          }
        } else {
          showWarningDialog('请填写角标数量');
        }
      },
      child: const Text('同步角标数量'),
    ));

    return cardBuilder(Column(children: children));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('iOS平台方法')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            _setDebugLogBuilder(),
            _setNoticeWhenForegroundBuilder(),
            _setBadgeBuilder(),
          ],
        ),
      ),
    );
  }
}
