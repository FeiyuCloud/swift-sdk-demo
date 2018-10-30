# feiyu sdk swift demo

#### 1. 开发环境要求:

> * iOS 8.0及以上
> * 不支持模拟器编译运行
> * 准备好 AppID 和 AppToken
> * Build Settings中Other Linker Flags添加-ObjC


#### 2. 支持FYRtcEngineKit需要的framework
![github](https://github.com/FeiyuCloud/objc-sdk-demo/blob/master/img/linked_frameworks_libs.png "github")


#### 6. 使用

- 创建FYRtcEngine：

```swift
let rtcEngine = FYRtcEngineKit.sharedEngine(withAppId: "YourAppId", appToken: "YourAppToken", delegate: this)
```

| 参数 | 是否必须 | 描述 |
| ---- | :---- | :---- |
| appId | 是 | 应用id |
| appToken | 是 | 应用token |
| FYRtcEngineKitDelegate | 否 | 提供FYRtcEngineKit所有事件回调 |

<br/>

- 加入频道：

```swift
rtcEngine.joinChannel(channelId, uid: userId, option: nil)
```

| 参数 | 是否必须 | 描述 |
| ---- | :---- | :---- |
| channelId | 是 | 频道id，字符串，数字，\_，长度不超过40位 |
| uid | 否 | 用户id，为空时sdk会生成一个uid |
| option | 否 | 选项，可以配置最大时长，是否录音和偷传数据 |

<br/>

- 点到点语音：

```swift
rtcEngine.dialPeer(calleeUid, callerUid: callerUid, option: nil)
```

| 参数 | 是否必须 | 描述 |
| --- | --- | --- |
| calleeUid | 是 | 被叫用户id |
| callerUid | 否 | 主叫用户id，为空时sdk会生成一个uid |
| option | 否 | 呼叫选项，可配置最大时长，是否录音，透传数据 |

<br/>

- 准备接听点到点来电：

```swift
rtcEngine.calleePrepare(uid)
```
| 参数 | 是否必须 | 描述 |
| --- | --- | --- |
| uid | 是 | 当前的uid |

主叫呼叫被叫时，可以使用离线推送（如小米push）通知被叫，被叫调用`calleePrepare`准备接听来电，调用成功后一段时间内都可以接听到点到点语音来电。

注意：`calleePrepare`的参数需和`dialPeer`的calleeUid保持一致。

<br/>

> channelId，uid格式：长度不超过40的字符串，支持的字符集范围: a-z,A-Z,0-9,_,-


<br/>

#### 4. 参考文档
[http://gitbook.feiyucloud.com/tong-xin-api-objective-c.html](http://gitbook.feiyucloud.com/tong-xin-api-objective-c.html)

[http://www.jianshu.com/p/48f213c25e4c](http://www.jianshu.com/p/48f213c25e4c)

[https://github.com/crifan/feiyuiOSDemo](https://github.com/crifan/feiyuiOSDemo)


<br/>
