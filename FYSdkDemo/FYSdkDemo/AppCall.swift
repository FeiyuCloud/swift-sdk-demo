//
//  AppCall.swift
//  FYSdkDemo
//
//  Created by ting on 2018/10/29.
//  Copyright © 2018年 feiyucloud. All rights reserved.
//

import UIKit

class AppCall: NSObject, FYRtcEngineKitDelegate {
    
    private let AppId = AppId
    private let AppToken = AppToken
    
    class var shared: AppCall {
        struct SingletonHolder {
            static let instance = AppCall()
        }
        return SingletonHolder.instance
    }
    
    weak var delegate: FYRtcEngineKitDelegate? = nil
    private var rtcEngine: FYRtcEngineKit? = nil
    
    private override init() {}
    
    func getRtcEngine() -> FYRtcEngineKit {
        if rtcEngine == nil {
            rtcEngine = FYRtcEngineKit.sharedEngine(withAppId: AppId,
                                                    appToken: AppToken,
                                                    delegate: AppCall.shared)
            let ringPath = Bundle.main.path(forResource: "ring", ofType: "m4a")
            rtcEngine?.setRing(ringPath!)
            print("set ring path: \(String(describing: ringPath))")
        }
        return rtcEngine!
    }
    
    // MARK: - FYRtcEngineKitDelegate
    // 发生异常
    func rtcEngine(_ engine: FYRtcEngineKit, didError error: FYError) {
        MyProgressHUD.showError(msg: error.msg)
        delegate?.rtcEngine?(engine, didError: error)
    }
    
    // 当前用户加入channel
    func rtcEngine(_ engine: FYRtcEngineKit, didJoinChannel channel: String, uid: String) {
        delegate?.rtcEngine?(engine, didJoinChannel: channel, uid: uid)
    }
    
    // 当前用户离开channel
    func rtcEngine(_ engine: FYRtcEngineKit, didLeaveChannel channel: String) {
        delegate?.rtcEngine?(engine, didLeaveChannel: channel)
    }
    
    // 其他用户加入channel
    func rtcEngine(_ engine: FYRtcEngineKit, didJoinedOfUid uid: String) {
        delegate?.rtcEngine?(engine, didJoinedOfUid: uid)
    }
    
    // 其他用户离开channel
    func rtcEngine(_ engine: FYRtcEngineKit, didOfflineOfUid uid: String) {
        delegate?.rtcEngine?(engine, didOfflineOfUid: uid)
    }
    
    // channel中的用户被静音/接触静音
    func rtcEngine(_ engine: FYRtcEngineKit, didAudioMuted muted: Bool, uid: String) {
        delegate?.rtcEngine?(engine, didAudioMuted: muted, uid: uid)
    }
    
    // 点到点来电
    func rtcEngine(_ engine: FYRtcEngineKit, didCallIncomingWithCaller caller: String) {
        let vc = CallViewController.init(callType: CallType.incoming, number: caller)
        let app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func rtcEngine(_ engine: FYRtcEngineKit, didCallOutgoingWithCallee callee: String, uid: String) {
        delegate?.rtcEngine?(engine, didCallOutgoingWithCallee: callee, uid: uid)
    }
    
    func rtcEngineDidCallConnect(_ engine: FYRtcEngineKit) {
        delegate?.rtcEngineDidCallConnect?(engine)
    }
    
    func rtcEngineDidCallEnd(_ engine: FYRtcEngineKit) {
        delegate?.rtcEngineDidCallEnd?(engine)
    }
    
    func rtcEngineDidCalleePrepareSuccess(_ engine: FYRtcEngineKit) {
        MyProgressHUD.showSuccess(msg: "CalleePrepare Success")
    }
    
}
