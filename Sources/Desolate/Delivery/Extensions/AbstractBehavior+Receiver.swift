//
//  AbstractBehavior+Receiver.swift
//  Desolate
//
//  Created by d-exclaimation on 1:33 PM.
//  Copyright © 2021 d-exclaimation. All rights reserved.
//

import Foundation

extension AbstractDesolate {
    /// Get a Receiver from a AbstractDesolate
    var ref: Receiver<MessageType> {
        DesolateReceiver(of: self)
    }
}