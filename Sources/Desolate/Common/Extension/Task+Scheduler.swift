//
//  Task+Scheduler.swift
//  Desolate
//
//  Created by d-exclaimation on 1:35 AM.
//  Copyright © 2021 d-exclaimation. All rights reserved.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    /// Push back execution of the remainder of the code back to the end of the running executor queue.
    public static func requeue() async {
        try? await Task<Never, Never>.sleep(nanoseconds: 0)
    }

    /// Push back execution of the callback of the code back to the end of the running executor queue.
    public static func nextLoop(_ fn: @escaping AsyncFunction) {
        Task<Void, Never>.detached {
            try? await Task<Never, Never>.sleep(nanoseconds: 0)
            await fn()
        }
    }

    /// Push back execution of the callback of the code back to the end of the running executor queue.
    public static func nextLoop(catching: @escaping AsyncThrowFunction) {
        Task<Void, Never>.init {
            try? await Task<Never, Never>.sleep(nanoseconds: 0)
            try? await catching()
        }
    }
}
