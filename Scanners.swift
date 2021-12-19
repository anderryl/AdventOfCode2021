import Foundation


struct Position: Hashable {
  var x: Int
  var y: Int
  var z: Int

  init(_ x: Int, _ y: Int, _ z: Int) {
    self.x = x
    self.y = y
    self.z = z
  }

  static func +(_ lhs: Position, _ rhs: Position) -> Position {
    return Position(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
  }
}

typealias Transform = (Position) -> Position

var faces: [Transform] = [{Position($0.x, $0.y, $0.z)}, {Position($0.x, $0.z, -$0.y)}, {Position($0.y, $0.x, -$0.z)}, {Position($0.y, $0.z, $0.x)}, {Position($0.z, $0.y, -$0.x)}, {Position($0.z, $0.x, $0.y)}]
var transforms: [Transform] = []
for cx in [-1, 1] {
  for cy in [-1, 1] {
    for cz in [-1, 1] {
      for face in faces {
        transforms.append({face(Position(cx * $0.x, cy * $0.y, cz * $0.z))})
      }
    }
  }
}

class Scanner: Equatable {
  var beacons: [Position]
  var number: Int

  init(_ beacons: [Position], _ number: Int) {
    self.beacons = beacons
    self.number = number
  }

  static func ==(_ lhs: Scanner, _ rhs: Scanner) -> Bool {
    if lhs.number == rhs.number {
      return true
    }
    return false
  }

  func compare(_ first: [Position], _ second: [Position]) -> Position? {
    let results = first.map() { (one) -> [Position] in
      return second.map() { (two) -> Position in 
        return Position(two.x - one.x, two.y - one.y, two.z - one.z)
      }
    }.reduce([], +).mode()
    if results.count >= 12 {
      return results.element
    }
    return nil
  }

  func orient(to other: Scanner) -> (offset: Position, orientation: Transform)? {
    for orientation in transforms {
      let redone = beacons.map() {orientation($0)}
      if let results = compare(redone, other.beacons) {
        return (offset: results, orientation: orientation)
      }
    }
    return nil
  }
}

var data = try String(contentsOfFile: "data.txt")

let raw = data.split("---").comprehend(condition: {$0.count > 14}, map: {$0.split("\n").filter() {$0.count > 0}})

var num = -1
let scanners = raw.map() { (scanner) -> Scanner in
  num += 1
  return Scanner(scanner.map() { (fragment) -> Position in 
    let parts = fragment.split(",").map() {Int($0)!}
    return Position(parts[0], parts[1], parts[2])
  }, num)
}

var tree: [(scanner: Scanner, position: Position)] = [(scanner: scanners[0], position: Position(0, 0, 0))]
var i = 0
while tree.count != scanners.count {
  for branch in tree {
    for lost in scanners.filter({!tree.map({$0.scanner}).contains($0)}) {
      if let config = lost.orient(to: branch.scanner) {
        tree.append((scanner: Scanner(lost.beacons.map({config.orientation($0)}), lost.number), position: config.offset + branch.position))
      }
    }
  }
}

var points = Set<Position>()
for branch in tree {
  for point in branch.scanner.beacons {
    points.insert(point + branch.position)
  }
}
print(points.count)

var record = 0
for one in tree.map({$0.position}) {
  for two in tree.map({$0.position}) {
    let dist = abs(one.x - two.x) + abs(one.y - two.y) + abs(one.z - two.z)
    if dist > record {
      record = dist
    }
  }
}

print(record)
