//
//  BoardViewController.swift
//  TicTacToe-SwiftUI
//
//  Created by Joshua Homann on 4/19/21.
//  Copyright © 2021 com.josh. All rights reserved.
//

import Combine
import UIKit

final class BoardViewController: UIViewController {
  private var subscriptions = Set<AnyCancellable>()
  private let traitCollectionDidChangePublisher = PassthroughSubject<Void, Never>()
  init(viewModel: TicTacToeGameViewModel) {
    super.init(nibName: nil, bundle: nil)
    view.backgroundColor = .systemBackground
    let vStack = UIStackView(arrangedSubviews:
      viewModel.state.board.indices.map { row in
        let hStack = UIStackView(arrangedSubviews:
          viewModel.state.board.indices.map { column in
            let button = UIButton(primaryAction: .init(handler: { _ in viewModel.tap(x: column, y: row) }))
            button.backgroundColor = #colorLiteral(red: 0.9642283818, green: 0.963666524, blue: 0.9630511558, alpha: 1)
            button.clipsToBounds = true
            button.titleLabel?.textAlignment = .center
            Publishers.CombineLatest(
              button.publisher(for: \.bounds),
              viewModel.$state
                .map(\.board)
                .map { $0[column][row] }
            )
              .sink(receiveValue: { bounds, player in
                UIView.setAnimationsEnabled(false)
                button.setTitle(player?.rawValue ?? "", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: max(bounds.height * 0.95, 12))
                button.layer.cornerRadius = bounds.size.width * 0.24
                button.setTitleColor( player?.color ?? .white, for: .normal)
                UIView.setAnimationsEnabled(true)
              })
              .store(in: &subscriptions)
            return button
          }
        )
        hStack.distribution = .fillEqually
        hStack.spacing = 12
        return hStack
      }
    )
    vStack.axis = .vertical
    vStack.distribution = .fillEqually
    vStack.spacing = 12
    vStack.translatesAutoresizingMaskIntoConstraints = false
    let titleLabel = UILabel()
    titleLabel.textAlignment = .center
    titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    viewModel.$state.map { $0.title as String? }.assign(to: \.text, on: titleLabel).store(in: &subscriptions)
    let resetButton = UIButton(primaryAction: .init(title: "Reset",  handler: { _ in viewModel.reset() }))
    let topSpacer = UIView()
    topSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
    let bottomSpacer = UIView()
    bottomSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
    let stack = UIStackView(arrangedSubviews: [
      topSpacer,
      titleLabel,
      vStack,
      resetButton,
      bottomSpacer
    ])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 12
    view.addSubview(stack)
    let verticalDimensionConstraint = stack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -24)
    let horizontalDimensionConstraint = stack.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -24)
    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      verticalDimensionConstraint,
      vStack.widthAnchor.constraint(equalTo: vStack.heightAnchor),
      topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor)
    ])
    view.publisher(for: \.traitCollection).sink(receiveValue: { trait in
      print("trait \(trait)")
    })
    .store(in: &subscriptions)
    traitCollectionDidChangePublisher
      .compactMap { [view] _ in view?.bounds.size }
      .sink(receiveValue: { size in
        let isHorizontal = size.width > size.height
        verticalDimensionConstraint.isActive = !isHorizontal
        horizontalDimensionConstraint.isActive = isHorizontal
      })
      .store(in: &subscriptions)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    traitCollectionDidChangePublisher.send()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension TicTacToeGameViewModel.Player {
  var color: UIColor {
    self == .x ? #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
  }
}
