//
//  PipeableReceiver.swift
//  Desolate
//
//  Created by d-exclaimation on 4:08 PM.
//  Copyright © 2021 d-exclaimation. All rights reserved.
//

import Foundation

/// Receiver for Desolate with converted response
internal class PipeableReceiver<ValueType, ActorType: AbstractDesolate>: Receiver<ValueType> {
    /// inner actors of the reference
    internal let innerActor: ActorType
    internal let transform: (ValueType) -> ActorType.MessageType

    public init(of ref: ActorType, transform fn: @escaping (ValueType) -> ActorType.MessageType) {
        innerActor = ref
        transform = fn
    }

    /// Send a message to the Actor referenced by this Desolate
    /// using `at-most-once` messaging semantics but doesn't wait for finished execution.
    ///
    /// - Parameter msg: Message to be sent
    public override func tell(with msg: ValueType) {
        Task.init { await innerActor.receive(transform(msg)) }
    }

    /// Asynchronously send a message to the Actor referenced by this Desolate using *at-most-once* messaging semantics.
    ///
    /// - Parameter msg: Message to be sent:
    public override func task(with msg: ValueType) async {
        let task = Task {
            await innerActor.receive(transform(msg))
        }
        await task.value
    }
}
