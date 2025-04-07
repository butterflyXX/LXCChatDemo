//
//  ChatDetailCell.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/7.
//

import UIKit
import SnapKit

class ChatMessageCell: UITableViewCell {
    
    // MARK: - Properties
    private let bubbleInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    private let maxBubbleWidth = UIScreen.main.bounds.width * 0.7
    
    // MARK: - UI Components
    private lazy var bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        // 基本约束
        setupConstraints()
    }
    
    private func setupConstraints() {
        // 头像约束
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(8)
        }
        
        // 时间标签约束
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(bubbleView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        // 消息标签约束
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(bubbleInsets)
            make.width.lessThanOrEqualTo(maxBubbleWidth - bubbleInsets.left - bubbleInsets.right)
        }
    }
    
    // MARK: - Configuration
    func configure(message: DAMessage) {
        if let msg = message.content as? DAMessageText, let text = msg.text {
            messageLabel.text = text
            timeLabel.text = formatTime(message.createTime)
            setupOutgoingMessage()
//            if message.isSend {
//                setupOutgoingMessage()
//            } else {
//                setupIncomingMessage()
//            }
        }
    }
    
    private func setupIncomingMessage() {
        // 左侧消息样式
        bubbleView.backgroundColor = .systemGray6
        messageLabel.textColor = .black
        
        // 头像约束
        avatarImageView.snp.remakeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(12)
        }
        
        // 气泡约束
        bubbleView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.width.lessThanOrEqualTo(maxBubbleWidth)
        }
        
        // 时间标签约束
        timeLabel.snp.remakeConstraints { make in
            make.top.equalTo(bubbleView.snp.bottom).offset(4)
            make.leading.equalTo(bubbleView)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    private func setupOutgoingMessage() {
        // 右侧消息样式
        bubbleView.backgroundColor = .systemBlue
        messageLabel.textColor = .white
        
        // 头像约束
        avatarImageView.snp.remakeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        // 气泡约束
        bubbleView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalTo(avatarImageView.snp.leading).offset(-8)
            make.width.lessThanOrEqualTo(maxBubbleWidth)
        }
        
        // 时间标签约束
        timeLabel.snp.remakeConstraints { make in
            make.top.equalTo(bubbleView.snp.bottom).offset(4)
            make.trailing.equalTo(bubbleView)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    // MARK: - Helper Methods
    private func formatTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}

