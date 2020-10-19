//
//  Style.swift
//
//  https://itnext.io/semigroups-faf7a70da96a
//

import UIKit

// TODO: consider removing restriction to `UIView`
public struct Style<T: UIView> {
    private let callback: (T) -> Void

    public init(_ callback: @escaping (T) -> Void) {
        self.callback = callback
    }

    public func apply(to view: T) {
        callback(view)
    }

    //static public func compose(_ styles: Style<T>...) -> Style<T> {
    //    return Style { view in
    //        styles.forEach { $0.callback(view) }
    //    }
    //}
}

// MARK: - Semigroup
extension Style: Semigroup {
    public func combine(with other: Style) -> Style {
        return Style {
            self.callback($0)
            other.callback($0)
        }
    }
}

// MARK: - Monoid
extension Style: Monoid {
    public static var empty: Style<T> {
        return .init { _ in }
    }
}

// MARK: - Initializers

extension UIButton {
    public convenience init(style: Style<UIButton>) {
        self.init()
        style.apply(to: self)
    }
}

extension UILabel {
    public convenience init(style: Style<UILabel>) {
        self.init()
        style.apply(to: self)
    }
}
