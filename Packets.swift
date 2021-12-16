import Foundation

var data = try String(contentsOfFile: "data.txt")
//data = "9C0141080250320F1802104A08"

let timeStart = Date()

extension String {
  func split(char: Character) -> [String] {
    for i in 0 ..< self.count {
      if self[i] == char {
        return [String(self[self.startIndex..<self.index(self.startIndex, offsetBy: i)]), String(self[self.index(self.startIndex, offsetBy: i + 1)...])]
      }
    }
    return [self]
  }

  subscript(index: Int) -> Character {
    get {
      return self[self.index(self.startIndex, offsetBy: index)]
    }
  }

  subscript(range: Range<Int>) -> String {
    get {
      return String(self[self.index(self.startIndex, offsetBy: range.lowerBound)..<self.index(self.startIndex, offsetBy: range.upperBound)])
    }
  }
}

func value(_ char: Character) -> String {
  switch char {
    case "0": return "0000"
    case "1": return "0001"
    case "2": return "0010"
    case "3": return "0011"
    case "4": return "0100"
    case "5": return "0101"
    case "6": return "0110"
    case "7": return "0111"
    case "8": return "1000"
    case "9": return "1001"
    case "A": return "1010"
    case "B": return "1011"
    case "C": return "1100"
    case "D": return "1101"
    case "E": return "1110"
    case "F": return "1111"
    default: return ""
  }
}

indirect enum Packet {
  case LITERAL(Int, Int)
  case OPERATION(Int, Int, [Packet])


  static func parse(_ text: String) -> Packet {
    func digitize(_ binary: String) -> Int {
      var power = pow(2.0, Double(binary.count - 1))
      var value = 0.0
      for char in binary {
        if char == "1" {
          value += power
        }
        power /= 2.0
      }
      return Int(value)
    }

    func appraise(_ literal: String) -> (length: Int, value: Int) {
      var i = 6
      var done = false
      var value = 0
      while !done {
        if literal[i] == "0" {
          done = true
        }
        let segment = literal[i + 1 ..< i + 5]
        value *= 16
        value += digitize(segment)
        i += 5
      }
      return (length: i, value: value)
    }

    func seperate(_ subpackets: String, _ length: Int, _ bits: Bool) -> (packets: [Packet], length: Int) {
      var i = 0
      var packets: [Packet] = []
      var cond = true
      while cond {
        print("Attempting to resolve packet")
        let version = digitize(subpackets[i..<i+3])
        let type = digitize(subpackets[i+3..<i+6])
        if type == 4 {
          let results = appraise(subpackets[i ..< subpackets.count])
          packets.append(.LITERAL(version, results.value))
          print("Packet is a literal of value " + results.value.description + " and length " + results.length.description)
          i = i + results.length
        }
        else {
          print("Packet is an operation")
          let opid = subpackets[i + 6]
          if opid == "0" {
            let len = digitize(subpackets[i+7 ..< i + 7 + 15])
            print("Seperating subpackets")
            let subs = seperate(subpackets[i+7+15 ..< subpackets.count], len, true)
            packets.append(.OPERATION(type, version, subs.packets))
            i += len + 22
          }
          else {
            let len = digitize(subpackets[i+7 ..< i + 7 + 11])
            print("Seperating subpackets")
            let subs = seperate(subpackets[i+7+11 ..< subpackets.count], len, false)
            packets.append(.OPERATION(type, version, subs.packets))
            i += subs.length + 18
          }
        }
        print("\n")
        if bits {
          cond = i < length        
        }
        else {
          cond = packets.count < length
        }
        
      }
      return (packets: packets, length: i)
    }
    let version = digitize(text[0..<3])
    let type = digitize(text[3..<6])
    let opid = text[6]
    if opid == "0" {
      let len = digitize(text[7 ..< 7 + 15])
      let subs = seperate(text[7+15 ..< text.count], len, true)
      return .OPERATION(type, version, subs.packets)
    }
    else {
      let len = digitize(text[7 ..< 7 + 11])
      let subs = seperate(text[7+11 ..< text.count], len, false)
      return .OPERATION(type, version, subs.packets)
    }
  }

  func sum() -> Int {
    switch self {
      case .LITERAL(let version, _):
        return version
      case .OPERATION(_, let version, let kids):
        var count = version
        for kid in kids {
          count += kid.sum()
        }
        return count
    }
  }

  func evaluate() -> Int {
    switch self {
      case .LITERAL(_, let value):
        return value
      case .OPERATION(let type, _, let kids):
        switch type {
          case 0:
            var ret = 0
            for kid in kids {
              ret += kid.evaluate()
            }
            return ret
          case 1:
            var ret = 1
            for kid in kids {
              ret *= kid.evaluate()
            }
            return ret
          case 2:
            return (kids.map() {$0.evaluate()}).min()!
          case 3:
            return (kids.map() {$0.evaluate()}).max()!
          case 5:
            if kids[0].evaluate() > kids[1].evaluate() {
              return 1
            }
            return 0
          case 6:
            if kids[0].evaluate() < kids[1].evaluate() {
              return 1
            }
            return 0
          case 7:
            if kids[0].evaluate() == kids[1].evaluate() {
              return 1
            }
            return 0
          default:
            return 0
        }
    }
  }
}

var bin: String = ""
for char in data {
  bin += value(char)
}
let heirarchy = Packet.parse(bin)
print(heirarchy.evaluate())
