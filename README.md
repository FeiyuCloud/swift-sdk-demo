# objc-sdk-demo
Feiyu Cloud Objective-C SDK Demo
#
iOS集成指南

#### 1. 开发环境要求:

> * iOS 8.0及以上
> * 不支持模拟器编译运行
> * Build Settings中Other Linker Flags添加-ObjC


#### 2. 支持FYRtcEngineKit需要的framework
![](/assets/61A99AB8-B74C-42FF-AE44-76C2D8E54CCC.png)

#### 3. 初始化 FYRtcEngineKit

代码示例如下：
```objectivec
//objective-c
//初始化FYRtcEngineKit
FYRtcEngineKit *engineKit = [FYRtcEngineKit sharedEngineWithAppId:@"59DD**********E58A" AppToken:@"9050*********1D19" delegate:self];

//创建并加入频道
[engineKit joinChannel:@"channelId" Uid:nil OptionData:data JoinSuccess:nil];
```

```swift
//Swift
//初始化FYRtcEngineKit
let engineKit = FYRtcEngineKit.sharedEngine(withAppId: "59DD**********E58A", appToken: "9050*********1D19", delegate: self);

//创建并加入频道
engineKit.joinChannel("channelId", uid: nil, optionData: nil, joinSuccess: nil)
```
现在可以一对一或者一对多进行语音聊天了, uid: nil, optionData: nil, joinSuccess: nil)
现在可以一对一或者一对多进行语音聊天了