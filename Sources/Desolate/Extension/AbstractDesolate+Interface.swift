//
//  AbstractDesolate+Interface.swift
//  Desolate
//
//  Created by d-exclaimation on 11:40 AM.
//  Copyright © 2021 d-exclaimation. All rights reserved.
//

import Foundation

extension AbstractDesolate {
    /// Receiver function for handling the current state for the behavior
    ///
    /// - Parameter msg: Given message
    internal func receive(_ msg: MessageType) async {
        switch status {
        case .running:
            status = await onMessage(msg: msg)
        case .ignoring(let count):
            let curr = count - 1
            status = curr <= 0 ? .running : .ignoring(count: curr)
        case .stopped:
            break
        }
    }

    /// Method for handling Task within a Behavior `onMessage` using the `pipe pattern`
    ///
    /// - Parameters:
    ///   - task: Task being executed / awaited
    ///   - mapTo: Mapping function to transform result into the behavior message type
    public func pipeToSelf<Success, Failure>(_ task: Task<Success, Failure>, mapTo: (Result<Success, Failure>) -> MessageType) async {
        let res = await task.result
        await receive(mapTo(res))
    }
}