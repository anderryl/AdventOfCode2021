import Foundation

var data = try String(contentsOfFile: "data.txt")

/*
data = """
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
"""
*/

let lines = data.split("\n")

let algorithm = lines[0].map() { (char) -> Int in
    if char == "." {
      return 0
    }
    else {
      return 1
    }
  }
let real = 65
let generations = real * 3
let blank = [Int].init(repeating: 0, count: generations)
let row = [[Int]].init(repeating: [Int].init(repeating: 0, count: generations * 2 + lines[2].count), count: generations)

var inputs = row + (lines[2..<lines.count].map() {(line) -> [Int] in 
  let start = line.map() { (char) -> Int in
    if char == "." {
      return 0
    }
    else {
      return 1
    }
  }
  return blank + start + blank
}) + row

func value(_ x: Int, _ y: Int) -> Int {
  if y < inputs.count && y >= 0 {
    if x < inputs[y].count && x >= 0 {
      return inputs[y][x]
    }
  }
  return 0
}

func calculate(_ x: Int, _ y: Int) -> Int {
  var index = 0
  index += value(x - 1, y - 1) * Int(pow(2.0, 8.0))
  index += value(x, y - 1) * Int(pow(2.0, 7.0))
  index += value(x + 1, y - 1) * Int(pow(2.0, 6.0))
  index += value(x - 1, y) * Int(pow(2.0, 5.0))
  index += value(x, y) * Int(pow(2.0, 4.0))
  index += value(x + 1, y) * Int(pow(2.0, 3.0))
  index += value(x - 1, y + 1) * Int(pow(2.0, 2.0))
  index += value(x, y + 1) * Int(pow(2.0, 1.0))
  index += value(x + 1, y + 1) * Int(pow(2.0, 0.0))
  return algorithm[index]
}

func run() {
  var output: [[Int]] = []
  for y in 0 ..< inputs.count {
    var row: [Int] = []
    for x in 0 ..< inputs[y].count {
      row.append(calculate(x, y))
    }
    output.append(row)
  }
  inputs = output
}


for i in 0 ..< 50 {
  run()
  print((i*2).description + "%")
}

var c = 0
for row in inputs[2 * real ... inputs.count - 2 * real] {
  for value in row[2 * real ... inputs[0].count - 2 * real] {
    c += value
  }
}
print(c)
