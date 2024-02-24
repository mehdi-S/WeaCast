//
//  LoadingView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 23/02/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView(label: {
            Text("Loading")
        })
    }
}

#Preview {
    LoadingView()
}
