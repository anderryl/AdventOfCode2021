import Foundation

var data = try String(contentsOfFile: "data.txt")
/*data = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
"""*/

let lines = data.split(char: "\n").map()
{$0.trimmingCharacters(in: .whitespacesAndNewlines)}

indirect enum Fish {
  case LITERAL(Int)
  case PAIR(Fish, Fish)

  func add(_ amount: Int, _ l: Bool) -> Fish {
    switch self {
      case .LITERAL(let val):
        return .LITERAL(val + amount)
      case .PAIR(let lef, let rig):
        if l {
          return .PAIR(lef.add(amount, true), rig)
        }
        else {
          return .PAIR(lef, rig.add(amount, false))
        }
    }
  }

  func value() -> Int {
    switch self {
      case .LITERAL(let val):
        return val
      default:
        return 0
    }
  }

  func __explode__(_ level: Int = 0) -> (Fish, (l: Int, r: Int)?) {
    switch self {
      case .LITERAL(_):
        return (self, nil)
      case .PAIR(let lef, let rig):
        if level >= 4 {
          return (.LITERAL(0), (lef.value(), rig.value()))
        }
        var expl = lef.__explode__(level + 1)
        if let result = expl.1 {
          if result == (l: 0, r: 0) {
            return (.PAIR(expl.0, rig), (l: 0, r: 0))
          }
          return (.PAIR(expl.0, rig.add(result.r, true)), (l: result.l, 0))
        }
        var expr = rig.__explode__(level + 1)
        if let result = expr.1 {
          if result == (l: 0, r: 0) {
            return (.PAIR(lef, expr.0), (l: 0, r: 0))
          }
          return (.PAIR(lef.add(result.l, false), expr.0), (l: 0, result.r))
        }
        return (self, nil)
        
    }
  }

  func explode() -> (Fish, Bool) {
    switch self {
      case .LITERAL(_):
        return (self, false)
      case .PAIR(let lef, let rig):
        var expl = lef.__explode__(1)
        if let result = expl.1 {
          if result == (l: 0, r: 0) {
            return (.PAIR(expl.0, rig), true)
          }
          return (.PAIR(expl.0, rig.add(result.r, true)), true)
        }
        var expr = rig.__explode__(1)
        if let result = expr.1 {
          if result == (l: 0, r: 0) {
            return (.PAIR(lef, expr.0), true)
          }
          return (.PAIR(lef.add(result.l, false), expr.0), true)
        }
        return (self, false)
        
    }
  }

  func magnitude() -> Int {
    switch self {
      case .LITERAL(let value):
        return value
      case .PAIR(let lef, let rig):
        return lef.magnitude() * 3 + rig.magnitude() * 2
    }
  }

  func split() -> (Fish, Bool) {
    switch self {
      case .LITERAL(let value):
        if value > 9 {
          return (.PAIR(.LITERAL(Int((Float(value) / 2.0))), .LITERAL(Int(ceil(Float(value) / 2.0)))), true)
        }
        return (self, false)
      case .PAIR(let lef, let rig):
        let spl = lef.split()
        if spl.1 {
          return (.PAIR(spl.0, rig), true)
        }
        let spr = rig.split()
        if spr.1 {
          return (.PAIR(lef, spr.0), true)
        }
        return (self, false)
    }
  }

  func sum(_ other: Fish) -> Fish {
    return .PAIR(self, other)
  }

  func reduce() -> Fish {
    var cond = true
    var copy = self

    while cond {
      let expl = copy.explode()
      if expl.1 {
        copy = expl.0
      }
      else {
        let spl = copy.split()
        if spl.1 {
          copy = spl.0
        }
        else {
          break
        }
      }
    }
    return copy
  }

  func description() -> String {
    switch self {
      case .LITERAL(let value):
        return value.description
      case .PAIR(let lef, let rig):
        return "[" + lef.description() + ", " + rig.description() + "]"
    }
  }
}



func parse(_ str: String) -> Fish {
  let list = str.trimmingCharacters(in: .whitespacesAndNewlines)
  if let ans = Int(list) {
    return .LITERAL(ans)
  }
  let interior = list[1 ..< list.count]
  var level = 0
  var i = 0
  for char in interior {
    if char == "," && level == 0 {
      return .PAIR(parse(interior[0..<i+1]), parse(interior[i+1...interior.count]))
    }
    if char == "[" {
      level += 1
    }
    if char == "]" {
      level -= 1
    }
    i += 1
  }
  return .LITERAL(-69)
}
/*let fish = parse("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
print(fish.reduce())*/

let twofish = lines.map() {parse($0)}
let bluefish = twofish
var best = 0
for onefish in twofish {
  for redfish in bluefish {
    if !(onefish.magnitude() == redfish.magnitude()) {
      let ans = onefish.sum(redfish).reduce().magnitude()
      if ans > best {
        best = ans
      }
    }
  }
}
print(best)
