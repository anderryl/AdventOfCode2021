import Foundation

var data = try String(contentsOfFile: "data.txt")

struct Cube {
  var origin: Vector
  var outpost: Vector

  init(_ origin: Vector, _ outpost: Vector) {
    self.origin = Vector(min(origin.x, outpost.x), min(origin.y, outpost.y), min(origin.z, outpost.z))
    self.outpost = Vector(max(origin.x, outpost.x), max(origin.y, outpost.y), max(origin.z, outpost.z))

  }

  func describe() -> String {
    return origin.x.description + " ... " + outpost.x.description
  }

  func count() -> Int {
    return abs(outpost.x - origin.x + 1) * abs(outpost.y - origin.y + 1) * abs(outpost.z - origin.z + 1)
  }

  func disjoint(_ other: Cube) -> Bool {
    func inside(_ test: Int, _ lower: Int, _ upper: Int) -> Bool {
      if test >= lower && test <= upper {
        return true
      }
      return false
    }
    let sx = (origin.x ... outpost.x)
    let sy = (origin.y ... outpost.y)
    let sz = (origin.z ... outpost.z)
    let ox = (other.origin.x ... other.outpost.x)
    let oy = (other.origin.y ... other.outpost.y)
    let oz = (other.origin.z ... other.outpost.z)

    if !(ox.contains(origin.x) || ox.contains(outpost.x) || sx.contains(other.origin.x) || sx.contains(other.outpost.x)) {
      return true
    }

    if !(oy.contains(origin.y) || oy.contains(outpost.y) || sy.contains(other.origin.y) || sy.contains(other.outpost.y)) {
      return true
    }

    if !(oz.contains(origin.z) || oz.contains(outpost.z) || sz.contains(other.origin.z) || sz.contains(other.outpost.z)) {
      return true
    }
    
    return false
  }

  func intersection(_ rhs: Cube) -> Cube? {
    let lhs = self
    if lhs.disjoint(rhs) {
      return nil
    }

    var xs = [lhs.origin.x, lhs.outpost.x, rhs.origin.x, rhs.outpost.x].sorted()
    var ys = [lhs.origin.y, lhs.outpost.y, rhs.origin.y, rhs.outpost.y].sorted()
    var zs = [lhs.origin.z, lhs.outpost.z, rhs.origin.z, rhs.outpost.z].sorted()
    
    return Cube(Vector(xs[1], ys[1], zs[1]), Vector(xs[2], ys[2], zs[2]))
  }
}
let lines = data.split("\n")
var cubes: [(cube: Cube, status: Bool)] = lines.map() { (line: String) -> (cube: Cube, status: Bool) in
  let portions = line.split(" ")
  let state = portions[0] == "on"
  let ranges = portions[1].split(",").map() { (part: String) -> (start: Int, end: Int) in
    
    let halves = part.split("=")[1].split("..")
    return (start: Int(halves[0])!, end: Int(halves[1])!)
  }
  return (cube: Cube(Vector(ranges[0].start, ranges[1].start, ranges[2].start), Vector(ranges[0].end, ranges[1].end, ranges[2].end)), status: state)
}

func account(opposing: inout [Cube], supporting: inout[Cube], target: Cube, force: Bool) {
  let oc = opposing.map({$0})
  let sc = supporting.map({$0})
  for opposite in oc {
    if let inter = target.intersection(opposite) {
      supporting.append(inter)
    }
  }
  for alike in sc {
    if let inter = target.intersection(alike) {
      opposing.append(inter)
    }
  }
  if force {
    supporting.append(target)
  }
}

var add: [Cube] = []
var remove: [Cube] = []
for cube in cubes {
  if cube.status {
    account(opposing: &remove, supporting: &add, target: cube.cube, force: true)
  }
  else {
    account(opposing: &add, supporting: &remove, target: cube.cube, force: false)
  }
  print(Int(100 * i / Double(cubes.count)).description + "%")
}
let amount = add.map({$0.count()}).reduce(0, +) - remove.map({$0.count()}).reduce(0, +)
print(amount)
