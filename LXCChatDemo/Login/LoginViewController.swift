//
//  LoginViewController.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/7.
//

import UIKit

class LoginViewController: UIViewController {

  let loginView = UITextField()
  let loginButton = UIButton()
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(loginView)
        view.addSubview(loginButton)
        
        loginView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(loginView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }

        loginView.placeholder = "请输入用户名"
        loginButton.setTitle("登录", for: .normal)
        loginButton.backgroundColor = .blue
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }

    @objc func login() {
        if let userId = loginView.text {
            LoginManager.shared.login(id: userId)
            dismiss(animated: true)
        }
    }
}
