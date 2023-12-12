//
//  ContentView.swift
//  NoticeableSquare
//
//  Created by Artyom on 12.12.2023.
//

import SwiftUI

class SquareViewModel: ObservableObject {
    @Published var position = CGPoint(x: 0, y: 0)
}

struct ContentView: View {
    @StateObject var viewModel = SquareViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach([Color.white, Color.pink, Color.yellow, Color.black], id: \.self) { color in
                    Rectangle()
                        .fill(color)
                }
            }
            .ignoresSafeArea()

            DraggableSquare()
                .environmentObject(viewModel)
        }
    }
}

struct DraggableSquare: View {
    @EnvironmentObject var viewModel: SquareViewModel
    @State private var dragTranslation = CGSize.zero

    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.white)
            .compositingGroup()
            .blendMode(.difference)
            .overlay(.blendMode(.hue))
            .overlay(Color.white.blendMode(.overlay))
            .overlay(Color.black.blendMode(.overlay))
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .offset(x: viewModel.position.x + dragTranslation.width, y: viewModel.position.y + dragTranslation.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.dragTranslation = value.translation
                    }
                    .onEnded { value in
                        self.viewModel.position.x += value.translation.width
                        self.viewModel.position.y += value.translation.height
                        self.dragTranslation = CGSize.zero
                    }
            )
    }
}


#Preview {
    ContentView()
}
