//
//  DialPeerViewController.swift
//  FYRtcEngineKitDemo
//
//  Created by zhangyusheng on 2017/10/20.
//  Copyright © 2017年 zhangyusheng. All rights reserved.
//

import UIKit

class DialPeerViewController: UIViewController,FYRtcEngineKitDelegate {

    var fyRtcEngine: FYRtcEngineKit!

    @IBOutlet weak var calleeUid: UITextField!
    @IBOutlet weak var callerUid: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func startCallEvent(_ sender: UIButton) {
        //拨打点对点电话
        fyRtcEngine.dialPeer(calleeUid.text, callerUid: nil, optionData: nil)
    }

    @IBAction func startOnlineEvent(_ sender: UIButton) {
        //被叫uid上线，准备接收来电
        fyRtcEngine.calleePrepare(callerUid.text!, prepareSuccess: nil)
    }
    
    func onFYRtcEngine(_ engine: FYRtcEngineKit!, incomingCall caller: String!) {
        //被叫收到来电，准备接听
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "InCallViewController") as! InCallViewController
        controller.isIncomingCall = true
        self.present(controller, animated: true, completion: nil)
    }
    
    func onFYRtcEngine(_ engine: FYRtcEngineKit!, outgoingCall callee: String!, uid: String!) {
        //呼出电话成功
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "InCallViewController") as! InCallViewController
        controller.isIncomingCall = false
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func onFYRtcEngineCalleePrepareSucess(_ engine: FYRtcEngineKit!) {
        //被叫上线成功，准备接收主叫来电
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
