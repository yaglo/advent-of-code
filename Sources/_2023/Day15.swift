// MARK: Day 15: Lens Library -

import AdventOfCode
import Foundation

struct Day15: AdventDay {
  // MARK: -

  func part1() -> Int {
    data.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").map(hash).sum()
  }

  func part2() -> Int {
    let instructions = data.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",")

    var boxes: [[(Substring, Int)]] = Array(repeating: [], count: 256)

    for instruction in instructions {
      if instruction.hasSuffix("-") {
        let name = instruction.replacing("-", with: "")
        let box = boxes[hash(name)]
        boxes[hash(name)] = box.filter { $0.0 != name }
      } else {
        let split = instruction.split(separator: "=")
        let name = split[0]
        let focalLength = Int(split[1])!
        var box = boxes[hash(name)]
        if let index = box.firstIndex(where: { $0.0 == name }) {
          box[index] = (name, focalLength)
        } else {
          box.append((name, focalLength))
        }
        boxes[hash(name)] = box
      }
    }

    return boxes.enumerated()
      .map { box in
        box.element.enumerated()
          .reduce(0) { partialResult, lens in
            partialResult + (box.offset + 1) * (lens.offset + 1) * lens.element.1
          }
      }
      .sum()
  }

  // MARK: - Helpers

  func hash(_ string: Substring) -> Int {
    string.reduce(0) { partialResult, character in
      ((partialResult + Int(character.asciiValue!)) * 17) % 256
    }
  }

  // MARK: - Data

  let data: String
}
