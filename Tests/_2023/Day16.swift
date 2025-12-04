import Testing

@testable import AdventOfCode
@testable import _2023

@Test func day16_example_part1() { #expect(Day16(data: example).part1() == 46) }
@Test func day16_example_part2() async { #expect(await Day16(data: example).part2() == 51) }

// @Test func day16_part1() { #expect(Day16().part1() == 7210) }
// @Test func day16_part2() async { #expect(await Day16().part2() == 7673) }

private let example = """
    .|...\\....
    |.-.\\.....
    .....|-...
    ........|.
    ..........
    .........\\
    ..../.\\\\..
    .-.-/..|..
    .|....-|.\\
    ..//.|....
    """
