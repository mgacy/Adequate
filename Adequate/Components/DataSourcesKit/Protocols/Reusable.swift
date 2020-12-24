//
//  Reusable.swift
//  Adequate
//
//  Based on code from:
//  https://cocoacasts.com/dequeueing-reusable-views-with-generics-and-protocols
//  https://github.com/sergdort/CleanArchitectureRxSwift
//

import UIKit

public protocol Reusable: AnyObject {
    static var reuseID: String {get}
}

extension Reusable {
    public static var reuseID: String {
        return String(describing: self)
    }
}

// MARK: - View Controller

extension UIViewController: Reusable {
    public class func instance() -> Self {
        let storyboard = UIStoryboard(name: reuseID, bundle: nil)
        return storyboard.instantiateViewController()
    }
}

extension UIStoryboard {
    public func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.reuseID) as? T else {
            fatalError("Unable to instantiate view controller: \(T.self)")
        }
        return viewController
    }
}

// MARK: - Collection View

extension UICollectionReusableView: Reusable {}

extension UICollectionView {

    public func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseID)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable collection view cell: \(T.self)")
        }
        return cell
    }

    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T {
        guard let section = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseID,
                                                             for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable supplementary view: \(T.self)")
        }
        return section
    }

}

// MARK: - Table View

extension UITableViewCell: Reusable {}

extension UITableView {

    public func register<T: UITableViewCell>(cellType: T.Type) {
        self.register(cellType.self, forCellReuseIdentifier: cellType.reuseID)
    }

    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable table view cell: \(T.self)")
        }
        return cell
    }

}
