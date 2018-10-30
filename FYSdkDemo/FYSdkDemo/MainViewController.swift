//
//  ViewController.swift
//  FYSdkDemo
//
//  Created by ting on 2018/10/29.
//  Copyright © 2018年 feiyucloud. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // 长度不超过40的字符串，支持的字符集范围: a-z,A-Z,0-9,_,-
    private let fieldUid: UITextField = {
        let field = UITextField()
        field.placeholder = "user id"
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 14)
        field.textAlignment = .center
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FYSdkDemo"
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.backgroundColor = UIColor.white
        
        let font = UIFont.systemFont(ofSize: 18)
        
        let btnChannel = UIButton.init(type: .system)
        btnChannel.titleLabel?.font = font
        btnChannel.setTitle("Test Join Channel", for: .normal)
        btnChannel.addTarget(self, action: #selector(self.actionBtnChannel(_:)), for: .touchUpInside)
        self.view.addSubview(btnChannel)
        btnChannel.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            } else {
                make.top.equalTo(self.view).offset(40)
            }
            make.centerX.equalTo(self.view)
        }
        
        let btnVoIP = UIButton.init(type: .system)
        btnVoIP.titleLabel?.font = font
        btnVoIP.setTitle("Test VoIP", for: .normal)
        btnVoIP.addTarget(self, action: #selector(self.actionBtnVoIP(_:)), for: .touchUpInside)
        self.view.addSubview(btnVoIP)
        btnVoIP.snp.makeConstraints { (make) in
            make.top.equalTo(btnChannel.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
        }
        
        let btnSave = UIButton.init(type: .system)
        btnSave.titleLabel?.font = font
        btnSave.setTitle("Save", for: .normal)
        btnSave.addTarget(self, action: #selector(self.actionBtnSave(_:)), for: .touchUpInside)
        self.view.addSubview(btnSave)
        btnSave.snp.makeConstraints { (make) in
            make.top.equalTo(btnVoIP.snp.bottom).offset(40)
            make.right.equalTo(self.view).offset(-20)
            make.width.lessThanOrEqualTo(50)
        }
        
        fieldUid.text = getUserId()
        self.view.addSubview(fieldUid)
        fieldUid.snp.makeConstraints { (make) in
            make.centerY.equalTo(btnSave)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(btnSave.snp.left).offset(-10)
        }
        
        let tip = UILabel()
        tip.textColor = UIColor.gray
        tip.font = UIFont.systemFont(ofSize: 13)
        tip.numberOfLines = 0
        tip.text = "user id 用于 JoinChannel ，dialPeer 和 CalleePrepare \nCalleePrepare 时不能为空，其他情况可为空"
        self.view.addSubview(tip)
        tip.snp.makeConstraints { (make) in
            make.top.equalTo(fieldUid.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
    }
    
    @objc func actionBtnChannel(_ sender: Any) {
        self.navigationController?.pushViewController(TestChannelViewController(), animated: true)
    }
    
    @objc func actionBtnVoIP(_ sender: Any) {
        self.navigationController?.pushViewController(TestVoIPViewController(), animated: true)
    }
    
    @objc func actionBtnSave(_ sender: Any) {
        let userId = fieldUid.text
        print("save userId: \(userId ?? "null")")
        saveUserId(value: userId)
        MyProgressHUD.showInfo(msg: "Save Success")
    }
    
}

