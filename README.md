# 阿里云移动推送 Flutter 插件

阿里云移动推送 Flutter 插件，集成最新版本Push SDK，采用 Kotlin 和 Swift 分别实现 Android 和 iOS 平台功能。

## 特性
- **多端支持**：支持 Android 和 iOS 平台
- **SDK 版本支持**：兼容阿里云移动推送 SDK 最新版本
- **厂商通道集成**：支持 Android 平台辅助弹窗接入
- **冷启动支持**：完整处理 Android/iOS 冷启动场景下的推送消息
- **通道管理功能**：提供 Android/iOS 平台的推送通道状态查询与开关控制

## 示例

请查看 [example](/example/) 了解如何在项目中集成和使用该插件。

## 注意
在 android / build.gradle 的 allprojects 的 repositories 中添加Maven仓库地址
```
repositories {
    google()
    mavenCentral()

    maven {
        url "https://maven.aliyun.com/nexus/content/repositories/releases/"
    }

    maven {
        url "https://developer.huawei.com/repo/"
    }

    maven {
        url "https://developer.hihonor.com/repo"
    }
}
```

## 1.5.0 API 变更

1.5.0 移除了公开方法中的 `Map<dynamic, dynamic>` 结果协议：命令方法返回
`Future<void>`，查询方法直接返回领域类型，失败统一抛出 `AliyunPushException`。

Android 推送通道接口：

- `Future<AliyunPushChannelStatus> checkAndroidPushChannelStatus()`
- `Future<void> turnOnAndroidPushChannel()`
- `Future<void> turnOffAndroidPushChannel()`

`closeCCPChannel()` 已随阿里云 iOS SDK 3.0.0 废弃并移除。

---

## 一、快速入门

### 1.1 创建应用

