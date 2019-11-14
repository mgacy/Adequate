//
//  RouterType.swift
//  Adequate
//
//  https://github.com/imaccallum/CoordinatorKit
//

import UIKit

public protocol RouterType: Presentable {
    //var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }

    func present(_ module: Presentable, animated: Bool)
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func popModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func setRootModule(_ module: Presentable, hideBar: Bool)
    func setRootModule(_ module: Presentable, navBarStyle: NavBarStyle)
    func popToRootModule(animated: Bool)
}
