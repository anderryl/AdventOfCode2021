text = open('input.txt').read().strip()
# text = """
# 5483143223
# 2745854711
# 5264556173
# 6141336146
# 6357385478
# 4167524645
# 2176841721
# 6882881134
# 4846848554
# 5283751526
# """
# text = text.strip()
bulbs = [[int(char) for char in line.strip()] for line in text.split('\n')]
flashes = 0

def adjacent(vx, vy):
    adj = []
    ly = vy > 0
    hy = vy < 9
    lx = vx > 0
    hx = vx < 9
    if ly:
        adj.append([vy-1, vx])
    if hy:
        adj.append([vy+1, vx])
    if lx:
        adj.append([vy, vx-1])
    if hx:
        adj.append([vy, vx+1])
    if ly and lx:
        adj.append([vy-1, vx-1])
    if hy and hx:
        adj.append([vy+1, vx+1])
    if hy and lx:
        adj.append([vy+1, vx-1])
    if ly and hx:
        adj.append([vy-1, vx+1])
    return adj
            

def generation():
    global bulbs, flashes
    bulbs = [[val + 1 for val in row] for row in bulbs]
    while ([([val > 9 for val in row]).count(True) > 0 for row in bulbs]).count(True) > 0:
        for y in range(len(bulbs)):
            for x in range(len(bulbs[y])):
                if bulbs[y][x] > 9:
                    flashes += 1
                    bulbs[y][x] = -99999
                    for n in adjacent(x, y):
                        bulbs[n[0]][n[1]] += 1
    bulbs = [[max(0, val) for val in row] for row in bulbs]
i = 0
while [bulb.count(0) == 10 for bulb in bulbs].count(True) != 10:
    generation()
    i += 1
print(i)