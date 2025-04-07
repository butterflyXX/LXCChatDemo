//
//  ChatInputView.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/7.
//

import UIKit
import SnapKit

protocol ChatInputViewDelegate: AnyObject {
    func inputView(_ inputView: ChatInputView, didSendText text: String)
    func inputViewDidTapImage(_ inputView: ChatInputView)
    func inputViewDidTapEmoji(_ inputView: ChatInputView)
}

class ChatInputView: UIView {
    // MARK: - Properties
    weak var delegate: ChatInputViewDelegate?
    private let maxHeight: CGFloat = 100
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.delegate = self
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = .systemGray3
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var toolBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var emojiButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        button.addTarget(self, action: #selector(emojiButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupKeyboardObservers()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // 添加顶部边框
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        topBorder.backgroundColor = UIColor.systemGray4.cgColor
        layer.addSublayer(topBorder)
        
        // 添加子视图
        addSubview(containerView)
        containerView.addSubview(toolBar)
        containerView.addSubview(textView)
        containerView.addSubview(sendButton)
        toolBar.addSubview(emojiButton)
        toolBar.addSubview(imageButton)
        
        // 设置约束
        setupConstraints()
    }
    
    private func setupConstraints() {
        // 容器视图约束
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(56)
        }
        
        // 工具栏约束
        toolBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        // 表情按钮约束
        emojiButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        // 图片按钮约束
        imageButton.snp.makeConstraints { make in
            make.leading.equalTo(emojiButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        // 发送按钮约束
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(toolBar.snp.top).offset(-8)
            make.width.equalTo(60)
            make.height.equalTo(36)
        }
        
        // 文本框约束
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.bottom.equalTo(toolBar.snp.top).offset(-8)
            make.height.lessThanOrEqualTo(maxHeight)
        }
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillHide),
                                             name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            // 更新底部约束
            containerView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-keyboardHeight)
            }
            
            // 添加动画
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                UIView.animate(withDuration: duration) {
                    self.superview?.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // 恢复底部约束
        containerView.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        // 添加动画
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func sendButtonTapped() {
        guard let text = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            return
        }
        
        delegate?.inputView(self, didSendText: text)
        textView.text = ""
        updateTextViewHeight()
        updateSendButtonState()
    }
    
    @objc private func emojiButtonTapped() {
        delegate?.inputViewDidTapEmoji(self)
    }
    
    @objc private func imageButtonTapped() {
        delegate?.inputViewDidTapImage(self)
    }
    
    private func updateSendButtonState() {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        sendButton.isEnabled = !text.isEmpty
        sendButton.backgroundColor = text.isEmpty ? .systemGray3 : .systemBlue
    }
    
    private func updateTextViewHeight() {
        let size = CGSize(width: textView.bounds.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let height = min(estimatedSize.height, maxHeight)
        
        textView.snp.updateConstraints { make in
            make.height.lessThanOrEqualTo(height)
        }
    }
}

// MARK: - UITextViewDelegate
extension ChatInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
        updateSendButtonState()
    }
}
