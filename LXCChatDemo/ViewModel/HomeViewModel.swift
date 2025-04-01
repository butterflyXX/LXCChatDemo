//
//  HomeViewModel.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/1.
//

class HomeViewModel {
    static let shared = HomeViewModel()
    private init(){}
    
    var userList: [ViewModel<User>] = []
    
    func loadData(completion: VoidCallBack? = nil) {
        ChatDBManager.shared.getUserList { list in
            if let list = list {
                self.userList.append(contentsOf: list.map({ViewModel($0)}))
            }
            completion?()
        }
    }
}
