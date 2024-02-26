//
//  View+Extensions.swift
//  WeaMap
//
//  Created by Mehdi Silini on 24/02/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
}
