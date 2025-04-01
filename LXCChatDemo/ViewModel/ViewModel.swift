//
//  ViewModel.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/1.
//

import RxRelay

final class ViewModel<T> {
    let observer: BehaviorRelay<T>
    var value: T {
        get {
            observer.value
        }
        
        set {
            observer.accept(newValue)
        }
    }
    
    init(_ value: T) {
        self.observer = BehaviorRelay(value: value)
    }
}
