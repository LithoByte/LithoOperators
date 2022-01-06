//
//  LithoOperators.swift
//  LithoOperators
//
//  Created by Elliot Schrock on 10/12/19.
//

import Prelude

/**
 This operator is from the excellent PointFree videos, allowing you to compose a function `(A) -> B` with another function `(B) -> C` to create a new function `(A) -> C`. This is simply an overload of the operator to allow functions that do not take parameters to be the composed function, as well as functions that take multiple parameters to be the composing function.
 */

public func >>> <U, V> (f: @escaping () -> U, g: @escaping (U) -> V) -> () -> V {
    return { g(f()) }
}

/**
 This operator allows you to chain functions where optionality is an issue. For instance,
 suppose you had a function `f` which output a `String?` and another function `g` which only
 accepts a `String`; trying to use `f >>> g` would fail to compile, since you can't pass `nil`
 to `g`. By using `f >?> g`, however, will compile, since this operator only executes `g` if
 `f` returns a non-`nil` value. This is really nice paired with `optionalCast` defined below,
 which will try to cast an object for you. So for instance, suppose you had a function `f` from
 `(UIButton) -> Void` but wanted to be able to apply it intelligently to any `UIView` passed
 in; then you could do `optionalCast >?> f` and the compiler would return a function from
 `UIView -> Void` which, if the UIView is a `UIButton` in particular, would apply `f` to it.
 */

//TESTED
infix operator >?>: Composition
public func >?><A, B, C>(f: @escaping (A) -> B?, g: @escaping (B) -> C) -> (A) -> C? {
    return { a in
        if let b = f(a) {
            return g(b)
        } else {
            return nil
        }
    }
}
public func >?><A, B, C>(f: @escaping (A) -> B?, g: ((B) -> C)?) -> (A) -> C? {
    return { a in
        if let b = f(a) {
            return g?(b)
        } else {
            return nil
        }
    }
}
public func >?><A, B, C>(f: @escaping (A) -> B?, g: @escaping (B) -> C?) -> (A) -> C? {
    return { a in
        if let b = f(a) {
            return g(b)
        } else {
            return nil
        }
    }
}
public func >?><A, B, C, D>(f: @escaping (A, B) -> C?, g: @escaping (C) -> D) -> (A, B) -> D? {
    return { a, b in
        if let c = f(a, b) {
            return g(c)
        } else {
            return nil
        }
    }
}
public func >?><A, B, C, D>(f: @escaping (A, B) -> C?, g: @escaping (C) -> D?) -> (A, B) -> D? {
    return { a, b in
        if let c = f(a, b) {
            return g(c)
        } else {
            return nil
        }
    }
}
public func >?><A, B>(f: @escaping (A) -> B?, g: @escaping (B) -> Void) -> (A) -> Void {
    return { a in
        if let b = f(a) {
            g(b)
        }
    }
}
public func >?><A, B>(f: @escaping (A) -> B?, g: ((B) -> Void)?) -> (A) -> Void {
    return { a in
        if let b = f(a) {
            g?(b)
        }
    }
}
public func >?><A, B, C>(f: @escaping (A, B) -> C?, g: @escaping (C) -> Void) -> (A, B) -> Void {
    return { a, b in
        if let c = f(a, b) {
            g(c)
        }
    }
}
public func >?><A, B, C, D>(f: @escaping (A, B, C) -> D?, g: @escaping (D) -> Void) -> (A, B, C) -> Void {
    return { a, b, c in
        if let d = f(a, b, c) {
            g(d)
        }
    }
}

/**
 This operator allows you to pass a tuple of a function's argument types instead of
 manually decomposing the tuple's values. So, `f(a, b)` == `(~f)((a,b))`. This is useful when
 a function outputs a tuple that you want to pass to a regular function. So suppose `g`
 is a function from `(T) -> (A, B)`; then the following would not compile: `g >>> f` while the
 following would: `g >>> ~f`. NOTE: I haven't checked this recently, Swift may have added
 support for doing this without this operator.
 */
prefix operator ~
public prefix func ~<A, B, C>(f: @escaping (A, B) -> C) -> ((A, B)) -> C {
    return { (tuple: (A, B)) -> C in
        return f(tuple.0, tuple.1)
    }
}
public prefix func ~<A, B, C, D>(f: @escaping (A, B, C) -> D) -> ((A, B, C)) -> D {
    return { (tuple: (A, B, C)) -> D in
        return f(tuple.0, tuple.1, tuple.2)
    }
}
public prefix func ~<A, B, C>(f: @escaping ((A, B)) -> C) -> (A, B) -> C {
    return { a, b in
        f((a, b))
    }
}
public prefix func ~<A, B, C, D>(f: @escaping ((A, B, C)) -> D) -> (A, B, C) -> D {
    return { a, b, c in
        f((a, b, c))
    }
}

/**
 This is basically an operator version of `union`, see below.
 */
//TESTED
infix operator <>: AdditionPrecedence
public func <><A>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
    }
}

/**
 Operator version of `union`, although it tacks on the second function onto the first (similar to +=)
 */
infix operator <>=: AssignmentPrecedence
public func <>=<A>(f: inout ((A) -> Void), g: @escaping (A) -> Void) {
    f = f <> g
}
public func <>=<A, B>(f: inout ((A, B) -> Void), g: @escaping (A, B) -> Void) {
    f = union(f, g)
}
public func <>=<A>(f: inout ((A) -> Void)?, g: @escaping (A) -> Void) {
    f = f == nil ? g : f! <> g
}
public func <>=<A, B>(f: inout ((A, B) -> Void)?, g: @escaping (A, B) -> Void) {
    f = f == nil ? g : union(f!, g)
}
public func <>=<A>(f: inout ((A) -> Void), g: ((A) -> Void)?) {
    if let g = g {
        f = f <> g
    }
}
public func <>=<A, B>(f: inout ((A, B) -> Void), g: ((A, B) -> Void)?) {
    if let g = g {
        f = union(f, g)
    }
}
public func <>=<A>(f: inout ((A) -> Void)?, g: ((A) -> Void)?) {
    if let g = g {
        f = f == nil ? g : f! <> g
    }
}
public func <>=<A, B>(f: inout ((A, B) -> Void)?, g: ((A, B) -> Void)?) {
    if let g = g {
        f = f == nil ? g : union(f!, g)
    }
}

//allows mutating A, as opposed to <>
infix operator <~>: AdditionPrecedence
public func <~><A>(f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> (inout A) -> Void {
    return { a in
        f(&a)
        g(&a)
    }
}

//allows mutating A, as opposed to |>
infix operator />: ForwardApplication
public func /><A>(a: inout A, f: @escaping (inout A) -> Void) -> Void {
    f(&a)
}
