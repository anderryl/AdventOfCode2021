import math
text = open("input.txt").read().strip()
# text = """
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
# """
lines = text.strip().split('\n')
elevation = [[int(char) for char in line.strip()] for line in lines]
print(elevation)
width = len(elevation[0])
height = len(elevation)
def adjs(x, y):
    adj = []
    if x < width - 1:
        adj.append([y, x+1])
    if x > 0:
        adj.append([y, x-1])
    if y < height - 1:
        adj.append([y+1, x])
    if y > 0:
        adj.append([y-1, x])
    return adj

def low(x, y):
    adj = adjs(x, y)
    if elevation[y][x] < min([elevation[ad[0]][ad[1]] for ad in adj]):
        return True
    return False

lows = []
for x in range(width):
    for y in range(height):
        if low(x, y):
            lows.append([x, y])

# Enter the seventh circle of index hell
def basin(x, y):
    scanned = set([y * 10000 + x])
    frontier = set([y * 10000 + x])
    nex =  {}
    while len(frontier) > 0:
        nex = set([])
        for point in frontier:
            for adj in adjs(point % 10000, math.floor(point / 10000)):
                i = (adj[0] * 10000 + adj[1])
                if not i in scanned:
                    if elevation[adj[0]][adj[1]] != 9:
                        nex.add(adj[0] * 10000 + adj[1])
                        scanned.add(adj[0] * 10000 + adj[1])
        frontier = nex
    return len(scanned)
print(lows)
basins = [basin(low[0], low[1]) for low in lows]
sort = sorted(basins, reverse=True)
print(sort[0] * sort[1] * sort[2])
