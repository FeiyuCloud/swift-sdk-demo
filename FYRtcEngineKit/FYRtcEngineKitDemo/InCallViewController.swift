//
//  InCallViewController.swift
//  FYRtcEngineKitDemo
//
//  Created by zhangyusheng on 2017/10/23.
//  Copyright © 2017年 zhangyusheng. All rights reserved.
//

import UIKit

class InCallViewController: UIViewController,FYRtcEngineKitDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    var fyRtcEngine: FYRtcEngineKit!
    var isIncomingCall: Bool!
    var timeNumber = 0
    @IBOutlet weak var answerBtn: UIButton!
    @IBOutlet weak var endCallBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isIncomingCall{
            answerBtn.isHidden = true
            endCallBtn.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y:answerBtn.frame.origin.y);
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fyRtcEngine = FYRtcEngineKit.sharedEngine(withAppId:AppID, appToken:AppToken, delegate: self);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func answerCallBtnEvent(_ sender: UIButton) {
        //接听来电
        fyRtcEngine.answerCall()
        answerBtn.isHidden = true;
        endCallBtn.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y:answerBtn.frame.origin.y);
    }
    @IBAction func endCallBtnEvent(_ sender: UIButton) {
        //挂断电话
        fyRtcEngine.endCall { (AnyObject) in
            self.dismiss(animated: true, completion: nil);
        }
    }
    
    func timer() {
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
        // here code to perform
    }
    
    func onFYRtcEngineCallConnect(_ engine: FYRtcEngineKit!) {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timer), userInfo: nil, repeats: true)
    }
    func onFYRtcEngine(_ engine: FYRtcEngineKit!, callEnd status: FYRtcEngineStatus!) {
        self.dismiss(animated: true, completion: nil);
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
