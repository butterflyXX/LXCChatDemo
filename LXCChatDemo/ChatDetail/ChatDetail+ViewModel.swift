//
//  ChatDetail+ViewModel.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/7.
//

import RxRelay

extension ChatDetailViewController {
    class ViewModel {
        
        let user: User
        var messageList: BehaviorRelay<[DAMessage]> = BehaviorRelay<[DAMessage]>(value: [])
        
        init(user: User) {
            self.user = user
        }
        
        func loadData(isFirstLoad: Bool, completion: VoidCallBack? = nil) {
            var date: Double?
            if isFirstLoad {
                date = messageList.value.last?.createTime
            }
            
            IMManager.shared.dbManager?.getMessageList(userId: user.userId, createTime: date) { list in
                if let list = list {
                    self.messageList.accept(self.messageList.value + list)
                }
                completion?()
            }
        }
        
        func add(message: DAMessage) {
            var list = messageList.value
            list.append(message)
            messageList.accept(list)
        }
    }
}
