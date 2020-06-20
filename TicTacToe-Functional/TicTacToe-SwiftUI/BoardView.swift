//
//  ContentView.swift
//  TicTacToe-SwiftUI
//
//  Created by Joshua Homann on 3/28/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI
import Combine

final class TicTacToeGameViewModel: ObservableObject {
  @Published private(set) var state = State()

  enum Player: String, Hashable {
    case x = "X", o = "O"
  }

  private let tapSubject = PassthroughSubject<(Int, Int), Never>()
  private let resetSubject = PassthroughSubject<Void, Never>()
  private var subscriptions = Set<AnyCancellable>()

  struct State {
    var title = "Player X select a square"
    var board = [[Player?]](repeating: [Player?](repeating: nil, count: 3), count: 3)
    var currentPlayer: Player? = .x
  }

  private static let wins: [[(Int, Int)]] = {
    let columnWins = (0..<3).map { x in (0..<3).map { y in (x,y) } }
    let rowWins = (0..<3).map { y in (0..<3).map { x in (x,y) } }
    let diagonalWins = [[(0,0),(1,1), (2,2)], [(0,2),(1,1),(2,0)]]
    return columnWins + rowWins + diagonalWins
  }()

  init() {
    resetSubject
      .prepend(())
      .map { [tapSubject] _ in
        tapSubject
          .scan(State()) { previousState, tap in
            var state = previousState
            let (x,y) = tap
            guard state.board[x][y] == nil,
              let currentPlayer = state.currentPlayer else {
                return state
            }
            state.board[x][y] = currentPlayer
            let isWon = Self.wins.contains { squares in
              squares.allSatisfy { x,y in state.board[x][y] == currentPlayer }
            }
            let isDraw = !(isWon || state.board.flatMap{$0}.contains {$0 == nil})
            if isWon {
              state.title = "Player \(currentPlayer.rawValue) won!"
              state.currentPlayer = nil
            } else if isDraw {
              state.title = "Its a draw!"
              state.currentPlayer = nil
            } else {
              let nextPlayer: Player = currentPlayer == .x ? .o : .x
              state.title = "Player \(nextPlayer.rawValue) select a square"
              state.currentPlayer = nextPlayer
            }
            return state
        }
        .prepend(State())
      }
      .switchToLatest()
      .assign(to: \.state, on: self)
      .store(in: &subscriptions)
  }

  func reset() {
    resetSubject.send()
  }

  func tap(x: Int, y: Int) {
    tapSubject.send((x, y))
  }
}

struct BoardView: View {
  @ObservedObject var viewModel: TicTacToeGameViewModel = .init()
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
                Button(action: { self.viewModel.tap(x: x, y: y) }) {
                  Color(#colorLiteral(red: 0.9642283818, green: 0.963666524, blue: 0.9630511558, alpha: 1))
                  .cornerRadius(geometry.size.width * 0.24)
                }
                .overlay(
                  Text(board[x][y].map({"\($0.rawValue)"}) ?? "")
                  .font(.system(size: geometry.size.height * 0.95))
                  .foregroundColor(self.color(x: x, y: y))
                )
              }
            }
          }
        }
      }
      .aspectRatio(1.0, contentMode: .fit)
      .padding()
      Button(action: { self.viewModel.reset() }) {
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
