//
//  ErrorView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 24/02/2024.
//

import SwiftUI

struct ErrorView: View {
    @State var error: Error
    @State var asyncOnTap: () async -> Void
    
    var body: some View {
        ContentUnavailableView(label: {
            Label {
                Text(error.localizedDescription)
                    .font(.subheadline)
            } icon: {
                Image(systemName: "exclamationmark.icloud.fill")
            }
        }, description: {
            Text("Verify your connection and retry")
        }, actions: {
            Button {
                retry {
                    await asyncOnTap()
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    Text("Retry")
                    Image(systemName: "arrow.clockwise")
                }.padding(2)
            }
            .buttonStyle(.bordered)
            .tint(.blue)
        })
    }
    
    func retry(_ action: @escaping () async -> Void) {
        Task {
            await action()
        }
    }
}

#Preview {
    ErrorView(error: NetworkError.badUrl) {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
