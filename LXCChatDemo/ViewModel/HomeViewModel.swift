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
    
    var userList: BehaviorRelay<[ViewModel<User>]> = BehaviorRelay<[ViewModel<User>]>(value: [])
    
    func loadData(completion: VoidCallBack? = nil) {
        ChatDBManager.shared.getUserList { list in
            if let list = list {
                self.userList.accept(self.userList.value + list.map({
                    let user = ViewModel($0)
                    NSLog("\(user.value.lastMessageTime)")
                    return user
                }))
            }
            completion?()
        }
    }
    
    func insert(user: User) {
        self.userList.accept([ViewModel(user)] + self.userList.value)
    }
    
    func update(index: Int) {
        var list = userList.value
        let user = list.remove(at: index)
        list.insert(user, at: 0)
        userList.accept(list)
    }
}
