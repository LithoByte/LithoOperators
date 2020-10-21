//
//  LithoOperators.swift
//  LithoOperators
//
//  Created by Elliot Schrock on 10/12/19.
//

import Prelude

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
public func >?><A, B, C>(f: @escaping (A) -> B?, g: @escaping (B) -> C?) -> (A) -> C? {
    return { a in
        if let b = f(a) {
            return g(b)
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

/**
 This is basically an operator version of `union`, see below.
 */
infix operator <>: AdditionPrecedence
public func <><A>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
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

/**
 This is basically an operator for currying. It puts the value `a` into the first postion of a function `f`
 from `(A, B) -> C` and returns a function that just accepts a value for `B`. In Prelude this would
 be `a |> curry(f)`.
 */
infix operator >|>: AdditionPrecedence
public func >|><A, B, C>(a: A, f: @escaping (A, B) -> C) -> (B) -> C {
    return { b in f(a, b) }
}

/**
 Similar to `>|>`, but with the second value. So consider `f: (A, B) -> C`. Then `b >||> f`
 will put `b` into the second argument of `f` and return a function from `A -> C`. I find this more
 ergonmic than using `curry` in this case, since I don't need to swap the arguments around or anything.
 The use case for this is mostly with the free `map` function defined below, so for instance, if you had
 a function `f` from `Int -> String` and wanted to use it to change an array of `Int`s to `String`s,
 you could do so by saying: `f >||> map` which would return a function from `[Int] -> [String]`
 */
infix operator >||>: AdditionPrecedence
public func >||><A, B, C>(b: B, f: @escaping (A, B) -> C) -> (A) -> C {
    return { a in f(a, b) }
}

//Similar to the above two, but with more arguments...
infix operator >|||>: AdditionPrecedence
public func >|||><A, B, C, D>(c: C, f: @escaping (A, B, C) -> D) -> (A, B) -> D {
    return { a, b in f(a, b, c) }
}

//...and so on.
infix operator >||||>: AdditionPrecedence
public func >||||><A, B, C, D, E>(d: D, f: @escaping (A, B, C, D) -> E) -> (A, B, C) -> E {
    return { a, b, c in f(a, b, c, d) }
}

//...and so on...
infix operator >|||||>: AdditionPrecedence
public func >|||||><A, B, C, D, E, F>(e: E, f: @escaping (A, B, C, D, E) -> F) -> (A, B, C, D) -> F {
    return { a, b, c, d in f(a, b, c, d, e) }
}

//...and so on.
infix operator >||||||>: AdditionPrecedence
public func >||||||><A, B, C, D, E, F, G>(eff: F, f: @escaping (A, B, C, D, E, F) -> G) -> (A, B, C, D, E) -> G {
    return { a, b, c, d, e in f(a, b, c, d, e, eff) }
}

/**
 An operator to create a function that, given a keypath for a type, will a function that will accept
 an object of that type and return the object's property's value. So for instance,
 `^\UIViewController.view` will return a function `(UIViewController) -> UIView`
 */
prefix operator ^
public prefix func ^ <Root, Value>(kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return get(kp)
}
public prefix func ^ <Root, Value>(kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {

    return prop(kp)
}
public prefix func ^ <Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (inout Value) -> Void)
    -> (inout Root) -> Void {

    return { update in
      { root in
        update(&root[keyPath: kp])
      }
    }
}

//higher order functions

/**
 Here, `union` will take a bunch of functions and return a function that, when called, will
 call each of those functions in the bunch. I use this mostly for UI styling, so for instance,
 for two functions called `setClipsToBounds` and `setGrayBackground` both of
 which are from `UIView -> Void`, then you could create a new function called, say,
 `clipAndGrayBg = union(setClipsToBounds, setGrayBackground)`.
 */
public func union(_ functions: (() -> Void)...) -> () -> Void {
    return {
        for f in functions {
            f()
        }
    }
}

public func union<T>(_ functions: ((T) -> Void)...) -> (T) -> Void {
    return { (t: T) in
        for f in functions {
            f(t)
        }
    }
}

public func union<T, U>(_ functions: ((T, U) -> Void)...) -> (T, U) -> Void {
    return { (t: T, u: U) in
        for f in functions {
            f(t, u)
        }
    }
}

public func union<T, U, V>(_ functions: ((T, U, V) -> Void)...) -> (T, U, V) -> Void {
    return { (t: T, u: U, v: V) in
        for f in functions {
            f(t, u, v)
        }
    }
}

/**
 This just returns a function that can be called without arguments at a later time with the passed in value
 prepopulated. I often use this when a reusable component shouldn't know the passed in type, but needs
 to pass it to other code when an action occurs.
 */
public func voidCurry<T, U>(_ t: T, _ f: @escaping (T) -> U) -> () -> U {
    return { f(t) }
}

// Operator version of `voidCurry`
infix operator *>: MultiplicationPrecedence
public func *><T, U>(t: T, f: @escaping (T) -> U) -> () -> U {
    return { return f(t) }
}

/**
 Sometimes you don't care about the second argument of a function. I use this, for instance, in
 functional versions of `UIViewController`, where I have a function `f` from
 `UIViewController -> Void` that I want to pass into a property called
 `onViewDidAppear: (UIViewController, Bool) -> Void` which is a function I call in
 `viewDidAppear`. The `Bool` is just whether the appearance was animated or not;
 `f` doesn't care if it was animated, it only cares about the controller, so I could say:
 `vc.onViewDidAppear = ignoreSecondArg(f)`
 */
public func ignoreSecondArg<T, U, V>(f: @escaping (T) -> V) -> (T, U) -> V {
    return { t, _ in
        return f(t)
    }
}

/** 
 See ignoreSecondArg above. Similar functionality except ignore the first argument of a function instead
 of the second.
*/
public func ignoreFirstArg<T,U,V>(f: @escaping (U) -> V) -> (T,U) -> V {
    return { _, u in
        return f(u)
    }
}

public func ignoreArg<T, U>(_ f: @escaping () -> U) -> (T) -> U {
    return { _ in return f() }
}

public func ignoreArgs<T, U, Z>(_ f: @escaping () -> Z) -> (T, U) -> Z {
    return { _, _ in return f() }
}
public func ignoreArgs<T, U, V, Z>(_ f: @escaping () -> Z) -> (T, U, V) -> Z {
    return { _, _, _ in return f() }
}
public func ignoreArgs<T, U, V, W, Z>(_ f: @escaping () -> Z) -> (T, U, V, W) -> Z {
    return { _, _, _, _ in return f() }
}
public func ignoreArgs<T, U, V, W, X, Z>(_ f: @escaping () -> Z) -> (T, U, V, W, X) -> Z {
    return { _, _, _, _, _ in return f() }
}
public func ignoreArgs<T, U, V, W, X, Y, Z>(_ f: @escaping () -> Z) -> (T, U, V, W, X, Y) -> Z {
    return { _, _, _, _, _, _ in return f() }
}

public func returnValue<T>(_ value: T) -> () -> T {
    return { return value }
}

/**
 This function executes `f` if the value passed in is non-`nil`. Convenient when you have
 a function that accepts only non-optional values, but you have an unwrapped variable. Basically,
 this function unwraps optionals for you.
 */
public func ifExecute<T>(_ t: T?, _ f: (T) -> Void) {
    if let t = t {
        f(t)
    }
}
public func ifExecute<T, U>(_ t: T?, _ f: (T) -> U) -> U? {
    if let t = t {
        return f(t)
    }
    return nil
}

// This is just an operator version of `ifExecute`.
infix operator ?>: MultiplicationPrecedence
public func ?><T, U>(t: T?, f: (T) -> U) -> U? {
    if let t = t {
        return f(t)
    }
    return nil
}
public func ?><T>(t: T?, f: (T) -> Void) {
    if let t = t {
        f(t)
    }
}

// function version of the nil coalescing operator `??`
public func coalesceNil<T>(with defaultValue: T) -> (T?) -> T {
    return { t in
        return t ?? defaultValue
    }
}

/**
 This function passes itself to the given function if the condition is true. I don't use it much in iOS, but
 it's pretty helpful in Vapor when creating database queries.
 */
public protocol ConditionalApply {}
extension ConditionalApply {
    public func ifApply(_ condition: Bool, _ function: (Self) -> Self) -> Self {
        if condition {
            return function(self)
        } else {
            return self
        }
    }
}

//other functions

// returns the first element of an array if it exists
public func firstElement<T>(_ array: [T]) -> T? {
    return array.first
}

// A free function version of `map`.
public func map<U, V>(array: [U], f: (U) -> V) -> [V] {
    return array.map(f)
}

// A free function version of `compactMap`.
public func compactMap<U, V>(array: [U], f: (U) -> V?) -> [V] {
    return array.compactMap(f)
}

// Allows you to transform arrays using keypaths
public extension Sequence {
  func map<Value>(_ kp: KeyPath<Element, Value>) -> [Value] {
    return self.map { $0[keyPath: kp] }
  }
  
  func compactMap<Value>(_ kp: KeyPath<Element, Value?>) -> [Value] {
    return self.compactMap { $0[keyPath: kp] }
  }
}

// free function version of `map` with keypaths.
public func map<Element, Value>(array: [Element], _ kp: KeyPath<Element, Value>) -> [Value] {
    return array.map(kp)
}

// free function version of `compactMap` with keypaths.
public func compactMap<Element, Value>(array: [Element], _ kp: KeyPath<Element, Value?>) -> [Value] {
    return array.compactMap(kp)
}

/**
 This function zips together the outputs of functions into a tuple. Very convenient when creating a view from a single model while
 keeping the two decoupled.
 */
public func fzip<T, U, V>(_ f: @escaping (T) -> U, _ g: @escaping (T) -> V) -> (T) -> (U, V) {
    return { t in
        return (f(t), g(t))
    }
}
public func fzip<T, U, V, W>(_ f: @escaping (T) -> U, _ g: @escaping (T) -> V, _ h: @escaping (T) -> W) -> (T) -> (U, V, W) {
    return { t in
        return (f(t), g(t), h(t))
    }
}
public func fzip<T, U, V, W, S>(_ f: @escaping (T) -> U, _ g: @escaping (T) -> V, _ h: @escaping (T) -> W, _ j: @escaping (T) -> S) -> (T) -> (U, V, W, S) {
    return { t in
        return (f(t), g(t), h(t), j(t))
    }
}

/**
 This is a really nice function that will cast objects for you. When paired with `>?>` the compiler will
 be able to tell what type to cast to without you saying explicitly.
 */
public func optionalCast<T, U>(object: T) -> U? {
    return object as? U
}

/**
 The following are from the excellent PointFree videos, and are used here and there above to
 implement some of functions.
 */
public func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {

    return { update in
      { root in
        var copy = root
        copy[keyPath: kp] = update(copy[keyPath: kp])
        return copy
      }
    }
}

public func prop<Root, Value>(
  _ kp: WritableKeyPath<Root, Value>,
  _ f: @escaping (Value) -> Value
  )
  -> (Root) -> Root {

    return prop(kp)(f)
}

public func prop<Root, Value>(
  _ kp: WritableKeyPath<Root, Value>,
  _ value: Value
  )
  -> (Root) -> Root {

    return prop(kp) { _ in value }
}

public typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

public func over<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ set: @escaping (A) -> B
  )
  -> (S) -> T {
    return setter(set)
}

public func set<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ value: B
  )
  -> (S) -> T {
    return over(setter) { _ in value }
}

public func set<Root, Value>(_ kp: WritableKeyPath<Root, Value>, _ value: Value) -> (Root) -> Void {
    return {
        var copy = $0
        copy[keyPath: kp] = value
    }
}

public func get<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return { root in
    root[keyPath: kp]
  }
}

public typealias MutableSetter<S, A> = (@escaping (inout A) -> Void) -> (inout S) -> Void

public func mver<S, A>(
  _ setter: MutableSetter<S, A>,
  _ set: @escaping (inout A) -> Void
  )
  -> (inout S) -> Void {
    return setter(set)
}

public func mut<S, A>(
  _ setter: MutableSetter<S, A>,
  _ value: A
  )
  -> (inout S) -> Void {
    return mver(setter) { $0 = value }
}

public func mutEach<A>(_ f: @escaping (inout A) -> Void) -> (inout [A]) -> Void {
  return {
    for i in $0.indices {
      f(&$0[i])
    }
  }
}
