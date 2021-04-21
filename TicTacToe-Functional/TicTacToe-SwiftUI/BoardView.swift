//
//  ContentView.swift
//  TicTacToe-SwiftUI
//
//  Created by Joshua Homann on 3/28/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI
import Combine

struct BoardView: View {
  @StateObject private var viewModel: TicTacToeGameViewModel = .init()
  var body: some View {
    let board = viewModel.state.board
    let title = viewModel.state.title
    return VStack {
      Text(title)
      VStack {
        ForEach (board.indices) { y in
          HStack {
            ForEach (board[y].indices) { x in
              GeometryReader { geometry in
                Button(action: { viewModel.tap(x: x, y: y) }) {
                  Color(#colorLiteral(red: 0.9642283818, green: 0.963666524, blue: 0.9630511558, alpha: 1))
                  .cornerRadius(geometry.size.width * 0.24)
                }
                .overlay(
                  Text(board[x][y].map({"\($0.rawValue)"}) ?? "")
                  .font(.system(size: geometry.size.height * 0.95))
                  .foregroundColor(color(x: x, y: y))
                )
              }
            }
          }
        }
      }
      .aspectRatio(1.0, contentMode: .fit)
      .padding()
      Button(action: { viewModel.reset() }) {
        Text("Reset")
      }
    }
  }

  private func color(x: Int, y: Int) -> Color {
    Color(viewModel.state.board[x][y].map { $0 == .x ? #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) } ?? .clear)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    BoardView()
  }
}
