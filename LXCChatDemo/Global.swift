//
//  Global.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/28.
//

import Foundation

typealias ValueChanged<T> = (T) -> Void

typealias VoidCallBack = () -> Void

func run(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}
