//
//  String+Object.swift
//  MOSP
//
//  Created by apple on 2017/11/11.
//

import Foundation
extension String {
    func toObject<T: Codable>(_ param: T) -> T? {
        do {
            let data = (self as AnyObject).data(using: String.Encoding.utf8.rawValue)
            let obj = try JSONDecoder().decode(T.self, from: data!)
            return obj
        } catch {
            print("解析出错啦：\(error)")
            return nil
        }
    }

    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}
