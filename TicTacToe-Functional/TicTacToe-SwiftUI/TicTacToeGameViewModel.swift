//
//  TicTacToeGameViewModel.swift
//  TicTacToe-SwiftUI
//
//  Created by Joshua Homann on 4/19/21.
//  Copyright © 2021 com.josh. All rights reserved.
//

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
