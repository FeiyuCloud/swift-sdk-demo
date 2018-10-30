//
//  TestChannelViewController.swift
//  FYSdkDemo
//
//  Created by ting on 2018/10/29.
//  Copyright © 2018年 feiyucloud. All rights reserved.
//

import UIKit

class TestChannelViewController: UIViewController {
    
    // 长度不超过40的字符串，支持的字符集范围: a-z,A-Z,0-9,_,-
    private let fieldChannelId: UITextField = {
        let field = UITextField()
        field.placeholder = "channel id"
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 14)
        field.textAlignment = .center
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TestJoinChannel"
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(fieldChannelId)
        fieldChannelId.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            } else {
                make.top.equalTo(self.view).offset(40)
            }
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        
        let btnJoinChannel = UIButton.init(type: .system)
        btnJoinChannel.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btnJoinChannel.setTitle("Join Channel", for: .normal)
        btnJoinChannel.addTarget(self, action: #selector(self.actionBtnJoinChannel(_:)), for: .touchUpInside)
        self.view.addSubview(btnJoinChannel)
        btnJoinChannel.snp.makeConstraints { (make) in
            make.top.equalTo(self.fieldChannelId.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
        }
    }
    
    @objc func actionBtnJoinChannel(_ sender: Any) {
        let channelId = fieldChannelId.text
        guard !isEmptyString(channelId) else {
            MyProgressHUD.showError(msg: "channel id empty")
            return
        }
        let vc = ChannelViewController.init(channelId: channelId!)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}
