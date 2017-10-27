//
//  JoinChannelViewController.swift
//  FYRtcEngineKitDemo
//
//  Created by zhangyusheng on 2017/10/20.
//  Copyright © 2017年 zhangyusheng. All rights reserved.
//

import UIKit

class JoinChannelViewController: UIViewController,FYRtcEngineKitDelegate {

    var fyRtcEngine: FYRtcEngineKit!
    var timeNumber = 0
    var timer : Timer!
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fyRtcEngine = FYRtcEngineKit.sharedEngine(withAppId:AppID, appToken:AppToken, delegate: self);
        fyRtcEngine.joinChannel("channelId", uid: nil, optionData: nil, joinSuccess: nil)
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
        fyRtcEngine.leaveChannel { (status) in
            guard let timer1 = self.timer
                else{ return }
            timer1.invalidate()
        }
    }
    func onFYRtcEngine(_ engine: FYRtcEngineKit!, didJoinChannel channelId: String!, uid: String!) {
        //加入频道成功
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerEvent), userInfo: nil, repeats: true)
    }
    
    func timerEvent() {
        timeNumber += 1;
        if (timeNumber >= 3600)
        {
            let sec = timeNumber % 3600;
            timeLabel.text = String(format: "%d:%02d:%02d",(timeNumber / 3600),
                                    (sec/60), (sec%60))
        }
        else
        {
            timeLabel.text = String(format: "%02d:%02d",((timeNumber)/60),((timeNumber)%60))
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
