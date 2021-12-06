//
//  Date+Extension.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/06.
//

import Foundation

enum TapRecoDateFormat: String {
    case yyyyMMddHHmmssSlash = "yyyy/MM/dd HH:mm:ss"
    case yyyyMMddHHmmPeriod = "yyyy.MM.dd HH:mm"
    case yyyyMdHHmmPeriod = "yyyy.M.d HH:mm"
    case yyyyMdPeriod = "yyyy.M.d"
    case yyyyMMddPeriod = "yyyy.MM.dd"
    case yyyyMMddSlash = "yyyy/MM/dd"
    case MMddHHmm = "MMddHHmm"
    case MdPeriod = "M.d"
    case dMMM = "dMMM"
}

extension Date {
    init?(format: TapRecoDateFormat, date: String) {
        self.init(format: format.rawValue, date: date)
    }

    func toString(format: TapRecoDateFormat) -> String {
        return self.toString(format: format.rawValue)
    }
    
    /// 時分秒が00:00:00のDateを生成し返す。
    ///
    /// - Returns:
    ///   - 時分秒が00:00:00のDateのインスタンス
    var startOfDay: Date {
        return Calendar(identifier: .gregorian).startOfDay(for: self)
    }

    /// 年を返す。
    var year: Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.year, from: self)
    }

    /// 月を返す
    var month: Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.month, from: self)
    }

    /// 日を返す
    var day: Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.day, from: self)
    }

    /// 指定したフォーマットの日付けの文字列からDateを生成し返す。
    /// formatを指定しない場合デフォルトのformatが適用される
    ///
    /// - Parameters:
    ///   - format: フォーマット
    ///   - date: 日付けの文字列
    /// - Returns:
    ///   - Dateのインスタンス
    init?(format: String, date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: date) else {
            return nil
        }
        self = date
    }

    /// 指定したフォーマットの文字列を生成し返す。
    /// formatを指定しない場合デフォルトのformatが適用される
    ///
    /// - Parameters:
    ///   - format: フォーマット
    /// - Returns:
    ///   - 生成された文字列
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }

    func getDate(daysAgo: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -daysAgo, to: self) ?? self
    }
}

extension DateFormatter {
    static func dateFormat(fromTemplate: TapRecoDateFormat) -> String {
        return DateFormatter.dateFormat(fromTemplate: fromTemplate.rawValue, options: 0, locale: Locale(identifier: "ja_JP"))!
    }
}
