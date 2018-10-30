//
//  Utils.swift
//  FYSdkDemo
//
//  Created by ting on 2018/10/29.
//  Copyright © 2018年 feiyucloud. All rights reserved.
//

import Foundation

func getUserId() -> String? {
    return UserDefaults.standard.string(forKey: "user_id")
}

func saveUserId(value: String?) {
    UserDefaults.standard.set(value, forKey: "user_id")
}

func isEmptyString(_ text: String?) -> Bool {
    if (text != nil && text!.count > 0) {
        return false
    }
    return true
}
