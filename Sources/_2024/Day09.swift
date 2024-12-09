// MARK: Day 8: Resonant Collinearity -

import AdventOfCode
import Collections

struct Day09: AdventDay {
  // MARK: -

  func part1() -> Int {
    var newBlocks = blocks
    var left = 0
    var right = newBlocks.count - 1

    while left < right {
      while left < newBlocks.count && newBlocks[left] != .empty {
        left += 1
      }

      while right >= 0 && newBlocks[right] == .empty {
        right -= 1
      }

      if left < right {
        newBlocks[left] = newBlocks[right]
        newBlocks[right] = .empty
      }
    }

    return checksum(newBlocks)
  }

  // There are so many efficient ways to solve this, but I dind't have much time, so it's a quick and dirty solution.

  func part2() -> Int {
    var newBlocks = blocks

    var lastFile = blocks.last(where: { $0 != .empty })
    var lastFileID: Int
    var lastFileSize: Int
    switch lastFile {
    case .file(let id, let size):
      lastFileID = id
      lastFileSize = size
    default:
      fatalError()
    }

    func findSpaceToFit(size: Int) -> Int? {
      var count = 0
      var startIndex: Int?

      for index in 0..<newBlocks.count {
        if newBlocks[index] == .empty {
          if count == 0 {
            startIndex = index
          }
          count += 1
          if count == size {
            let span = newBlocks[startIndex!..<(startIndex! + size)]
            if span.allSatisfy({ $0 == .empty }) {
              return startIndex
            }
          }
        } else {
          count = 0
          startIndex = nil
        }
      }

      return nil
    }

    for id in stride(from: lastFileID, to: 0, by: -1) {
      lastFile = newBlocks.last(where: { $0.id == id })!
      switch lastFile {
      case .file(let id, let size):
        lastFileID = id
        lastFileSize = size
      default:
        fatalError()
      }

      if let space = findSpaceToFit(size: lastFileSize) {
        let fileIndex = newBlocks.firstIndex(of: lastFile!)!

        if space > fileIndex {
          continue
        }

        for i in space..<(space + lastFileSize) {
          newBlocks[i] = newBlocks[fileIndex + i - space]
          newBlocks[fileIndex + i - space] = .empty
        }
      }
    }

    return checksum(newBlocks)
  }

  func checksum(_ blocks: [Block]) -> Int {
    blocks.enumerated().sum {
      if case let .file(id, _) = $0.element { $0.offset * id } else { 0 }
    }
  }

  // MARK: - Data

  enum Block: Comparable, Equatable, CustomStringConvertible {
    case file(id: Int, size: Int)
    case empty

    var description: String {
      switch self {
      case .file(let id, _):
        "\(id)"
      case .empty:
        "."
      }
    }

    var id: Int? {
      switch self {
      case .file(let id, _):
        return id
      default:
        return nil
      }
    }
  }

  let blocks: [Block]

  init(data: String) {
    blocks = data.enumerated().flatMap { index, char -> [Block] in
      Array(
        repeating: index.isMultiple(of: 2) ? .file(id: index / 2, size: Int(char)) : .empty,
        count: Int(char)
      )
    }
  }
}
