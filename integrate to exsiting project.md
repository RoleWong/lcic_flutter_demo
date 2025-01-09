腾讯云实时互动-教育版 SDK 并未直接提供 Flutter SDK, 本文档旨在介绍如何在 Flutter 项目中接入 Native LCIC SDK。通过实现一个 Dart 层与原生端通信，并在 iOS 和 Android 原生端配置选项，实现在 Flutter 项目中使用腾讯云实时互动-教育版。

因此, 本文档中, 大部分代码, 都需要在 Flutter 项目的 iOS 及 Android 壳工程中完成. 如您对原生开发不熟悉, 可参考我们提供的 [**Flutter 接入 SDK Demo 源码**](https://github.com/RoleWong/lcic_flutter_demo), 对照阅读使用.

## 环境要求



【Android】
- Android studio 3.0+

- Android 6.0（23）及以上系统


【iOS】

Xcode 14

## 操作步骤

### 步骤一：创建新的应用
1. 登录 [实时互动-教育版 控制台](https://console.cloud.tencent.com/lcic)，左侧导航栏选择**快速跑通应用**。

2. 默认进入“创建应用”界面，应用类型可选择“**创建新应用**”，输入应用名称，例如 TestLCIC。


若您已创建应用，应用类型项可单击“选择已有应用”。


> **说明：**
>

> 移动端需要购买旗舰版或企业尊享版后，方可接入移动端。若需创建商用应用，可根据业务需求在[ 购买页](https://buy.cloud.tencent.com/lcic) 创建对应版本的应用。
>

3. 根据实际业务需求添加或编辑标签 ，单击**下一步**。


![](https://write-document-release-1258344699.cos.ap-guangzhou.tencentcos.cn/100027812451/dad8c2abcd9a11ef9d3a5254001c06ec.png)


> **说明：**
>
>   - 应用名称只允许下划线、数字或中英文字符。
>   - 标签用于标识和组织您在腾讯云的各种资源。例如：企业可能有多个业务部门，每个部门有一个或多个 LCIC 应用，这时，企业可以通过给 LCIC 应用添加标签来标记部门信息。标签并非必选项，您可根据实际业务需求添加或编辑。


### 步骤二：获取 SDKAppId 和密钥(SecretKey)
1. 进入**应用管理 > 应用配置**，获取 [SDKAppId](https://console.cloud.tencent.com/lcic/app) 。

2. 进入 [访问管理(CAM)控制台](https://console.cloud.tencent.com/cam/capi) 获取密钥，若无密钥，需要在 API 密钥管理中进行新建，具体可参考 [访问密钥管理](https://cloud.tencent.com/document/product/598/40488) 。


![](https://write-document-release-1258344699.cos.ap-guangzhou.tencentcos.cn/100027812451/dadb2828cd9a11efb1a552540099c741.png)


### 步骤三：安装依赖

首先, 在 Flutter 项目根目录, 执行 `flutter pub get`

本步骤后续需在 Native 层实现, 如不清楚 Native 端代码如何编写, 可参考我们的 [**Demo 源码**](https://github.com/RoleWong/lcic_flutter_demo).



【iOS】

建议 iOS 壳工程使用 Objective-C 语言编写实现. 如非 Objective-C, 可手动删除 `ios` 目录, 并在项目根目录执行 `flutter create -i objc .` 创建  Objective-C 语言的 iOS 壳工程. 如不方便, 必须使用 swift 语言壳工程, 可自行写桥接头文件, 转换引入.

打开 `ios/Podfile` 文件, 加入如下两个依赖.
``` plaintext
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  pod 'TCICSDK_Pro', '1.8.5.6' // 新增此依赖
  pod 'TXLiteAVSDK_Professional', '12.1.16597'  // 新增此依赖

  target 'RunnerTests' do
    inherit! :search_paths
  end
end
```

并在 `ios` 目录下, 执行如下命令, 安装依赖.
``` bash
pod install --repo-update
```

【Android】

打开 `android/app/build.gradle` 文件, 在文件末尾, 增加 SDK 引入.
``` plaintext
dependencies {
    implementation 'com.tencent.edu:TCICSDK:1.8.10'
}
```

### 步骤四：Native 端环境配置

本步骤需在 Native 层实现, 如不清楚 Native 端代码如何编写, 可参考我们的 [**Demo 源码**](https://github.com/RoleWong/lcic_flutter_demo).


【iOS】

**配置 App 权限**

在 `ios/Runner/Info.plist` 文件中，添加以下权限声明. 文案提示内容可根据需要改写.
``` plaintext
<key>NSCameraUsageDescription</key>
<string>需要访问摄像头以加入课堂</string>
<key>NSMicrophoneUsageDescription</key>
<string>需要访问麦克风以进行语音交流</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>需要访问相册以保存课堂相关内容</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册以上传课堂资源</string>
```

【Android】

**配置 App 权限**

打开 `android/app/src/main/AndroidManifest.xml` 文件, 在末尾的 </manifest> 标签上一行, 添加所需的权限：
``` xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

```

并在 `<application>` 标签中添加：
``` xml
android:extractNativeLibs="true"
```

**指定 App 架构**

在 `android/app/build.gradle` 文件中部的 android => defaultConfig 中，指定 App 使用的 CPU 架构。
``` plaintext
defaultConfig {
    ndk{
        abiFilters "armeabi-v7a","arm64-v8a"
    }
}
```

> **说明：**
>

> 目前 LCIC SDK 支持 armeabi-v7a 和 arm64-v8a，能够根据业务需求进行灵活配置。因此, **不支持在 Windows 系统安卓模拟器中运行**. 请保证运行的环境为 arm 架构.
>


### 步骤五：原生层完成进入课堂等代码实现

本步骤监听后续编写的来自 Dart 层的 MethodChannel 事件调用, 并调用 Native SDK 对应方法完成功能. 如不清楚 Native 端代码如何编写, 可参考我们的 [**Demo 源码**](https://github.com/RoleWong/lcic_flutter_demo).



【iOS】

在 `ios/Runner/AppDelegate.m` 中，配置 Flutter 与 LCIC SDK 之间的通信。
``` objectivec
#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <TCICSDK/TCICClassConfig.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* flutterViewController = (FlutterViewController*)self.window.rootViewController;
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:flutterViewController];
    self.window.rootViewController = navigationController;

    FlutterMethodChannel* methodChannel = [FlutterMethodChannel
                                           methodChannelWithName:@"lcic_sdk"
                                           binaryMessenger:flutterViewController.binaryMessenger];

    [methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if (["joinClass" isEqualToString:call.method]) {
            NSDictionary *args = call.arguments;
            [self joinClassWithArgs:args result:result];
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];

    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)joinClassWithArgs:(NSDictionary *)args result:(FlutterResult)result {
    NSNumber *schoolId = args[@"schoolId"];
    NSString *userId = args[@"userId"];
    NSString *token = args[@"token"];
    NSNumber *classId = args[@"classId"];

    if (!schoolId || !userId || !token || !classId) {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"\u7f3a\u5c11\u5fc5\u8981\u53c2\u6570"
                                   details:nil]);
        return;
    }

    TCICClassConfig *roomConfig = [[TCICClassConfig alloc] init];
    roomConfig.schoolId = [schoolId intValue];
    roomConfig.userId = userId;
    roomConfig.token = token;
    roomConfig.classId = [classId longValue];

    if (args[@"language"]) {
        [roomConfig setValue:args[@"language"] forKey:@"language"];
    }
    if (args[@"scene"]) {
        [roomConfig setValue:args[@"scene"] forKey:@"scene"];
    }
    if (args[@"preferPortrait"]) {
        [roomConfig setValue:args[@"preferPortrait"] forKey:@"preferPortrait"];
    }

    TCICClassController *vc = [TCICClassController classRoomWithConfig:roomConfig];
    if (vc) {
        [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
        result(@"\u8fdb\u5165\u8bfe\u5802\u6210\u529f");
    } else {
        result([FlutterError errorWithCode:@"INVALID_PARAMETERS"
                                   message:@"\u53c2\u6570\u9519\u8bef\uff0c\u65e0\u6cd5\u8fdb\u5165\u8bfe\u5802"
                                   details:nil]);
    }
}
@end
```

【Android】

在 android 目录下, 对应包名的目录结构最底部的 `MainActivity.java` 中，配置 Flutter 与 LCIC SDK 之间的通信。

本文以 Java 为例, 如您项目采用 kotlin 语言, 请将下述代码转成 kotlin 语言使用.
``` java
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.tencent.tcic.TBSSdkManageCallback;
import com.tencent.tcic.TCICClassConfig;
import com.tencent.tcic.TCICConstants;
import com.tencent.tcic.TCICManager;
import com.tencent.tcic.pages.TCICClassActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "lcic_sdk";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("initX5Core")) {
                        String licenseKey = call.argument("licenseKey");
                        initX5Core(licenseKey, result);
                    } else if (call.method.equals("joinClass")) {
                        int schoolId = call.argument("schoolId");
                        int classId = call.argument("classId");
                        String userId = call.argument("userId");
                        String token = call.argument("token");
                        joinClass(schoolId, classId, userId, token, result);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private void initX5Core(String licenseKey, MethodChannel.Result result) {
        TCICManager.getInstance().initX5Core(licenseKey, new TBSSdkManageCallback() {
            @Override
            public void onCoreInitFinished() {}

            @Override
            public void onViewInitFinished(boolean isX5Core) {
                if (isX5Core) {
                    result.success("INIT_SUCCEED"); // X5 内核初始化成功
                } else {
                    result.error("INIT_FAILED", "X5 kernel initialization failed", null);
                }
            }
        });
    }

    private void joinClass(int schoolId, int classId, String userId, String token, MethodChannel.Result result) {
        Intent intent = new Intent(this, TCICClassActivity.class);
        Bundle bundle = new Bundle();
        TCICClassConfig initConfig = new TCICClassConfig.Builder()
                .schoolId(schoolId)
                .classId(classId)
                .userId(userId)
                .token(token)
                .build();
        bundle.putParcelable(TCICConstants.KEY_INIT_CONFIG, initConfig);
        intent.putExtras(bundle);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intent);
        result.success(null); // 加入课堂成功
    }
}
```

### 步骤六：Dart 层实现 `MethodChannel`

在 Flutter 项目中，传递参数到原生端并调用 LCIC SDK 的功能。在您的 Flutter 项目中, 新建一个名为 lcic_sdk.dart 的文件, 内容可以如下:
``` java
import 'dart:io';
import 'package:flutter/services.dart';

class LCICSDK {
  static const MethodChannel _channel = MethodChannel('lcic_sdk');

  static Future<String?> initX5Core(String licenseKey) async {
    if (Platform.isAndroid) {
      return null;
    }
    return await _channel.invokeMethod<String>('initX5Core', {"licenseKey": licenseKey});
  }

  static Future<void> joinClass({
    required int schoolId,
    required String userId,
    required String token,
    required int classId,
    String? language,
    String? scene,
    bool? preferPortrait,
  }) async {
    try {
      final args = {
        'schoolId': schoolId,
        'userId': userId,
        'token': token,
        'classId': classId,
        'language': language,
        'scene': scene,
        'preferPortrait': preferPortrait,
      };
      await _channel.invokeMethod('joinClass', args);
    } on PlatformException catch (e) {
      throw 'Failed to join class: ${e.message}';
    }
  }
}
```

您可根据需要, 重新组织上述代码, 实现 MethodChannel 通信, 并传递这两个方法调用即可.

### 步骤七：SDK 授权申请

需要您提交 [腾讯云工单](https://console.cloud.tencent.com/workorder/category)，向我们发送 SDK 权限申请。请按以下模板提供对应信息。在信息确认无误的情况下，我们将会在1个工作日完成。

> **注意：**
>

> 一个旗舰版仅支持授权一个正式包名，请确认无误后发送相关信息。
>


> **说明：**
>

> 包名用于 x5 内核以及快直播播放器签名授权，请提供所需授权的正式应用的 App Name、Package Name 和 Bundle ID 信息。
>

>
>

> **问题标题**
>
> - 实时互动-教育版 SDK 授权申请

> **主要内容**
>
> - 公司名称：xxx 有限公司
> -  个人姓名：
> -  联系方式：
> -  App Name：
> -  Package Name （Android）：
> -  Bundle ID （iOS）：


### 步骤八：初始化 X5 内核

X5 内核相对于系统 WebView，具有兼容性更好，速度更快等优势。Android 实时互动-教育版 SDK 的组件实现依赖于 x5 内核的 WebView。现提供 x5 内核静态集成方式，能提升 x5 内核加载成功率且无需进程重启即可生效。
1. 检查同意隐私政策协议。


> **注意：**
>

> 建议在同意隐私政策协议之后，再调用初始化 X5 内核的方法，以免上架应用市场时未经用户同意，存在收集个人信息的行为。
>

2. 初始化 X5 内核。进入课堂前，**必须先判断 X5 内核是否初始化完成。**

   ``` java
   await LCICSDK.initX5Core(licenseKey);
   
   ```   

   > **注意：**
>
>   - LCICSDK.initX5Core(licenseKey); 中的 licenseKey 参数需要通过步骤七发送邮件联系我们获取 X5 内核的 licenseKey。
>   - 如果出现x5初始化失败，可及时 [联系我们](https://cloud.tencent.com/online-service?from=sales&source=PRESALE)。


### 步骤九：获取进入课堂所需参数

**TCICClassConfig** 参数解释
1. 通过 [控制台](https://console.cloud.tencent.com/lcic) 进入**应用管理 > 应用配置**，获取 [SDKAppId](https://console.cloud.tencent.com/lcic/app) ，即为学校编号(schoolId)信息。

2. 通过云 API 接口 [CreateRoom](https://cloud.tencent.com/document/product/1639/80942) 创建课堂，可以获取到课堂号(classid)信息。

3. 通过调用云 API 接口 [RegisterUser](https://cloud.tencent.com/document/product/1639/80935) 注册用户，可以获取到对应的用户 ID(userid)信息。

4. 通过云 API 接口 [LoginUser](https://cloud.tencent.com/document/product/1639/80938) 登录，可以获取到用户鉴权 token 信息。

5. scene、lng、camera、mic、speaker为非必要参数，如果不设置则使用的是默认值。如果需要, 您可在原生代码中对应增加参数接收及传递.

<table>
<tr>
<td rowspan="1" colSpan="1" >字段</td>

<td rowspan="1" colSpan="1" >类型</td>

<td rowspan="1" colSpan="1" >含义</td>

<td rowspan="1" colSpan="1" >备注</td>

<td rowspan="1" colSpan="1" >必填</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >schoolId</td>

<td rowspan="1" colSpan="1" >int</td>

<td rowspan="1" colSpan="1" >学校编号</td>

<td rowspan="1" colSpan="1" >通过控制台进入**应用管理 > 应用配置**，获取 [SDKAppId](https://console.cloud.tencent.com/lcic/app)</td>

<td rowspan="1" colSpan="1" >是</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >classId</td>

<td rowspan="1" colSpan="1" >long</td>

<td rowspan="1" colSpan="1" >课堂编号</td>

<td rowspan="1" colSpan="1" >通过[ CreateRoom ](https://cloud.tencent.com/document/product/1639/80942)接口创建返回 RoomId 获取</td>

<td rowspan="1" colSpan="1" >是</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >userId</td>

<td rowspan="1" colSpan="1" >string</td>

<td rowspan="1" colSpan="1" >用户账号</td>

<td rowspan="1" colSpan="1" >通过[  RegisterUser  ](https://cloud.tencent.com/document/product/1639/80935)接口获取</td>

<td rowspan="1" colSpan="1" >是</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >token</td>

<td rowspan="1" colSpan="1" >string</td>

<td rowspan="1" colSpan="1" >后台鉴权参数</td>

<td rowspan="1" colSpan="1" >通过[  LoginUser  ](https://cloud.tencent.com/document/product/1639/80938)接口获取</td>

<td rowspan="1" colSpan="1" >是</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >scene</td>

<td rowspan="1" colSpan="1" >string</td>

<td rowspan="1" colSpan="1" >场景名称</td>

<td rowspan="1" colSpan="1" >用于区分不同的定制布局，通过 [SetAppCustomContent](https://cloud.tencent.com/document/api/1639/81422) 接口配置</td>

<td rowspan="1" colSpan="1" >否</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >lng</td>

<td rowspan="1" colSpan="1" >string</td>

<td rowspan="1" colSpan="1" >语言参数</td>

<td rowspan="1" colSpan="1" >当前支持 zh、en，默认 zh 。同时需要设置一下TCICWebViewManager.getInstance().setClassLanuage(this, env, lng); lng参数。</td>

<td rowspan="1" colSpan="1" >否</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >camera</td>

<td rowspan="1" colSpan="1" >int</td>

<td rowspan="1" colSpan="1" >初始化开启摄像头</td>

<td rowspan="1" colSpan="1" >1为开启摄像头，0为关闭摄像头，默认 1</td>

<td rowspan="1" colSpan="1" >否</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >mic</td>

<td rowspan="1" colSpan="1" >int</td>

<td rowspan="1" colSpan="1" >初始化开启麦克风</td>

<td rowspan="1" colSpan="1" >1为开启麦克风，0为关闭麦克风，默认 1</td>

<td rowspan="1" colSpan="1" >否</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >speaker</td>

<td rowspan="1" colSpan="1" >int</td>

<td rowspan="1" colSpan="1" >初始化开启扬声器</td>

<td rowspan="1" colSpan="1" >1为开启扬声器，0为关闭扬声器，默认 1</td>

<td rowspan="1" colSpan="1" >否</td>
</tr>
</table>


### 步骤十：调起组件主页面

只需传递 4 个参数就可调起 LCIC 组件主页面，分别为学校编号、课堂编号、用户账号和 token。
``` java
LCICSDK.joinClass(
  schoolId: 123,
  userId: 'user123',
  token: 'abcd1234',
  classId: 456,
;
```

### 步骤十一：运行项目

完成上述所有开发步骤后, 即可运行项目. `flutter run`

请注意:
- iOS: 请使用真机调试, 不支持模拟器运行

- Android: 仅支持 arm 架构 CPU 调试, 因此无法在大部分 Windows 模拟器中使用.
