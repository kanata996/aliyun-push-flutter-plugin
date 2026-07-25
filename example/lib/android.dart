import 'package:aliyun_push_flutter/aliyun_push_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'base_state.dart';
import 'common_widget.dart';

class AndroidPage extends StatefulWidget {
  const AndroidPage({super.key});

  @override
  State<AndroidPage> createState() => _AndroidPageState();
}

class _AndroidPageState extends BaseState<AndroidPage> {
  final _aliyunPush = AliyunPushFlutter();

  final TextEditingController _addPhoneController = TextEditingController();
  final TextEditingController _badgeController = TextEditingController();
  final TextEditingController _channelController = TextEditingController();

  String _boundPhone = "";

  final List<String> _logLevelList = ['ERROR', 'INFO', 'DEBUG'];
  String? _selectedLogLevel = "DEBUG";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Android平台方法')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            _setLogBuilder(),
            _bindPhoneBuilder(),
            _setNotificationBuilder(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _addPhoneController.dispose();
    _badgeController.dispose();
    _channelController.dispose();
  }

  Widget _bindPhoneBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('手机号码绑定/解绑'));
    children.add(const SizedBox(height: 20));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: '绑定手机号码',
        hintText: '绑定手机号码',
      ),
      controller: _addPhoneController,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var phone = _addPhoneController.text;
        if (phone.isNotEmpty) {
          try {
            await _aliyunPush.bindPhoneNumber(phone);
            setState(() {
              _boundPhone = phone;
            });
            _addPhoneController.clear();
            showOkDialog('绑定手机号码$phone成功');
          } on AliyunPushException catch (error) {
            showErrorDialog(
              '绑定手机号码$phone失败: ${error.code} - ${error.message}',
            );
          }
        } else {
          showWarningDialog('请输入要绑定的手机号码');
        }
      },
      child: const Text('绑定手机号码'),
    ));

    if (_boundPhone.isNotEmpty) {
      children.add(Text('已绑定手机号码: $_boundPhone'));
    }

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.unbindPhoneNumber();
          setState(() {
            _boundPhone = "";
          });
          showOkDialog('解绑手机号码成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('解绑手机号码失败: ${error.code} - ${error.message}');
        }
      },
      child: const Text('解绑手机号码'),
    ));

    return cardBuilder(Column(children: children));
  }

  Widget _setLogBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('通知日志设置'));
    children.add(const SizedBox(height: 20));

    children.add(const SizedBox(height: 10));

    children.add(Material(
      color: Colors.grey.shade300,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: const Text('选择LogLevel'),
          items: _logLevelList
              .map((item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
          value: _selectedLogLevel,
          onChanged: (value) {
            setState(() {
              _selectedLogLevel = value as String;
            });
          },
        ),
      ),
    ));

    children.add(const SizedBox(height: 10));

    children.add(FilledButton(
      onPressed: () async {
        int logLevel;
        if (_selectedLogLevel == 'ERROR') {
          logLevel = kAliyunPushAndroidLogLevelError;
        } else if (_selectedLogLevel == 'INFO') {
          logLevel = kAliyunPushAndroidLogLevelInfo;
        } else {
          logLevel = kAliyunPushAndroidLogLevelDebug;
        }

        try {
          await _aliyunPush.setAndroidLogLevel(logLevel);
          showOkDialog('设置LogLevel $_selectedLogLevel 成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('设置LogLevel失败: ${error.code} - ${error.message}');
        }
      },
      child: Text('设置Log Level为 $_selectedLogLevel'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.closeAndroidPushLog();
          showOkDialog('关闭 Push Log 成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('关闭 Push Log 失败: ${error.message}');
        }
      },
      child: const Text('关闭 Push Log'),
    ));

    return cardBuilder(Column(children: children));
  }

  Widget _setNotificationBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('通知设置'));
    children.add(const SizedBox(height: 20));

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.setNotificationInGroup(true);
          showOkDialog('开启通知分组展示成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('开启通知分组展示失败: ${error.message}');
        }
      },
      child: const Text('开启通知分组展示'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.setNotificationInGroup(false);
          showOkDialog('关闭通知分组展示成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('关闭通知分组展示失败: ${error.message}');
        }
      },
      child: const Text('关闭通知分组展示'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.clearNotifications();
          showOkDialog('清除所有通知成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('清除所有通知失败: ${error.message}');
        }
      },
      child: const Text('清除所有通知'),
    ));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: "角标数量",
        hintText: "输入非负整数，0 表示清除角标",
      ),
      controller: _badgeController,
      keyboardType: TextInputType.number,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var badge = int.tryParse(_badgeController.text);
        if (badge == null || badge < 0) {
          showWarningDialog('请输入非负整数角标数量');
          return;
        }

        try {
          await _aliyunPush.setAndroidBadgeNum(badge);
          showOkDialog('设置角标数量 $badge 成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('设置角标失败: ${error.code} - ${error.message}');
        }
      },
      child: const Text('设置角标数量'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.setAndroidBadgeNum(0);
          _badgeController.text = '0';
          showOkDialog('清除角标成功');
        } on AliyunPushException catch (error) {
          showErrorDialog('清除角标失败: ${error.code} - ${error.message}');
        }
      },
      child: const Text('清除角标'),
    ));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: "通道名称",
        hintText: "通道名称",
      ),
      controller: _channelController,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var channel = _channelController.text;

        if (channel.isNotEmpty) {
          try {
            await _aliyunPush.createAndroidChannel(
              channel,
              '测试通道A',
              3,
              '测试创建通知通道',
            );
            showOkDialog('创建$channel通道成功');
          } on AliyunPushException catch (error) {
            showErrorDialog(
              '创建$channel通道失败, ${error.code} - ${error.message}',
            );
          }
        } else {
          showWarningDialog('通道名称不能为空');
        }
      },
      child: const Text('创建通知通道'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        bool isEnabled = await _aliyunPush.isAndroidNotificationEnabled();
        showOkDialog('通知状态: $isEnabled');
      },
      child: const Text('检查通知状态'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        var channel = _channelController.text;
        if (channel.isNotEmpty) {
          bool isEnabled =
              await _aliyunPush.isAndroidNotificationEnabled(id: channel);
          showOkDialog('通知状态: $isEnabled');
        } else {
          showWarningDialog('填写通道名称');
        }
      },
      child: const Text('检查通知通道状态'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        await _aliyunPush.jumpToAndroidNotificationSettings();
      },
      child: const Text('跳转通知设置界面'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        var channel = _channelController.text;
        await _aliyunPush.jumpToAndroidNotificationSettings(id: channel);
      },
      child: const Text('跳转通知通道设置界面'),
    ));

    return cardBuilder(Column(children: children));
  }
}
