//
//  HostManager.swift
//  MOSP
//
//  Created by apple on 2017/11/30.
//

import Foundation

@objcMembers open class HostManager: NSObject {
    public static let hostConfig: HostConfig = {
        let bundleID = Bundle.main.bundleIdentifier ?? ""
        return HostConfig(bundleID)
    }()

    public struct Constrants {
        static let myHost = "com.yilia.host"
        static let myPort = "com.yilia.port"

    }

    public class var baseURL: String {
        if let tmpHost = HostManager.host,
            !tmpHost.isEmpty,
            let tmpPort = HostManager.port,
            !tmpPort.isEmpty {
            return "http://" + tmpHost + ":" + tmpPort + "/interface/"
        } else {
            return "http://www.baidu/interface/"
        }
    }
    /// 主机地址
    public class var host: String? {
        get {
            return YILSettings.shared[Constrants.myHost]
        }
        set(newValue) {
            YILSettings.shared[Constrants.myHost] = newValue ?? nil
        }
    }

    /// 端口
    public class var port: String? {
        get {
            return YILSettings.shared[Constrants.myPort]
        }
        set(newValue) {
            YILSettings.shared[Constrants.myPort] = newValue ?? nil
        }
    }
}
