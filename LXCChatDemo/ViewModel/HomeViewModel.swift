//
//  HomeViewModel.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/1.
//

import RxRelay

class HomeViewModel {
    static let shared = HomeViewModel()
    private init(){}
    
    var userList: BehaviorRelay<[User]> = BehaviorRelay<[User]>(value: [])
    
    func loadData(completion: VoidCallBack? = nil) {
        IMManager.shared.dbManager?.getUserList { list in
            if let list = list {
                self.userList.accept(self.userList.value + list)
            }
            completion?()
        }
    }
    
    func update(user: User) {
        var list = userList.value
        if let index = list.firstIndex(where: {$0.userId == user.userId}) {
            list.remove(at: index)
        }
        list.insert(user, at: 0)
        userList.accept(list)
    }
}
