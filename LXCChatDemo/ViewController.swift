//
//  ViewController.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/28.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ChatDBManager.shared.getUserList { list in
            print(list)
        }
        // 添加右上角按钮
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func addButtonTapped() {
        let addFriendVC = AddFriendViewController()
        navigationController?.pushViewController(addFriendVC, animated: true)
    }

}

