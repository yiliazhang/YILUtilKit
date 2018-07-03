//
//  HostConfig.swift
//  MOSP
//
//  Created by apple on 2017/12/1.
//

import Foundation
protocol HostProtocol {
    static var name : String {get}
    static var url : String {get}
    static var updateAppName : String {get}
    static var bundleID : String {get}
    static var appKey : String {get}
    static var qrCodeImageName : String {get}
    static func test()
    static func testOne() -> Self
}
/// 是否为 测试模式 true：测试环境 | false: 正式环境
public var appTestMode = false


/// 是否 显示选择列表（符合 bundle ID 的注解列表）
private var _appShowHostConfigMenu = false
public var appShowHostConfigMenu: Bool {
    get {
        if !appTestMode {
            return false
        }
        return _appShowHostConfigMenu
    }
    set {
        _appShowHostConfigMenu = newValue
    }
}

public  enum HostConfig : String {
    case jiangSu = "com.bjdv.mos.jscn"
    case linYi = "com.bjdv.mos.ly"
    case riZhao = "com.bjdv.mosp.rz"
    case heBei = "com.bjdv.HeBei.MOSP"
    case deZhou = "com.bjdv.mos.dz"
    case maAnShan = "com.bjdv.mos.pt"
    static var cases : [HostConfig] = [jiangSu, linYi, riZhao, heBei, deZhou, maAnShan]

    init!(_ ix:Int, testMode: Bool = false, showHostConfigMenu: Bool = false) {
        if !(0...5).contains(ix) {
            return nil
        }
        self = HostConfig.cases[ix]
        appTestMode = testMode
        appShowHostConfigMenu = showHostConfigMenu
    }

    init!(_ rawValue:String, testMode: Bool = false, showHostConfigMenu: Bool = false) {
        self.init(rawValue:rawValue)
        appTestMode = testMode
        appShowHostConfigMenu = showHostConfigMenu
    }

    public var description : String { return self.rawValue }

    mutating func advance() {
        var ix = HostConfig.cases.index(of: self)!
        ix = (ix + 1) % 4
        self = HostConfig.cases[ix]
    }

    ///  更新对应的 appName
    public var updateName: String {
        switch self {
        case .heBei:
            return "HeBei"
        case .jiangSu:
            return "JSCN"
        case .linYi:
            return "LinYi"
        case .riZhao:
            return "RiZhao"
        case .deZhou:
            return "DeZhou"
        case .maAnShan:
            return "mas-mos-ios"
        }
    }

    /// 推送 appkey
    public var appKey: String {

        switch self {
        case .heBei:
            return "54b437b16c13caa0539da30d"
        case .jiangSu:
            return "esxROllgufLRAGeYYsxlrfb9"
        case .linYi:
            return "8988830b879fd39f17de31f2"
        case .riZhao:
            return "93c3a46a8518d8aa9296bb5f"
        case .deZhou:
            return "04a257c9dd1680ea1bf0b4a8"
        case .maAnShan:
            return "SqUAYktrmXlRUxls9uqWb9vb"
        }

    }

    /// qrCodeImageName
    public var qrCodeImageName: String {

        switch self {
        case .heBei:
            return "qr_code_heBei"
        case .jiangSu:
            return "qrcode_jscn"
        case .linYi:
            return "qr_code_linYi"
        case .riZhao:
            return "RiZhao"
        case .deZhou:
            return "qr_code_deZhou"
        case .maAnShan:
            return "qrcode_mas"
        }

    }

    /// company
    public var company: String {

        switch self {
        case .heBei:
            return ""
        case .jiangSu:
            return "江苏省信息网络股份有限公司"
        case .linYi:
            return "山东临沂分公司"
        case .riZhao:
            return "山东日照分公司"
        case .deZhou:
            return "山东德州分公司"
        case .maAnShan:
            return "中广马鞍山分公司"
        }

    }

    /// company
    public var appTestModeName: String {

        switch self {
        case .heBei:
            return appTestMode ? "河北测试环境" : "河北正式环境"
        case .jiangSu:
            return appTestMode ? "江苏正式环境" : "江苏测试环境"
        case .linYi:
            return appTestMode ? "临沂测试环境" : "临沂正式环境"
        case .riZhao:
            return appTestMode ? "日照测试环境" : "日照正式环境"
        case .deZhou:
            return appTestMode ? "德州无锡测试环境" :"德州正式环境"
        case .maAnShan:
            return appTestMode ? "马鞍山正式环境" : "马鞍山测试环境"
        }
    }

    /// url
    public var url: String {
        switch self {
        case .heBei:
            return appTestMode ? "" : ""
        case .jiangSu:
            return appTestMode ? "JSCN" : "http://baidu/mobile/webservice/commonRs/"
        case .linYi:
            return appTestMode ? "测试 url" : "http://baidu/OSS/webservice/commonRs/"
        case .riZhao:
            return appTestMode ? "RiZhao" : "http://baidu/OSS/webservice/commonRs/"
        case .deZhou:
            return appTestMode ? "测试 url" : "http://baidu/OSS/webservice/commonRs/"
        case .maAnShan:
            return appTestMode ? "maAnShan" : "http://baidu/OSS/webservice/commonRs/"
        }
    }
}
