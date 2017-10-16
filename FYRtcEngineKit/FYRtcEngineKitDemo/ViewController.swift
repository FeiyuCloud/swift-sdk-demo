//
//  ViewController.swift
//  FYRtcEngineKitDemo
//
//  Created by zhangyusheng on 2017/9/23.
//  Copyright © 2017年 zhangyusheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var fyRtcEngine: FYRtcEngineKit!
    override func viewDidLoad() {
        super.viewDidLoad()
        fyRtcEngine = FYRtcEngineKit.sharedEngine(withAppId:"your appid", appToken:"your apptoken", delegate: nil)
        fyRtcEngine.joinChannel("channelId123", uid: nil, optionData: nil, joinSuccess: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func speakerBtnEvent(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        fyRtcEngine.enabledSpeaker( sender.isSelected)
    }
    @IBAction func muteBtnEvent(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        fyRtcEngine.muteLocalAudio(sender.isSelected)
    }
    @IBAction func endCallBtnEvent(_ sender: UIButton) {
        fyRtcEngine.leaveChannel(nil)
    }
}

