//
//  UserCell.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/1.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

class UserCell: UITableViewCell {
    // MARK: - UI Components
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    
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
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        stack.axis = .vertical
        stack.spacing = 4
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(16)
            make.top.equalTo(12)
        }
    }
    
    // MARK: - Configuration
    func configure(user: User) {
        // 使用 RxSwift 绑定数据
        nameLabel.text = user.nickname
        detailLabel.text = user.nickname
        detailLabel.isHidden = user.lastMessageString.isEmpty
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        nameLabel.text = nil
        detailLabel.text = nil
    }
}
