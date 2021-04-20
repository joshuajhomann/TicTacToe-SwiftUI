//
//  ContentView.swift
//  Emoji Publisher
//
//  Created by Joshua Homann on 6/18/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {

  @Published private(set) var emoji = "A"

  private var subscriptions = Set<AnyCancellable>()
  private var emojiIndexSubject = CurrentValueSubject<Int, Never>(0)

  init() {

    emojiIndexSubject
      .map { index in
        Self.makeEmojiPublisher(interval: 10.0/TimeInterval(Emojis.all[index].count), emojis: Emojis.all[index])
      }
      .switchToLatest()
      .assign(to: \.emoji, on: self)
      .store(in: &subscriptions)
  }

  func increment() {
    changeIndex(delta: 1)
  }

  func decrement() {
    changeIndex(delta: -1)
  }

  private func changeIndex(delta: Int) {
    let newIndex = (emojiIndexSubject.value + delta + Emojis.all.count) % Emojis.all.count
    emojiIndexSubject.send(newIndex)
  }



  private static func makeEmojiPublisher(interval: TimeInterval, emojis: String) -> AnyPublisher<String, Never> {
    Timer
    .publish(every: interval, on: .main, in: .common)
    .autoconnect()
    .map { _ in 1 }
    .scan (0, +)
    .map { $0 % emojis.count }
    .prepend(0)
    .map { index in
      String(emojis[emojis.index(emojis.startIndex, offsetBy: index)])
    }
    .eraseToAnyPublisher()
  }

}

struct ContentView: View {
  @ObservedObject var viewModel: ViewModel = .init()
  var body: some View {
    HStack {
      Stepper(
        onIncrement: {self.viewModel.increment()},
        onDecrement: {self.viewModel.decrement()},
        label: { EmptyView() }
      )
      .fixedSize()
      Text(self.viewModel.emoji)
      .font(.system(size: 128))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

enum Emojis {
  static let smilies = "😀😃😄😁😆😅😂🤣☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🤩🥳😏😒😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤬🤯😳🥵🥶😱😨😰😥😓🤗🤔🤭🤫🤥😶😐😑😬🙄😯😦😧😮😲🥱😴🤤😪😵🤐🥴🤢🤮🤧😷🤒🤕🤑🤠"
  static let fantasy = "🦸🏻🦸🏻‍♂️🦸🏻‍♀️🦹🏻🦹🏻‍♂️🦹🏻‍♀️🧙🏻🧙🏻‍♂️🧙🏻‍♀️🧚🏻🧚🏻‍♂️🧚🏻‍♀️🧛🏻🧛🏻‍♂️🧛🏻‍♀️🧜🏻🧜🏻‍♂️🧜🏻‍♀️🧝🏻🧝🏻‍♂️🧝🏻‍♀️"
  static let animals = "🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🦁🐮🐷🐽🐸🐵🙈🙉🙊🐒🐔🐧🐦🐤🐣🐥🦆🦅🦉🦇🐺🐗🐴🦄🐝🐛🦋🐌🐞🐜🦟🦗🕷🕸🦂🐢🐍🦎🦖🦕🐙🦑🦐🦞🦀🐡🐠🐟🐬🐳🐋🦈🐊🐅🐆🦓🦍🦧🐘🦛🦏🐪🐫🦒🦘🐃🐂🐄🐎🐖🐏🐑🦙🐐🦌🐕🐩🦮🐕‍🦺🐈🐓🦃🦚🦜🦢🦩🕊🐇🦝🦨🦡🦦🦥🐁🐀🐿🦔"
  static let plants = "🌵🎄🌲🌳🌴🌱🌿☘️🍀🎍🎋🍃🍂🍁🍄🐚🌾💐🌷🌹🥀🌺🌸🌼🌻"
  static let all = [Self.smilies, Self.fantasy, Self.animals, Self.plants]
}
