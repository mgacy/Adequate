//
//  UIDevice+Ext.swift
//  Adequate
//
//  Created by Mathew Gacy on 8/2/19.
//  Copyright © 2019 Mathew Gacy. All rights reserved.
//

import UIKit

extension UIDevice {

    // https://stackoverflow.com/a/30075200
    var modelIdentifier: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
