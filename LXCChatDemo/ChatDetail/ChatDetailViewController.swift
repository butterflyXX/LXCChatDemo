//
//  ChatDetailViewController.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/7.
//

import UIKit
import RxSwift

class ChatDetailViewController: UIViewController {
    
    let user: User
    
    private lazy var vm = ViewModel(user: user)
    
    private let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.keyboardDismissMode = .onDragWithAccessory
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return tableView
    }()
    
    private lazy var textInputView: ChatInputView = {
        let input = ChatInputView()
        input.delegate = self
        return input
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        seupBinding()
    }
    
    private func setupUI() {
        title = user.nickname
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(textInputView)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(textInputView.snp.top)
        }
        
        textInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func loadData() {
        vm.loadData(isFirstLoad: true)
    }
    
    private func seupBinding() {
        vm.messageList
            .bind(to: tableView.rx.items(cellIdentifier: "MessageCell", cellType: ChatMessageCell.self)) { (row, message, cell) in
                cell.configure(message: message)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        scrollToBottom(animated: false)
    }
    
    private func handleNewMessage(_ message: DAMessage) {
        vm.add(message: message)
        scrollToBottom()
    }
    
    private func scrollToBottom(animated: Bool = true) {
        guard !vm.messageList.value.isEmpty else { return }
        
        if !vm.messageList.value.isEmpty{
            let lastIndex = IndexPath(row: vm.messageList.value.count - 1, section: 0)
            tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ChatDetailViewController: ChatInputViewDelegate {
    func inputView(_ inputView: ChatInputView, didSendText text: String) {
        let message = DAMessage()
        let content = DAMessageText()
        content.text = text
        message.content = content
        message.type = DAMessageType.text.rawValue
        IMManager.shared.preSaveMessage(targetId: user.userId, message: message)
//        QMIMManager.share.sendMessage(conversationType: .single, targetId: "\(targetId)", message: message) { a, b in
//            print("lxc_sendSuccess")
//        } failed: { a, error in
//            print("lxc_sendFail: \(error.imErrorType)")
//        }
        
        // 更新UI
        handleNewMessage(message)
    }
    
    func inputViewDidTapImage(_ inputView: ChatInputView) {
        // 实现图片选择逻辑
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true)
    }
    
    func inputViewDidTapEmoji(_ inputView: ChatInputView) {
        // 实现表情选择逻辑
    }
}