EMAS 平台中的应用是您实际端应用的映射，您需要在 EMAS 控制台创建应用，与您要加载 SDK 的端应用进行关联。创建应用请参见[快速入门](https://help.aliyun.com/document_detail/436513.htm?spm=a2c4g.11186623.0.0.78fa671bjAye93#topic-2225340)。

### 1.2 应用配置

Android

- 厂商通道配置：移动推送全面支持接入厂商通道，请参见[配置厂商通道秘钥](https://help.aliyun.com/document_detail/434643.htm?spm=a2c4g.11186623.0.0.78fa671bjAye93#topic-1993457)
- 短信联动配置：移动推送支持与短信联动，通过补充推送短信提升触达效果，请参见[短信联动配置](https://help.aliyun.com/document_detail/434653.htm?spm=a2c4g.11186623.0.0.78fa671bjAye93#topic-1993467)
- 多包名配置：移动推送支持预先针对各渠道添加包名，实现一次推送，全渠道包消息可达。请参见[配置多包名](https://help.aliyun.com/document_detail/434645.htm?spm=a2c4g.11186623.0.0.78fa671bjAye93#topic-2019868)。

iOS

- 证书配置：iOS 应用推送需配置开发环境/生产环境推送证书，详细信息请参见[iOS 配置推送证书指南](https://help.aliyun.com/document_detail/434701.htm?spm=a2c4g.11186623.0.0.78fa4bfcpKinVG#topic-1824039)。

## 二、安装

在`pubspec.yaml`中加入 dependencies

```yaml
dependencies:
  aliyun_push_flutter: latest_version
```

## 三、配置

### 3.1 Android

#### 3.1.1 AndroidManifest 配置

**1. AppKey、AppSecret 配置**

在 Flutter 工程的 android 模块下的`AndroidManifest.xml`文件中设置 AppKey、AppSecret：

```xml
<application android:name="*****">
    <!-- 请填写你自己的- appKey -->
    <meta-data android:name="com.alibaba.app.appkey" android:value="*****"/>
    <!-- 请填写你自己的appSecret -->
    <meta-data android:name="com.alibaba.app.appsecret" android:value="****"/>
</application>
```

`com.alibaba.app.appkey`和`com.alibaba.app.appsecret`为您在 EMAS 平台上的 App 对应信息。在 EMAS 控制台的应用管理中或在下载的配置文件中查看 AppKey 和 AppSecret。

AppKey 和 AppSecret 请务必写在`<application>`标签下，否则 SDK 会报找不到 AppKey 的错误。

**2. 消息接收 Receiver 配置**

将该 receiver 添加到 AndroidManifest.xml 文件中：

```xml
<!-- 接收推送消息 -->
<receiver
    android:name="com.aliyun.ams.push.AliyunPushMessageReceiver"
    android:exported="false"> <!-- 为保证receiver安全，建议设置不可导出，如需对其他应用开放可通过android：permission进行限制 -->
    <intent-filter>
        <action android:name="com.alibaba.push2.action.NOTIFICATION_OPENED" />
    </intent-filter>
    <intent-filter>
        <action android:name="com.alibaba.push2.action.NOTIFICATION_REMOVED" />
    </intent-filter>
    <intent-filter>
        <action android:name="com.alibaba.sdk.android.push.RECEIVE" />
    </intent-filter>
</receiver>

```

**3. 辅助弹窗 Activity 配置**

将辅助弹窗 Activity 添加到 AndroidManifest.xml 文件中：

```xml
<!-- 辅助弹窗Activity -->
<activity
    android:name="com.aliyun.ams.push.PushPopupActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />

        <data
            android:host="${applicationId}"
            android:path="/thirdpush"
            android:scheme="agoo" />
    </intent-filter>
</activity>
```

> **注意：`android:exported=true` 必须配置**

**4. 混淆配置**

如果您的项目中使用 Proguard 等工具做了代码混淆，请保留以下配置：

```txt
-keepclasseswithmembernames class ** {
    native <methods>;
}
-keepattributes Signature
-keep class sun.misc.Unsafe { *; }
-keep class com.taobao.** {*;}
-keep class com.alibaba.** {*;}
-keep class com.alipay.** {*;}
-keep class com.ut.** {*;}
-keep class com.ta.** {*;}
-keep class anet.**{*;}
-keep class anetwork.**{*;}
-keep class org.android.spdy.**{*;}
-keep class org.android.agoo.**{*;}
-keep class android.os.**{*;}
-keep class org.json.**{*;}
-dontwarn com.taobao.**
-dontwarn com.alibaba.**
-dontwarn com.alipay.**
-dontwarn anet.**
-dontwarn org.android.spdy.**
-dontwarn org.android.agoo.**
-dontwarn anetwork.**
-dontwarn com.ut.**
-dontwarn com.ta.**
```

#### 3.1.2 辅助通道集成

在国内 Android 生态中，推送通道都是由终端与云端之间的长链接来维持，非常依赖于应用进程的存活状态。如今一些手机厂家会在自家 ROM 中做系统级别的推送通道，再由系统分发给各个 App，以此提高在自家 ROM 上的推送送达率。

移动推送针对小米、华为、荣耀、vivo、OPPO、魅族、谷歌等设备管控较严的情况，分别接入了相应的设备厂商推送辅助通道以提高这些设备上的到达率。

辅助通道的集成可参考[辅助通道集成](https://help.aliyun.com/document_detail/434677.html)。

在 Flutter 工程的 android 模块下的`AndroidManifest.xml`文件中设置各个辅助通道的配置参数：

```xml
<application android:name="*****">
      <!-- 华为通道的参数appid -->
      <meta-data android:name="com.huawei.hms.client.appid" android:value="appid=xxxxx" />

      <!-- vivo通道的参数api_key为appkey -->
      <meta-data android:name="com.vivo.push.api_key" android:value="" />
      <meta-data android:name="com.vivo.push.app_id" android:value="" />

      <!-- honor通道的参数-->
      <meta-data android:name="com.hihonor.push.app_id" android:value="" />

      <!-- oppo -->
      <meta-data android:name="com.oppo.push.key" android:value="" />
      <meta-data android:name="com.oppo.push.secret" android:value="" />

      <!-- 小米-->
      <meta-data android:name="com.xiaomi.push.id" android:value="" />
      <meta-data android:name="com.xiaomi.push.key" android:value="" />

      <!-- 魅族-->
      <meta-data android:name="com.meizu.push.id" android:value="" />
      <meta-data android:name="com.meizu.push.key" android:value="" />

      <!-- fcm -->
      <meta-data android:name="com.gcm.push.sendid" android:value="" />
      <meta-data android:name="com.gcm.push.applicationid" android:value="" />
      <meta-data android:name="com.gcm.push.projectid" android:value="" />
      <meta-data android:name="com.gcm.push.api.key" android:value="" />
</application>
```

**注意：**

以下 3 个通道配置时需要特殊处理

- 华为通道的`com.huawei.hms.client.appid`参数值的格式是`appid=xxxx`，有个前缀`appid=`
- 小米通道的`com.xiaomi.push.id`和`com.xiaomi.push.key`的值一般都是长数字，如果直接配置原始值，系统读取时会自动判断成 long 类型，但是 AndroidManifest 中的 meta-data 是不支持 long 类型的，这样就会造成插件读取到的值和实际值不一致，进而导致小米通道初始化失败
- fcm 通道的`com.gcm.push.sendid`值也是长数字，同样会导致插件读取时出错

解决办法：

- 配置时在原始值前方加入`id=`，插件会自动解析并读取原始值

```xml
<application android:name="*****">
      <!-- 小米-->
      <meta-data android:name="com.xiaomi.push.id" android:value="id=2222222222222222222" />
      <meta-data android:name="com.xiaomi.push.key" android:value="id=5555555555555" />

      <!-- fcm -->
      <meta-data android:name="com.gcm.push.sendid" android:value="id=999999999999" />
</application>
```

### 3.2 iOS

#### 3.2.1 推送配置

在`ios/Runner/Info.plist`中添加推送权限配置：

```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

#### 3.2.2 Objc 配置

使用 Xcode 打开 Flutter 工程的 iOS 模块，需要做`-Objc`配置，即应用的 TARGETS -> Build Settings -> Linking -> Other Linker Flags ，需添加上 -ObjC 这个属性，否则推送服务无法正常使用 。

Other Linker Flags 中设定链接器参数-ObjC，加载二进制文件时，会将 Objective-C 类和 Category 一并载入 ，若工程依赖多个三方库 ，将所有 Category 一并加载后可能发生冲突，可以使用 -force_load 单独载入指定二进制文件，配置如下 ：

```c++
-force_load<framework_path>/CloudPushSDK.framework/CloudPushSDK
```

## 四、APIs

### 返回值与错误处理

1.5.0 起不再向调用方暴露原生 `code/errorMsg/data` Map：

- 只表示操作完成的方法返回 `Future<void>`。
- 查询方法直接返回 `Future<String>`、`Future<bool>`、`Future<List<String>>` 或领域枚举。
- 原生 SDK 失败、不支持的平台、无效的原生响应和 MethodChannel 异常统一抛出 `AliyunPushException`。

```dart
try {
  await aliyunPush.bindAccount("account");
  final tags = await aliyunPush.listDeviceTags();
  print(tags);
} on AliyunPushException catch (error) {
  print("${error.operation}: ${error.code} - ${error.message}");
}
```

`AliyunPushException` 包含：

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| `code` | `String` | 插件、原生 SDK 或平台通道错误码 |
| `message` | `String` | 错误信息 |
| `operation` | `String` | 失败的插件 API 名称 |
| `cause` | `Object?` | 可选的底层异常 |

### 通用 API

| 方法 | 返回类型 | 说明 |
| --- | --- | --- |
| `initPush({appKey, appSecret})` | `Future<void>` | 初始化推送；Android 的密钥从 AndroidManifest 读取 |
| `getDeviceId()` | `Future<String>` | 获取非空设备 ID |
| `bindAccount(account)` | `Future<void>` | 绑定账号 |
| `unbindAccount()` | `Future<void>` | 解绑账号 |
| `addAlias(alias)` | `Future<void>` | 添加别名 |
| `removeAlias(alias)` | `Future<void>` | 移除别名 |
| `listAlias()` | `Future<List<String>>` | 查询别名列表 |
| `bindDeviceTag(tags)` | `Future<void>` | 绑定设备标签 |
| `unbindDeviceTag(tags)` | `Future<void>` | 解绑设备标签 |
| `listDeviceTags()` | `Future<List<String>>` | 查询设备标签列表 |
| `bindTag(tags, {target, alias})` | `Future<void>` | 已废弃，请使用 `bindDeviceTag` |
| `unbindTag(tags, {target, alias})` | `Future<void>` | 已废弃，请使用 `unbindDeviceTag` |
| `listTags({target})` | `Future<List<String>>` | 已废弃，请使用 `listDeviceTags` |

`listAlias()` 和 `listDeviceTags()` 会将 Android 返回的逗号分隔字符串与 iOS 返回的数组统一为不可变的 `List<String>`。

账号和别名维度的标签操作不再建议使用。`bindTag`、`unbindTag`、`listTags` 以及
`kAliyunTargetAccount`、`kAliyunTargetAlias` 暂时保留用于兼容现有应用，后续版本可能移除。

### Android API

以下方法仅支持 Android；在其他平台调用会抛出错误码为 `10003` 的 `AliyunPushException`。

| 方法 | 返回类型 | 说明 |
| --- | --- | --- |
| `initAndroidThirdPush()` | `Future<void>` | 初始化辅助通道 |
| `closeAndroidPushLog()` | `Future<void>` | 关闭推送 SDK 日志 |
| `setAndroidLogLevel(level)` | `Future<void>` | 设置日志等级 |
| `bindPhoneNumber(phone)` | `Future<void>` | 绑定手机号 |
| `unbindPhoneNumber()` | `Future<void>` | 解绑手机号 |
| `setNotificationInGroup(inGroup)` | `Future<void>` | 设置通知分组展示 |
| `clearNotifications()` | `Future<void>` | 清除所有通知 |
| `createAndroidChannel(...)` | `Future<void>` | 创建 NotificationChannel |
| `createAndroidChannelGroup(id, name, desc)` | `Future<void>` | 创建通知通道分组 |
| `isAndroidNotificationEnabled({id})` | `Future<bool>` | 查询应用或指定通道的通知状态 |
| `jumpToAndroidNotificationSettings({id})` | `Future<void>` | 打开应用或指定通道的通知设置 |
| `setAndroidBadgeNum(num)` | `Future<void>` | 设置数字角标；仅华为、荣耀、vivo 厂商通道生效 |
| `checkAndroidPushChannelStatus()` | `Future<AliyunPushChannelStatus>` | 查询推送通道状态 |
| `turnOnAndroidPushChannel()` | `Future<void>` | 开启推送通道 |
| `turnOffAndroidPushChannel()` | `Future<void>` | 关闭推送通道 |

Android 日志等级常量：

| Level | 常量 | Int |
| --- | --- | --- |
| Error | `kAliyunPushAndroidLogLevelError` | 0 |
| Info | `kAliyunPushAndroidLogLevelInfo` | 1 |
| Debug | `kAliyunPushAndroidLogLevelDebug` | 2 |

`AliyunPushChannelStatus` 包含 `enabled` 和 `disabled`。

### iOS API

以下方法仅支持 iOS；在其他平台调用会抛出错误码为 `10004` 的 `AliyunPushException`。

| 方法 | 返回类型 | 说明 |
| --- | --- | --- |
| `setIOSLogLevel(level)` | `Future<void>` | 设置日志等级 |
| `showIOSNoticeWhenForeground(enable)` | `Future<void>` | 设置前台是否显示通知 |
| `setIOSBadgeNum(num)` | `Future<void>` | 设置本地角标数 |
| `syncIOSBadgeNum(num)` | `Future<void>` | 同步角标数到服务端 |
| `getApnsDeviceToken()` | `Future<String>` | 获取非空 APNs Token |
| `isIOSChannelOpened()` | `Future<bool>` | 查询通知通道是否开启 |
| `turnOnIOSDebug()` | `Future<void>` | 已废弃，请使用 `setIOSLogLevel(4)` |

iOS 日志等级常量：

| Level | 常量 | Int |
| --- | --- | --- |
| None | `kAliyunPushIOSLogLevelNone` | 0 |
| Error | `kAliyunPushIOSLogLevelError` | 1 |
| Warn | `kAliyunPushIOSLogLevelWarn` | 2 |
| Info | `kAliyunPushIOSLogLevelInfo` | 3 |
| Debug | `kAliyunPushIOSLogLevelDebug` | 4 |

### 插件日志与消息回调

- `Future<void> setPluginLogEnabled(bool enabled)`：设置插件日志开关。
- `void addMessageReceiver(...)`：注册消息回调；再次调用会替换此前注册的全部回调。

Android 通知回调中的 `extraMap` 始终为 `Map<String, dynamic>`。点击回调中的 JSON 字符串会自动解析；解析失败时 `extraMap` 为空 Map，原始字符串保存在 `extraMapRaw`。iOS 回调仍返回 APNs 原始 `userInfo`。

### 从 1.4.0 迁移

命令方法不再检查成功码：

```dart
// 1.4.0
final result = await aliyunPush.bindAccount("account");
if (result["code"] == kAliyunPushSuccessCode) {
  // success
}

// 1.5.0
await aliyunPush.bindAccount("account");
```

查询方法直接返回数据：

```dart
// 1.4.0
final result = await aliyunPush.listTags();
final tags = result["tagsList"];

// 1.5.0
final tags = await aliyunPush.listDeviceTags();
```

需要处理失败时捕获 `AliyunPushException`，不再读取 `errorMsg`。

## 五、错误码

| 名称                     | 值      | 含义                                                            |
| ------------------------ | ------- | --------------------------------------------------------------- |
| kAliyunPushSuccessCode   | "10000" | 成功                                                            |
| kAliyunPushParamsIllegal | "10001" | 参数错误                                                        |
| kAliyunPushFailedCode    | "10002" | 通用失败码                                                      |
| kAliyunPushOnlyAndroid   | "10003" | 方法只支持 Android 平台                                         |
| kAliyunPushOnlyIOS       | "10004" | 方法只支持 iOS 平台                                             |
| kAliyunPushNotSupport    | "10005" | 平台不支持，比如 Android 创建 group 只支持 Android 8.0 以上版本 |
| kAliyunPushMissingPluginCode | "missing_plugin" | MethodChannel 未找到平台实现 |
| kAliyunPushInvalidResponseCode | "invalid_response" | 原生平台返回的数据不符合插件协议 |
