import Foundation

var data = try String(contentsOfFile: "data.txt")

/*
Is it bad, I didn't even try a clever solution here?
*/

func simulate(_ ix: Int, _ iy: Int) -> Bool {
  var vx = ix
  var vy = iy
  var x = 0
  var y = 0
  var highest = y
  while !(y <= -146 || x >= 157) {
    x += vx
    y += vy
    if y > highest {
      highest = y
    }
    if vx > 0 {
      vx -= 1
    }
    if vx < 0 {
      vx += 1
    }
    vy -= 1
    if x >= 102 && x <= 157 && y >= -146 && y <= -90 {
      return true
    }
  }
  return false
}

var count = 0
for x in 0 ... 200 {
  for y in -200 ... 200 {
    if simulate(x, y) {
      count += 1
    }
  }
}
print(count)
