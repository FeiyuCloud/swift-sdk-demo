//
//  CallViewController.swift
//  FYSdkDemo
//
//  Created by ting on 2018/10/29.
//  Copyright © 2018年 feiyucloud. All rights reserved.
//

import UIKit
import SnapKit

enum CallType {
    case incoming
    case Peer
}

class CallViewController: UIViewController, FYRtcEngineKitDelegate {
    
    private var callType: CallType!
    private var number: String!
    
    private var stateLabel: UILabel!
    private var endCallBtn: UIButton!
    private var answerCallBtn: UIButton?
    
    private var speakerBtn: UIButton!
    private var muteBtn: UIButton!
    
    private var duration: Int = 0
    private var countdownTimer: Timer?
    
    private let marginTop: CGFloat = 60
    private let marginBottom: CGFloat = 60
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init(callType: CallType, number: String) {
        self.init(nibName: nil, bundle: nil)
        self.callType = callType
        self.number = number
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "161616")
        
        // ================ label name and state ================
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .center
        nameLabel.text = number
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(marginTop)
            } else {
                make.top.equalTo(self.view).offset(marginTop)
            }
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        
        stateLabel = UILabel()
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 16)
        if callType == CallType.incoming {
            stateLabel.text = "来电"
        } else {
            stateLabel.text = "呼叫中"
        }
        self.view.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        // ================ button endCall, answerCall ================
        endCallBtn = UIButton(type: .custom)
        endCallBtn.setBackgroundImage(UIImage(named: "call_end_nor"), for: .normal)
        endCallBtn.setBackgroundImage(UIImage(named: "call_end_pre"), for: .highlighted)
        endCallBtn.addTarget(self, action: #selector(self.actionEndCall), for: .touchUpInside)
        self.view.addSubview(endCallBtn)
        
        if (callType == CallType.incoming) {
            endCallBtn.snp.makeConstraints { (make) in
                make.right.equalTo(self.view.snp.centerX).offset(-30)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-marginBottom)
                } else {
                    make.bottom.equalTo(self.view).offset(-marginBottom)
                }
            }
            
            answerCallBtn = UIButton(type: .custom)
            answerCallBtn?.setBackgroundImage(UIImage(named: "call_answer_nor"), for: .normal)
            answerCallBtn?.setBackgroundImage(UIImage(named: "call_answer_pre"), for: .highlighted)
            answerCallBtn?.addTarget(self, action: #selector(self.actionAnswerCall), for: .touchUpInside)
            self.view.addSubview(answerCallBtn!)
            answerCallBtn?.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.snp.centerX).offset(30)
                make.bottom.equalTo(self.view).offset(-marginBottom)
            }
        } else {
            endCallBtn.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view).offset(-marginBottom)
            }
        }
        
        // ================ button speaker, dtmfpad, mute ================
        
        speakerBtn = UIButton(type: .custom)
        speakerBtn.setBackgroundImage(UIImage(named: "call_speaker_nor"), for: .normal)
        speakerBtn.setBackgroundImage(UIImage(named: "call_speaker_pre"), for: .highlighted)
        speakerBtn.setBackgroundImage(UIImage(named: "call_speaker_pre"), for: .selected)
        speakerBtn.addTarget(self, action: #selector(self.actionSpeakerBtn), for: .touchUpInside)
        self.view.addSubview(speakerBtn)
        speakerBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.endCallBtn.snp.left).offset(-30)
            make.bottom.equalTo(self.endCallBtn)
        }
        
        muteBtn = UIButton(type: .custom)
        muteBtn.setBackgroundImage(UIImage(named: "call_mute_nor"), for: .normal)
        muteBtn.setBackgroundImage(UIImage(named: "call_mute_pre"), for: .highlighted)
        muteBtn.setBackgroundImage(UIImage(named: "call_mute_pre"), for: .selected)
        muteBtn.addTarget(self, action: #selector(self.actionMuteBtn), for: .touchUpInside)
        self.view.addSubview(muteBtn)
        muteBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.endCallBtn.snp.right).offset(30)
            make.bottom.equalTo(self.endCallBtn.snp.bottom)
        }
        
        speakerBtn.isHidden = true
        muteBtn.isHidden = true
        
        // ================ start call ================
        AppCall.shared.delegate = self
        
        if callType == CallType.Peer {
            AppCall.shared.getRtcEngine().dialPeer(number, callerUid: getUserId(), option: nil)
        }
        
    }
    
    // MARK: - Button click action
    @objc func actionEndCall() {
        AppCall.shared.getRtcEngine().endCall()
    }
    
    @objc func actionAnswerCall() {
        answerCallBtn?.snp.removeConstraints()
        answerCallBtn?.removeFromSuperview()
        endCallBtn.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-marginBottom)
        }
        
        AppCall.shared.getRtcEngine().answerCall()
    }
    
    @objc func actionSpeakerBtn() {
        speakerBtn.isSelected = !speakerBtn.isSelected
        AppCall.shared.getRtcEngine().enableSpeaker(speakerBtn.isSelected)
    }
    
    @objc func actionMuteBtn() {
        muteBtn.isSelected = !muteBtn.isSelected
        AppCall.shared.getRtcEngine().muteLocalAudio(muteBtn.isSelected)
    }
    
    // MARK: - FYRtcEngineKitDelegate
    func rtcEngineDidCallConnect(_ engine: FYRtcEngineKit) {
        speakerBtn.isHidden = false
        muteBtn.isHidden = false
        startCountdown()
    }
    
    func rtcEngineDidCallEnd(_ engine: FYRtcEngineKit) {
        didCallEnd()
    }
    
    func rtcEngine(_ engine: FYRtcEngineKit, didError error: FYError) {
        didCallEnd()
    }
    
    // MARK: - Private
    private func didCallEnd() {
        stateLabel.text = "通话结束"
        speakerBtn.isHidden = true
        muteBtn.isHidden = true
        countdownTimer?.invalidate()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func startCountdown() {
        if countdownTimer == nil {
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.duration += 1
                if self.duration >= 3600 {
                    let sec = self.duration % 3600
                    self.stateLabel.text = String(format: "%d:%02d:%02d",
                                                  (Int)(self.duration / 3600),
                                                  (Int)(self.duration / 60),
                                                  (Int)(sec % 60))
                } else {
                    self.stateLabel.text = String(format: "%02d:%02d",
                                                  (Int)(self.duration / 60),
                                                  (Int)(self.duration % 60))
                }
            })
        }
    }
    
}
