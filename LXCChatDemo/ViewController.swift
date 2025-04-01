//
//  ViewController.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/28.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let vm = HomeViewModel.shared
    
    private let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        seupBinding()
    }
    
    private func setupUI() {
        // 添加右上角按钮
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        vm.loadData()
    }
    
    private func seupBinding() {
        vm.userList
            .bind(to: tableView.rx.items(cellIdentifier: "cellId", cellType: UserCell.self)) { (row, viewModel, cell) in
                print(cell)
                cell.configure(user: viewModel)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func addButtonTapped() {
        let addFriendVC = AddFriendViewController()
        navigationController?.pushViewController(addFriendVC, animated: true)
    }
}

