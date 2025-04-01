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
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        
        // 使用 SnapKit 设置约束
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(18)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        nameLabel.adjustsFontSizeToFitWidth = false
        detailLabel.adjustsFontSizeToFitWidth = false
    }
    
    // MARK: - Configuration
    func configure(user: ViewModel<User>) {
        // 使用 RxSwift 绑定数据
        user.observer.map{$0.nickname}
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        user.observer.map{$0.lastMessageString}
            .bind(to: detailLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        nameLabel.text = nil
        detailLabel.text = nil
    }
}
