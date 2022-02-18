//
//  Weak.swift
//  LithoOperators
//
//  Created by Calvin Collins on 2/18/22.
//

import Foundation
import Prelude

infix operator ?*>: AdditionPrecedence

public func ?*><T: NSObject, U>(t: T, f: @escaping (T) -> U) -> () -> U? {
    return { [weak t] in
        t ?> f
    }
}

infix operator ?*->: AdditionPrecedence
public func ?*-><T, U, V>(t: T, f: @escaping (T, U) -> V) -> (U) -> V? where T: NSObject {
    return { [weak t] u in
        t ?> (u -*> f)
    }
}

infix operator ?-*>: AdditionPrecedence
public func ?-*><T, U, V>(u: U, f: @escaping (T, U) -> V) -> (T) -> V? where U: NSObject {
    return { [weak u] t in
        u ?> (t *-> f)
    }
}

infix operator ?*-->: AdditionPrecedence
public func ?*--><T, U, V, W>(t: T, f: @escaping (T, U, V) -> W) -> (U, V) -> W? where T: NSObject {
    return { [weak t] u, v in
        t ?> ((u, v) -**> f)
    }
}

infix operator ?-*->: AdditionPrecedence
public func ?-*-><T, U, V, W>(u: U, f: @escaping (T, U, V) -> W) -> (T, V) -> W? where U: NSObject {
    return { [weak u] t, v in
        u ?> ((v, t) **-> shiftRight(f))
    }
}

infix operator ?--*>: AdditionPrecedence
public func ?--*><T, U, V, W>(v: V, f: @escaping (T, U, V) -> W) -> (T, U) -> W? where V: NSObject {
    return { [weak v] t, u in
        v ?> ((t, u) **-> f)
    }
}
