//
//  NSDirectionalEdgeInsets+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 12/1/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import UIKit

extension NSDirectionalEdgeInsets {

    // For naming, refer to:
    // - https://swift.org/documentation/api-design-guidelines
    // - https://swift.org/documentation/api-design-guidelines/#type-conversion

    // For inspiration, see:
    // - https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/SwifterSwift/Shared/EdgeInsetsExtensions.swift
    // - CGRect methods

    // MARK: - Types

    public struct HorizontalInsets: Equatable {
        public let leading: CGFloat
        public let trailing: CGFloat

        public init(leading: CGFloat, trailing: CGFloat) {
            self.leading = leading
            self.trailing = trailing
        }
    }

    public struct VerticalInsets: Equatable {
        public let top: CGFloat
        public let bottom: CGFloat

        public init(top: CGFloat, bottom: CGFloat) {
            self.top = top
            self.bottom = bottom
        }
    }

    // MARK: - Properties

    public var horizontalInsets: HorizontalInsets {
        return HorizontalInsets(leading: leading, trailing: trailing)
    }

    public var verticalInsets: VerticalInsets {
        return VerticalInsets(top: top, bottom: bottom)
    }

    // MARK: - Methods

    public func insetBy(horizontal insets: HorizontalInsets) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: top, leading: insets.leading, bottom: bottom, trailing: insets.trailing)
    }

    public func insetBy(vertical insets: VerticalInsets) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: insets.top, leading: leading, bottom: insets.bottom, trailing: trailing)
    }
}

// MARK: - UIView + Properties
extension UIView {

    public var horizontalMargins: NSDirectionalEdgeInsets.HorizontalInsets {
        get {
            return directionalLayoutMargins.horizontalInsets
        }
        set {
            directionalLayoutMargins = NSDirectionalEdgeInsets(top: directionalLayoutMargins.top,
                                                               leading: newValue.leading,
                                                               bottom: directionalLayoutMargins.bottom,
                                                               trailing: newValue.trailing)
        }
    }

    public var verticalMargins: NSDirectionalEdgeInsets.VerticalInsets {
        get {
            return directionalLayoutMargins.verticalInsets
        }
        set {
            directionalLayoutMargins = NSDirectionalEdgeInsets(top: newValue.top,
                                                               leading: directionalLayoutMargins.leading,
                                                               bottom: newValue.bottom,
                                                               trailing: directionalLayoutMargins.trailing)
        }
    }
}
