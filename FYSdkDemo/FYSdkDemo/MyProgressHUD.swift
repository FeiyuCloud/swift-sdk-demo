//
//  MyProgressHUD.swift
//  FYSdkDemo
//
//  Created by ting on 2018/10/29.
//  Copyright © 2018年 feiyucloud. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyProgressHUD: NSObject {
    
    private static let minimumDismissTimeInterval = 1.2
    
    private static func setupSVProgressHUD() {
        SVProgressHUD.setMinimumDismissTimeInterval(minimumDismissTimeInterval)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 60))
    }
    
    static func showProgress(msg: String?) {
        showProgress(progress: -1, msg: msg)
    }
    
    static func showProgress(progress: Float, msg: String?) {
        setupSVProgressHUD()
        SVProgressHUD.showProgress(progress, status: msg)
    }
    
    static func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    static func showInfo(msg: String?) {
        showInfo(msg: msg, completion: nil);
    }
    
    static func showInfo(msg: String?, completion: (() -> Void)?) {
        setupSVProgressHUD()
        SVProgressHUD.showInfo(withStatus: msg)
        handleCompletion(completion)
    }
    
    static func showSuccess(msg: String?) {
        showSuccess(msg: msg, completion: nil)
    }
    
    static func showSuccess(msg: String?, completion: (() -> Void)?) {
        setupSVProgressHUD()
        SVProgressHUD.showSuccess(withStatus: msg)
        handleCompletion(completion)
    }
    
    static func showError(msg: String?) {
        showError(msg: msg, completion: nil)
    }
    
    static func showError(msg: String?, completion: (() -> Void)?) {
        self.setupSVProgressHUD()
        SVProgressHUD.showError(withStatus: msg)
        handleCompletion(completion)
    }
    
    private static func handleCompletion(_ completion: (() -> Void)?) {
        if let closure = completion {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + minimumDismissTimeInterval) {
                closure()
            }
        }
    }
    
}
