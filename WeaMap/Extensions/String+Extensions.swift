//
//  String+Extensions.swift
//  WeaMap
//
//  Created by Mehdi Silini on 24/02/2024.
//

import Foundation

extension String {
    static func placeholder(_ length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }
}
