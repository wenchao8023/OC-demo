简书上更新一波推送
[新的推送](http://www.jianshu.com/p/f3e0e2f0b8e8)








### 1. 简介
通俗讲就是从远程服务器推送消息给客户端的通知，当然这需要联网,只要你的苹果设备联网状态，你的设备就与苹果的APNS服务器保持一个长连接状态。对于iOS中的通知，现在有很多成熟的第三方，比如腾讯的信鸽推送（王者荣耀也是用的这个）、极光推送、友盟推送等，个人在这里用的是[信鸽推送](http://xg.qq.com/)。这篇博文不会详细的对推送的基本流程做介绍，网上有很多很好的博文，可以参考。

### 2. 推送基本知识

#### 推送流程

1. 创建Push SSL Certification(推送证书)
2. iOS客户端注册Push功能并获得DeviceToken
3. 使用Provider向APNS发送Push消息
4. iOS客户端接收处理由APNS发来的消息

	推送流程图：
	
	![推送流程图](/Users/guowenchao/Desktop/remote_notify_simple_2x.png)
	
	* Provider 就是为指定iOS设备应用程序提供Push的服务器。如果iOS设备的应用程序是客户端的话，那么Provider可以理解为服务端(推送消息的发起者)
	* APNs：Apple Push Notification Service(苹果消息推送服务器)
	* Devices：iOS设备，用来接收APNs下发下来的消息
	* Client App：iOS设备上的应用程序，用来接收APNs下发的消息到指定的一个客户端app(消息的最终响应者)
	

#### 创建推送证书

1. App ID 的创建
2. Certificates 的创建和配置
3. 钥匙串中证书导出.p12格式文件

	博文[iOS 远程推送证书详细制作流程](http://www.jianshu.com/p/c60eb29db67e)有详细介绍制作流程
	
	如果使用信鸽推送，可以参照信鸽中的[iOS 证书设置指南](http://docs.developer.qq.com/xg/ios-zheng-shu-she-zhi-zhi-nan.html)

#### 获取Device token

App 必须要向 APNs 请求注册以实现推送功能，在请求成功后，APNs 会返回一个设备的标识符即 DeviceToken 给 App，服务器在推送通知的时候需要指定推送通知目的设备的 DeviceToken。在 iOS 8 以及之后，注册推送服务主要分为四个步骤：

1. 使用 registerUserNotificationSettings:注册应用程序想要支持的推送类型
2. 通过调用 registerForRemoteNotifications方法向 APNs 注册推送功能
3. 请求成功时，系统会在应用程序委托方法中返回 DeviceToken，请求失败时，也会在对应的委托方法中给出请求失败的原因。
4. 将 DeviceToken 上传到服务器，服务器在推送时使用。
	DeviceToken 有可能会更改，因此需要在程序每次启动时都去注册并且上传到你的服务器端。

#### 使用PushMeBaby发送通知

[PushMeBaby](https://github.com/stefanhafeneger/PushMeBaby)是一款远程推送测试的第三方，是mac上运行的一款发送通知的三方，打开项目只需要把之前创建好的push证书导入项目就好了。

> 运行之后如果报错
> 
> 	/Users/dengzemiao/Downloads/PushMeBaby-master/Classes/ioSock.h:52:10: 
> 	'CoreServices/../Frameworks/CarbonCore.framework/Headers/MacTypes.h' file 
> 	not found
> 
> 运行如果报错，那么导入CoreServices.framawork
> 
> 前往 ioSock.h 替换这句 #include 
> 
> <CoreServices/../Frameworks/CarbonCore.framework/Headers/MacTypes.h>  
> 
> 为 
> 
>  #include <MacTypes.h>

如果熟悉`PHP`的小伙伴可以自己通过`.pem证书`连接`APNS服务器`

然后在终端输入`php 文件名.php`就可以发送通知

```

<?php

// Put your device token here (without spaces):
$deviceToken = '66666633a8ad817ea5044d816a217f9c6333fb0bb99886f3d089b3a02666666';


//制作证书时输入的密码
$passphrase = 'xxxxxx';

// Put your alert message here:
$message = '这里是push测试的消息';

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'VoipCK.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
// develop env
$fp = stream_socket_client('gateway.sandbox.push.apple.com:2195', $err,$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);
// distribut env
// $fp = stream_socket_client('gateway.push.apple.com:2195', $err,$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);


if (!$fp)
	exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
$body['aps'] = array(
    'content-available' => '1',
	'alert' => $message,
	'sound' => 'callTipSound.wav',
    'badge' => 0,
	);

// Encode the payload as JSON
$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
	echo 'Message not delivered' . PHP_EOL;
else
	echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);
    
?>

```





### 3. 通知类型

#### 通知类型

* 普通推送 弹出一个通知框，用户可点击进入App
* 静默推送 推送信息，用户看不到任何提示，一般用户后台更新的操作

#### 通知时机

* App在前台
* App在后台
* App被挂起
* App被kill

```
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    /**
     *  这个 completionHandle 是回传给 App 的参数
     *
     *  @param UNNotificationPresentationOptionAlert 传了哪个就表示哪儿生效，这里可以根据自己的业务逻辑进行选择配置
     */
    
    //    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

```




