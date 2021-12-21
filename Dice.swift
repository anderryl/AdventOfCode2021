import Foundation

var data = try String(contentsOfFile: "data.txt")

func likelihood(_ roll: Int) -> Int {
  switch roll {
    case 3:
      return 1
    case 4:
      return 3
    case 5:
      return 6
    case 6:
      return 7
    case 7:
      return 6
    case 8:
      return 3
    default:
      return 1
  }
}

func run(_ one: Int, _ two: Int, _ os: Int, _ ts: Int) -> (Int, Int) {
  var owins = 0
  var twins = 0
  for oroll in 3...9 {
    let non = ((one + oroll - 1) % 10) + 1
    if non + os >= 21 {
      owins += likelihood(oroll)
      continue
    }
    for troll in 3...9 {
      let ntw = ((two + troll - 1) % 10) + 1
      if ntw + ts >= 21 {
        twins += likelihood(troll) * likelihood(oroll)
        continue
      }
      let res = run(non, ntw, os + non, ts + ntw)
      let mult = likelihood(troll) * likelihood(oroll)
      owins += res.0 * mult
      twins += res.1 * mult
    }
  }
  return (owins, twins)
}

print(run(10, 3, 0, 0))
