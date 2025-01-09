
# 腾讯云实时互动-教育版 Flutter Demo

通过本篇文档，您将快速跑通一个集成了 LCIC 功能的 Flutter 项目。

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


### 步骤三：SDK 授权申请

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


### 步骤四：下载 Demo

克隆本仓库, 即包含了完整的 Demo 源码.

> 如果您想要在旧项目中集成 LCIC 的功能，可参考 [**这篇文档**](https://github.com/RoleWong/lcic_flutter_demo/blob/main/integrate%20to%20exsiting%20project.md), 对照阅读使用。
>


### 

### 步骤五：配置 Demo

#### **修改包名**

请将步骤四中下载的 Demo 源码, 其 Android 包名和 iOS Bundle ID 修改成在步骤三申请的参数.

#### **更新版本号**

打开 android/app/build.gradle 文件, 确保底部 com.tencent.edu:TCICSDK 使用[最新版本](https://cloud.tencent.com/document/product/1639/79898#23829253-90ae-40a2-a96d-3504ce2f80c5).
``` plaintext
dependencies {
    implementation 'com.tencent.edu:TCICSDK:这里改成最新版本号'
}
```

打开 ios/Podfile 文件, 确保 TCICSDK_Pro 和 TXLiteAVSDK_Professional 使用[最新版本](https://cloud.tencent.com/document/product/1639/79897#23829253-90ae-40a2-a96d-3504ce2f80c5).
``` plaintext
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  pod 'TCICSDK_Pro', '这里改成最新版本号'
  pod 'TXLiteAVSDK_Professional', '这里改成最新版本号'

  target 'RunnerTests' do
    inherit! :search_paths
  end
end
```

### 步骤六：获取进入课堂所需参数

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


### 步骤七：调起组件主页面

打开 `lib/main.dart` 文件, 在 `onPressed` 事件中, 填入此前步骤申请并获取的参数.
``` java
onPressed: () async {
  try {
    await LCICSDK.initX5Core(''); // TODO: 将申请的 X5 内核 licenseKey 填入此处
    // 将上课信息填入下方. 只需传递 4 个参数就可调起 LCIC 组件主页面，分别为学校编号、课堂编号、用户账号和 token。
    await LCICSDK.joinClass(
      schoolId: 0,  // TODO
      classId: 0,  // TODO
      userId: '',  // TODO
      token: '',  // TODO
    );
  } catch (e) {
    print('Error: $e');
  }
},
```

### 步骤八：运行项目

完成上述所有开发步骤后, 即可运行项目. `flutter run`

> **注意：**
>

> iOS: 请使用真机调试, 不支持模拟器运行。
>

> Android: 仅支持 arm 架构 CPU 调试, 因此无法在大部分 Windows 模拟器中使用.
> 


