//
//  TimeInterval+Extensions.swift
//  WeaMap
//
//  Created by Mehdi Silini on 27/02/2024.
//

import Foundation

extension TimeInterval {
    var hourDisplayable: String {
        let formatter = AppUtilities.dateFormatter
        formatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: self + Double(TimeZone.current.secondsFromGMT()))
        return formatter.string(from: date).description
    }
}
