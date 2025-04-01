//
//  ViewController.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/28.
//

import UIKit

class ViewController: UIViewController {
    
    let vm = HomeViewModel.shared
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        
        // 设置自动高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60 // 设置预估高度，提高性能
        
        // 可选：设置section header/footer自动高度
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加右上角按钮
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vm.loadData {
            self.tableView.reloadData()
        }
    }
    
    @objc func addButtonTapped() {
        //		let addFriendVC = AddFriendViewController()
        //		navigationController?.pushViewController(addFriendVC, animated: true)
        
        if let userVm = vm.userList.first {
            let user = userVm.value
            user.lastMessageString = "haha"
            userVm.value = user
        }
    }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? UserCell else { return UITableViewCell()}
        cell.configure(user: vm.userList[indexPath.row])
        return cell
    }
}

