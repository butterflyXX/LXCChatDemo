//
//  ViewController.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/28.
//

import UIKit
import RxSwift
import MQTTClient

class ViewController: UIViewController, MQTTSessionManagerDelegate {
    
    let vm = HomeViewModel.shared
    
    private let disposeBag = DisposeBag()
    
    let manager = MQTTSessionManager()
    
    var session: MQTTSession?
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        seupBinding()
        
//                let transport = MQTTCFSocketTransport()
//                transport.host = "test.mosquitto.org"
//                transport.port = 1883
//        transport.tls = false;
//        transport.certificates = nil;
//        transport.voip = false;
//        transport.streamSSLLevel = "kCFStreamSocketSecurityLevelNegotiatedSSL";
//        
//                session = MQTTSession()
//                session?.transport = transport
//                session?.connect { [weak self] error in
//                    if error == nil {
//        
//                    } else {
//                        print("MQTT连接失败: \(error?.localizedDescription ?? "")")
//                    }
//                }
        
        //        let hasLogin = LoginManager.shared.reLogin()
        //        if !hasLogin {
        //            LoginManager.shared.presentLoginVc(base: self)
        //        }
        
        manager.delegate = self
        manager.connect(to: "test.mosquitto.org",
                        port: 1883,
                        tls: false,
                        keepalive: 60,
                        clean: true,
                        auth: false,
                        user: nil,
                        pass: nil,
                        will: false,
                        willTopic: nil,
                        willMsg: nil,
                        willQos: .atLeastOnce,
                        willRetainFlag: false,
                        withClientId: nil,
                        securityPolicy: nil,
                        certificates: nil,
                        protocolLevel: .version311) { error in
            print(error?.localizedDescription)
        }
    }
    
    private func setupUI() {
        // 添加右上角按钮
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        let logoutButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(logoutAction))
        navigationItem.leftBarButtonItem = logoutButton
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func seupBinding() {
        vm.userList
            .bind(to: tableView.rx.items(cellIdentifier: "cellId", cellType: UserCell.self)) { (row, viewModel, cell) in
                print(cell)
                cell.configure(user: viewModel)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.toChat(index: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func addButtonTapped() {
        let addFriendVC = AddFriendViewController()
        navigationController?.pushViewController(addFriendVC, animated: true)
    }
    
    @objc func logoutAction() {
        LoginManager.shared.logout()
        LoginManager.shared.presentLoginVc(base: self)
    }
    
    func toChat(index: Int) {
        let user = vm.userList.value[index]
        let vc = ChatDetailViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

