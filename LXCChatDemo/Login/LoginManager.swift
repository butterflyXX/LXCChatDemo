//
//  LoginManager.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/7.
//

import Foundation
import UIKit

class LoginManager {
    
    static let shared = LoginManager()
    init() {}
    
    let key = "user_id"
    
    var userId: String?
    
    var hasLogin: Bool {userId != nil}
    
    func reLogin() -> Bool {
        if let userId = UserDefaults.standard.string(forKey: key) {
            login(id: userId)
            return true
        }
        return false
    }
    
    func login(id: String) {
        userId = id
        UserDefaults.standard.set(id, forKey: key)
        let clientId = id + UIDevice.current.name
        let server = ServerModel(ip: "test.mosquitto.org", port: 1883)
        IMManager.shared.setupSDK(userId: id, clientId: clientId, server: server, keepLive: 60)
        HomeViewModel.shared.loadData()
        IMManager.shared.connect { error in
            if let error = error {
                print("链接错误: \(error.localizedDescription)")
            } else {
                print("链接成功")
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: key)
        HomeViewModel.shared.userList.accept([])
        IMManager.shared.disconnect()
    }
    
    func presentLoginVc(base: UIViewController) {
        let vc = LoginViewController()
        vc.isModalInPresentation = true
        base.present(vc, animated: true)
    }
}
