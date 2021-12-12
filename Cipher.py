raw = open("input.txt").read().strip()
lines = raw.split("\n")
outputs = []
uniques = []
for line in lines:
    halves = line.split('|')
    uniques.append(halves[0].strip().split(" "))
    outputs.append(halves[1].strip().split(" "))
    
class Pointer:
    pointee = None
    def __init__(self, point):
        self.pointee = point

def mass(array, operation):
    intermediate = array[0]
    for constraint in array:
        intermediate = intermediate & constraint
    if operation == "intersection":
        return intermediate
    else:
        return {'a', 'b', 'c', 'd', 'e', 'f', 'g'} ^ intermediate 

def constrain(slots, constraints):
    for slot in slots:
        slot.pointee.append(constraints)

def solve(cypher, key):
    total = []
    for char in cypher:
        total.append(key.index(char) + 1)
    s = sum(total)
    if s == 24:
        return 0
    if s == 9:
        return 1
    if s == 21:
        return 3
    if s == 15:
        return 4
    if s == 25:
        return 6
    if s == 10:
        return 7
    if s == 28:
        return 8
    if s == 23:
        return 9
    if s == 20:
        if 3 in total:
            return 2
        return 5

def decode(inputs, outputs):
    one = set([i for i in inputs if len(i) == 2][0])
    seven = set([i for i in inputs if len(i) == 3][0])
    eight = set([i for i in inputs if len(i) == 7][0])
    four = set([i for i in inputs if len(i) == 4][0])
    fives = [{char for char in i} for i in inputs if len(i) == 5]
    sixes = [{char for char in i} for i in inputs if len(i) == 6]
    wires = [Pointer([{"a", "b", "c", "d", "e", "f", "g"}]) for i in range(7)]
    
    # 1v7 Rule
    absoluteA = (one ^ seven).pop()
    constrain([wires[0]], {absoluteA})
    constrain([wires[5], wires[2]], (one & seven))
    
    #1v4 Rule
    constrain([wires[1], wires[3]], (four ^ one))
    
    #4v7 Rule
    constrain([wires[1], wires[3]], {absoluteA} ^ (four ^ seven))
    
    # Sixes Rule
    constrain([wires[2], wires[3], wires[4]], mass(sixes, "difference"))
    constrain([wires[1], wires[5], wires[6]], mass(sixes, "intersection"))
    
    # Fives Rule
    constrain([wires[3], wires[6]], mass(fives, "intersection"))
    constrain([wires[1], wires[2], wires[4], wires[5]], mass(fives, "difference"))
    
    initial = [mass(wire.pointee, "intersection") for wire in wires]
    
    def sift(wire):
        if len(wire) == 1:
            return wire
        else:
            return wire - used
    
    for i in range(7):
        used = {list(val)[0] for val in initial.copy() if len(val) == 1}
        initial = [sift(wire) for wire in initial.copy()]
    
    solutions = [flat.pop() for flat in initial.copy()]
    return 1000 * solve(outputs[0], solutions) + 100 * solve(outputs[1], solutions) + 10 * solve(outputs[2], solutions) + solve(outputs[3], solutions)

total = 0
for i in range(len(uniques)):
    total += decode(uniques[i], outputs[i])
print(total)