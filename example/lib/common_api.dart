import 'package:aliyun_push_flutter/aliyun_push_flutter.dart';
import 'package:flutter/material.dart';

import 'base_state.dart';
import 'common_widget.dart';

class CommonApiPage extends StatefulWidget {
  const CommonApiPage({super.key});

  @override
  State<CommonApiPage> createState() => _CommonApiPageState();
}

class _CommonApiPageState extends BaseState<CommonApiPage> {
  final _aliyunPush = AliyunPushFlutter();

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _addAliasController = TextEditingController();
  final TextEditingController _removeAliasController = TextEditingController();
  final TextEditingController _addTagController = TextEditingController();
  final TextEditingController _removeTagController = TextEditingController();
  final TextEditingController _addAccountTagCtr = TextEditingController();
  final TextEditingController _removeAccountTagCtr = TextEditingController();

  String _boundAccount = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account/Alias/Tag')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            _accountBuilder(),
            _aliasBuilder(),
            _deviceBuilder(),
            _accountTagBuilder(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _accountController.dispose();
    _addAliasController.dispose();
    _removeAliasController.dispose();
    _addTagController.dispose();
    _removeTagController.dispose();
    _addAccountTagCtr.dispose();
    _removeAccountTagCtr.dispose();
  }

  Widget _accountBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('账号绑定/解绑'));
    children.add(const SizedBox(height: 20));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: "绑定账号",
        hintText: "绑定账号",
      ),
      controller: _accountController,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var account = _accountController.text;
        if (account.isNotEmpty) {
          try {
            await _aliyunPush.bindAccount(account);
            showOkDialog('绑定账号$account成功');
            setState(() {
              _boundAccount = account;
            });
            _accountController.clear();
          } on AliyunPushException catch (error) {
            showErrorDialog('绑定账号失败: ${error.code} - ${error.message}');
          }
        } else {
          showWarningDialog('请输入要绑定的账号');
        }
      },
      child: const Text('绑定账号'),
    ));

    if (_boundAccount.isNotEmpty) {
      children.add(Text('已绑定账号: $_boundAccount'));
    }

    children.add(FilledButton(
      onPressed: () async {
        try {
          await _aliyunPush.unbindAccount();
          showOkDialog('解绑账号成功');
          setState(() {
            _boundAccount = "";
          });
          _accountController.clear();
        } on AliyunPushException catch (error) {
          showErrorDialog('解绑账号失败: ${error.code} - ${error.message}');
        }
      },
      child: const Text('解绑账号'),
    ));

    return cardBuilder(Column(children: children));
  }

  Widget _accountTagBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('账号标签添加/删除'));
    children.add(const SizedBox(height: 20));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: '添加账号标签',
        hintText: '添加账号标签',
      ),
      controller: _addAccountTagCtr,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var tag = _addAccountTagCtr.text;
        if (tag.isNotEmpty) {
          List<String> tags = [];
          tags.add(tag);

          try {
            await _aliyunPush.bindTag(
              tags,
              target: kAliyunTargetAccount,
            );
            showOkDialog('添加账号标签$tag成功');
            _addAccountTagCtr.clear();
          } on AliyunPushException catch (error) {
            showErrorDialog(
              '添加账号标签$tag失败: ${error.code} - ${error.message}',
            );
          }
        } else {
          showWarningDialog('请输入要添加的账号标签');
        }
      },
      child: const Text('添加账号标签'),
    ));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: '删除账号标签',
        hintText: '删除账号标签',
      ),
      controller: _removeAccountTagCtr,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var tag = _removeAccountTagCtr.text;
        if (tag.isNotEmpty) {
          List<String> tags = [];
          tags.add(tag);

          try {
            await _aliyunPush.unbindTag(
              tags,
              target: kAliyunTargetAccount,
            );
            showOkDialog('删除账号标签$tag成功');
            _removeAccountTagCtr.clear();
          } on AliyunPushException catch (error) {
            showErrorDialog(
              '删除账号标签$tag失败: ${error.code} - ${error.message}',
            );
          }
        } else {
          showWarningDialog('请输入要删除的账号标签');
        }
      },
      child: const Text('删除账号标签'),
    ));

    return cardBuilder(Column(children: children));
  }

  Widget _aliasBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('别名添加/删除/查询'));
    children.add(const SizedBox(height: 20));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: '添加别名',
        hintText: '添加别名',
      ),
      controller: _addAliasController,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var alias = _addAliasController.text;
        if (alias.isNotEmpty) {
          try {
            await _aliyunPush.addAlias(alias);
            showOkDialog('添加别名$alias成功');
            _addAliasController.clear();
          } on AliyunPushException catch (error) {
            showErrorDialog(
              '添加别名$alias失败: ${error.code} - ${error.message}',
            );
          }
        } else {
          showWarningDialog('请输入要添加的别名');
        }
      },
      child: const Text('添加别名'),
    ));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: '删除别名',
        hintText: '删除别名',
      ),
      controller: _removeAliasController,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var alias = _removeAliasController.text;
        if (alias.isNotEmpty) {
          try {
            await _aliyunPush.removeAlias(alias);
            showOkDialog('删除别名$alias成功');
            _removeAliasController.clear();
          } on AliyunPushException catch (error) {
            showErrorDialog(
              '删除别名$alias失败: ${error.code} - ${error.message}',
            );
          }
        } else {
          showWarningDialog('请输入要删除的别名');
        }
      },
      child: const Text('删除别名'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        try {
          var aliasList = await _aliyunPush.listAlias();
          showOkDialog('查询别名列表成功: $aliasList');
        } on AliyunPushException catch (error) {
          showErrorDialog(
            '查询别名列表失败: ${error.code} - ${error.message}',
          );
        }
      },
      child: const Text('查询别名'),
    ));

    return cardBuilder(Column(children: children));
  }

  Widget _deviceBuilder() {
    final List<Widget> children = [];

    children.add(titleBuilder('设备标签添加/删除/查询'));
    children.add(const SizedBox(height: 20));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: '添加设备标签',
        hintText: '添加设备标签',
      ),
      controller: _addTagController,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var tag = _addTagController.text;
        if (tag.isNotEmpty) {
          List<String> tags = [];
          tags.add(tag);

          try {
            await _aliyunPush.bindTag(
              tags,
              target: kAliyunTargetDevice,
            );
            showOkDialog('添加设备标签$tag成功');
            _addTagController.clear();
          } on AliyunPushException catch (error) {
            showErrorDialog(
              '添加设备标签$tag失败: ${error.code} - ${error.message}',
            );
          }
        } else {
          showWarningDialog('请输入要添加的标签');
        }
      },
      child: const Text('添加设备标签'),
    ));

    children.add(TextField(
      autofocus: false,
      decoration: const InputDecoration(
        labelText: '删除设备标签',
        hintText: '删除设备标签',
      ),
      controller: _removeTagController,
    ));

    children.add(FilledButton(
      onPressed: () async {
        var tag = _removeTagController.text;
        if (tag.isNotEmpty) {
          List<String> tags = [];
          tags.add(tag);

          try {
            await _aliyunPush.unbindTag(
              tags,
              target: kAliyunTargetDevice,
            );
            showOkDialog('删除设备标签$tag成功');
            _removeTagController.clear();
          } on AliyunPushException catch (error) {
            showErrorDialog(
              '删除设备标签$tag失败: ${error.code} - ${error.message}',
            );
          }
        } else {
          showWarningDialog('请输入要删除的设备标签');
        }
      },
      child: const Text('删除设备标签'),
    ));

    children.add(FilledButton(
      onPressed: () async {
        try {
          var tagList = await _aliyunPush.listTags(target: kAliyunTargetDevice);
          showOkDialog('查询设备标签列表成功: $tagList');
        } on AliyunPushException catch (error) {
          showErrorDialog(
            '查询设备标签列表失败: ${error.code} - ${error.message}',
          );
        }
      },
      child: const Text('查询设备标签'),
    ));

    return cardBuilder(Column(children: children));
  }
}
