//
//  AsyncImageBuilder.swift
//  WeaMap
//
//  Created by Mehdi Silini on 24/02/2024.
//

import SwiftUI

struct AsyncImageBuilder: View {
    var url: URL?
    
    var body: some View {
        VStack {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 60)
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                case .failure:
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .foregroundStyle(.secondary)
                        .frame(width: 60, height: 60)
                @unknown default:
                    // Since the AsyncImagePhase enum isn't frozen,
                    // we need to add this currently unused fallback
                    // to handle any new cases that might be added
                    // in the future:
                    EmptyView()
                        .frame(width: 60, height: 60)
                }
            }
        }
    }
}

#Preview {
    AsyncImageBuilder(url: URL(string: "https://openweathermap.org/img/wn/01d@2x.png")!)
}
