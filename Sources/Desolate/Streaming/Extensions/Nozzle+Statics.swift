//
//  Nozzle+Statics.swift
//  Desolate
//
//  Created by d-exclaimation on 6:40 PM.
//  Copyright © 2021 d-exclaimation. All rights reserved.
//

import Foundation

extension Nozzle {
    /// Create a Nozzle with no value and immediately finishes
    ///
    /// - Returns: Nozzle
    public static func empty() -> Nozzle<Element> {
        let desolate = Nozzle.Current.create()
        defer {
            desolate.tell(with: nil)
        }
        return Nozzle.init(desolate)
    }

    /// Create a Nozzle with only 1 value and then finishes
    ///
    /// - Parameter just: The only value given
    /// - Returns: Nozzle
    public static func single(_ just: Element) -> Nozzle<Element> {
        let desolate = Nozzle.Current.create()
        defer {
            Task.init {
                await desolate.task(with: just)
                await desolate.task(with: nil)
            }
        }
        return Nozzle.init(desolate)
    }

    /// Create a Nozzle with multiple finite value then finishes
    ///
    /// - Parameter elements: Finite elements
    /// - Returns: Nozzle
    public static func of(_ elements: Element...) -> Nozzle<Element> {
        let desolate = Nozzle.Current.create()
        defer {
            Task.init {
                for element in elements {
                    await desolate.task(with: element)
                }
                await desolate.task(with: nil)
            }
        }
        return Nozzle.init(desolate)
    }


    /// Create a Nozzle from an Array of item and then finishes
    ///
    /// - Parameter elements: Array of elements
    /// - Returns: Nozzle
    public static func array(_ elements: [Element]) -> Nozzle<Element> {
        let desolate = Nozzle.Current.create()
        defer {
            Task.init {
                for element in elements {
                    await desolate.task(with: element)
                }
                await desolate.task(with: nil)
            }
        }
        return Nozzle.init(desolate)
    }

    /// Create a Nozzle from a Desolated current, and give both
    ///
    /// - Returns: A Nozzle and its Desolated current
    public static func desolate() -> (Nozzle<Element>, Desolate<Current>) {
        let desolate = Nozzle.Current.create()
        return (Nozzle.init(desolate), desolate)
    }


    /// Emitting builder function
    public typealias Emit = (Element) async -> Void

    /// Closing builder function
    public typealias Close = () async -> Void

    /// Builder function
    public typealias Builder = (Emit, Close) async throws -> Void

    /// Convenience initializer using the Builder
    ///
    /// ```swift
    /// let nozzle = Nozzle { (emit, close) async in
    ///     for i in 0...10 {
    ///         await Task.sleep(1000)
    ///         await emit(i)
    ///     }
    ///     await close()
    /// }
    /// ```
    ///
    /// - Parameter builder: Builder function
    public init(_ builder: @escaping Builder) {
        let curr = Nozzle.Current.create()
        let emit: Emit = { elem in await curr.task(with: elem) }
        let close: Close = { await curr.task(with: nil) }
        defer {
            Task.init {
                try await builder(emit, close)
            }
        }
        self.init(curr)
    }
}