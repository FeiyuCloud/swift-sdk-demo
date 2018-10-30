//
//  TestVoIPViewController.swift
//  FYSdkDemo
//
//  Created by ting on 2018/10/29.
//  Copyright © 2018年 feiyucloud. All rights reserved.
//

import UIKit

class TestVoIPViewController: UIViewController {
    
    private let fieldUid: UITextField = {
        let field = UITextField()
        field.placeholder = "callee uid"
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 14)
        field.textAlignment = .center
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TestVoIP"
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(fieldUid)
        fieldUid.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            } else {
                make.top.equalTo(self.view).offset(40)
            }
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        
        let btnDialPeer = UIButton.init(type: .system)
        btnDialPeer.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btnDialPeer.setTitle("DialPeer", for: .normal)
        btnDialPeer.addTarget(self, action: #selector(self.actionBtnDialPeer(_:)), for: .touchUpInside)
        self.view.addSubview(btnDialPeer)
        btnDialPeer.snp.makeConstraints { (make) in
            make.top.equalTo(self.fieldUid.snp.bottom).offset(20)
            make.centerX.equalTo(self.view).multipliedBy(0.5)
        }
        
        let btnCalleePerpare = UIButton.init(type: .system)
        btnCalleePerpare.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btnCalleePerpare.setTitle("CalleePrepare", for: .normal)
        btnCalleePerpare.addTarget(self, action: #selector(self.actionBtnCalleePrepare(_:)), for: .touchUpInside)
        self.view.addSubview(btnCalleePerpare)
        btnCalleePerpare.snp.makeConstraints { (make) in
            make.top.equalTo(self.fieldUid.snp.bottom).offset(20)
            make.centerX.equalTo(self.view).multipliedBy(1.5)
        }
    }
    
    @objc func actionBtnDialPeer(_ sender: Any) {
        let calleeUid = fieldUid.text
        guard !isEmptyString(calleeUid) else {
            MyProgressHUD.showError(msg: "callee uid empty")
            return
        }
        let vc = CallViewController.init(callType: CallType.Peer, number: calleeUid!)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func actionBtnCalleePrepare(_ sender: Any) {
        let userId = getUserId();
        guard !isEmptyString(userId) else {
            MyProgressHUD.showInfo(msg: "user id empty")
            return
        }
        AppCall.shared.getRtcEngine().calleePrepare(userId!)
    }
    
}
