# Sample projects for Flock of Swifts meetup on 20-June-2020.

## Updated 19-April-2020 for Swift Miami Meetup with an equivalent UIViewController implementation

## Emoji Publisher Playground

We started here with a brief review of `Publisher` and how to create a `Publisher` before looking at how you can use various operators including `map`, `scan`, and `prepend` to model a stateful system functionally.

## Emoji Publisher

We used the publisher created in the playground as a basis for this app, where we used a stepper to show the difference between `flatMap` and `map` + `switchToLatest`

## Tic Tac Toe - Imperative / Functional

We started with the imperative version of Tic Tac Toe and reimagined the problem using functional idioms by applying the same state modeling and functions as we learned in the Emoji Publisher app; the functional folder contains the result of transforming this imperative code into stateless, declarative and immutable functional MVVM.

![image](./preview.gif "Preview")
