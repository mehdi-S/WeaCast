//
//  DelayAppearance.swift
//  WeaMap
//
//  Created by Mehdi Silini on 24/02/2024.
//

import SwiftUI

struct DelayAppearanceModifier: ViewModifier {
    @State var shouldDisplay = false

    let delay: Double

    func body(content: Content) -> some View {
        render(content)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.shouldDisplay = true
                }
            }
    }

    @ViewBuilder
    private func render(_ content: Content) -> some View {
        if shouldDisplay {
            content
        } else {
            content
                .hidden()
        }
    }
}

public extension View {
    func delayAppearance(bySeconds seconds: Double) -> some View {
        modifier(DelayAppearanceModifier(delay: seconds))
    }
}
