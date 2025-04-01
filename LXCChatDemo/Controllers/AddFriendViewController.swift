import UIKit

class AddFriendViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var userIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入用户ID"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.returnKeyType = .next
        textField.delegate = self
        return textField
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入昵称"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("添加好友", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "添加好友"
        
        view.addSubview(userIdTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(addButton)
    }
    
    private func setupConstraints() {
        userIdTextField.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userIdTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userIdTextField.heightAnchor.constraint(equalToConstant: 44),
            
            nicknameTextField.topAnchor.constraint(equalTo: userIdTextField.bottomAnchor, constant: 20),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            addButton.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 30),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        guard let userId = userIdTextField.text, !userId.isEmpty,
              let nickname = nicknameTextField.text, !nickname.isEmpty else {
            showAlert(message: "请输入用户ID和昵称")
            return
        }
        
        // 创建好友对象
        let friend = User()
        friend.userId = userId
        friend.nickname = nickname
        
        // 保存到数据库
        ChatDBManager.shared.insertUser(user: friend) { [weak self] error in
            if error == nil {
                HomeViewModel.shared.insert(user: friend)
                self?.showAlert(message: "添加好友成功") { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                self?.showAlert(message: "添加好友失败")
            }
        }
    }
    
    // MARK: - Helper Methods
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension AddFriendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userIdTextField {
            nicknameTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            addButtonTapped()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
} 
