import Foundation

//A quick struct to hold a 3D coordinate
struct Position: Hashable {
  var x: Int
  var y: Int
  var z: Int

  init(_ x: Int, _ y: Int, _ z: Int) {
    self.x = x
    self.y = y
    self.z = z
  }

  //Gotta love operator overloads
  static func +(_ lhs: Position, _ rhs: Position) -> Position {
    return Position(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
  }

  static func -(_ lhs: Position, _ rhs: Position) -> Position {
    return Position(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
  }
}

//Quick anti-carpal tunnel typealias
typealias Transform = (Position) -> Position

//Transforms to switch the order of the components
var permutations: [Transform] = [{Position($0.x, $0.y, $0.z)}, {Position($0.x, $0.z, -$0.y)}, {Position($0.y, $0.x, -$0.z)}, {Position($0.y, $0.z, $0.x)}, {Position($0.z, $0.y, -$0.x)}, {Position($0.z, $0.x, $0.y)}]

//Variable to hold le' transforms
var transforms: [Transform] = []

//Compile all possible sign and order variations
for cx in [-1, 1] {
  for cy in [-1, 1] {
    for cz in [-1, 1] {
      for permutation in permutations {
        transforms.append({permutation(Position(cx * $0.x, cy * $0.y, cz * $0.z))})
      }
    }
  }
}

//Represents a scanner
class Scanner: Equatable {
  var beacons: [Position]
  var number: Int

  init(_ beacons: [Position], _ number: Int) {
    self.beacons = beacons
    self.number = number
  }

  //Determine equality by scanner number to prevent reoriented duplicates
  static func ==(_ lhs: Scanner, _ rhs: Scanner) -> Bool {
    if lhs.number == rhs.number {
      return true
    }
    return false
  }

  //Compare the beacons of two scanners to find offset
  func compare(_ first: [Position], _ second: [Position]) -> Position? {
    
    //Find the differences between every two points
    //Then, find the most common value
    let results = first.map() { (one) -> [Position] in
      return second.map() { (two) -> Position in 
        return two - one
      }
    }.reduce([], +).mode()

    //If there are more than 12 return the offset
    if results.count >= 12 {
      return results.element
    }

    //Otherwise return nothing
    return nil
  }

  //Attempts all possible orientations to find correct offset
  func orient(to other: Scanner) -> (offset: Position, orientation: Transform)? {

    //Brute force search the orientations
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

//Split the text and filter out the large pieces which are data
let raw = data.split("---").filter({$0.count > 14})

//Resplit the fragments by line and filter out empties 
let broken = raw.map({$0.split("\n").filter() {$0.count > 0}})

//Number the scanners
var num = -1

//Map the line groups to scanner values
let scanners = broken.map() { (scanner) -> Scanner in

  //Increment the numbering
  num += 1

  //Return a built scanner
  return Scanner(scanner.map() { (fragment) -> Position in

    //Split each line by the commas and convert to ints
    let parts = fragment.split(",").map() {Int($0)!}

    //Return the parsed position
    return Position(parts[0], parts[1], parts[2])
  }, num)
}

//Holds all pinned searched scanners
var trunk: [(scanner: Scanner, position: Position)] = [(scanner: scanners[0], position: Position(0, 0, 0))]

//Holds pinned scanners to be searched
var branches: [(scanner: Scanner, position: Position)] = [(scanner: scanners[0], position: Position(0, 0, 0))]

//Repeat until all scanners are accounted for
while trunk.count != scanners.count {

  //Pinned scanners to be searched the next iteration
  var leaves: [(scanner: Scanner, position: Position)] = []

  //Loops through all searchable branhces
  for branch in branches {

    //Compares against all unpinned scanners
    for lost in scanners.filter({!trunk.map({$0.scanner}).contains($0)}) {

      //If there is a match, add the reoriented scanner to leaves and trunk
      if let config = lost.orient(to: branch.scanner) {
        let pinned = (scanner: Scanner(lost.beacons.map({config.orientation($0)}), lost.number), position: config.offset + branch.position)
        trunk.append(pinned)
        leaves.append(pinned)
      }
    }
  }

  //Cycle branches to the next generation
  branches = leaves
}

//Compile all beacons
var points = Set<Position>()
for branch in trunk {
  for point in branch.scanner.beacons {
    points.insert(point + branch.position)
  }
}

//Output number (Part 1)
print(points.count)

//Brute force search longest manhatten distance
var record = 0
for one in trunk.map({$0.position}) {
  for two in trunk.map({$0.position}) {
    let dist = abs(one.x - two.x) + abs(one.y - two.y) + abs(one.z - two.z)
    if dist > record {
      record = dist
    }
  }
}

//Output largest (Part 2)
print(record)
