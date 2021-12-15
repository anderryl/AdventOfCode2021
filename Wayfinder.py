import math

# Le' open die texterschnizel
text = open('input.txt').read().strip()

# Wraps a value around if nessecary
def wrap(i):
    if i + 1 > 9:
        return 1
    return i + 1

# Increments an entire tile at once
def increment(tile):
    return [[wrap(loc) for loc in row] for row in tile]

# Splices lists togethor along the x
def splicex(lists):
    ret = lists[0]
    for i in range(1, len(lists)):
        nex = lists[i]
        for j in range(len(nex)):
            ret[j] += nex[j]
    return ret

# Splices lists togethor along the y
def splicey(lists):
    ret = lists[0]
    for i in range(1, len(lists)):
        ret += lists[i]
    return ret

# The raw data before multiplication
linesraw = [[int(char) for char in line.strip()] for line in text.split('\n')]

# Repeatedly increments and splices on to and starting from the base tile
current = linesraw
preprocessed = [current]
for i in range(4):
    current = increment(current)
    preprocessed.append(current)
row = splicex(preprocessed)

# Repeats the process with the base row
current = row
preprocessed = [current]
for i in range(4):
    current = increment(current)
    preprocessed.append(current)
lines = splicey(preprocessed)


# Yields the squares adjacent to the input square
def adjacent(l):
    vx = l[1]
    vy = l[0]
    adj = []
    ly = vy > 0
    hy = vy < len(lines) - 1
    lx = vx > 0
    hx = vx < len(lines[0]) - 1
    if ly:
        adj.append([vy-1, vx])
    if hy:
        adj.append([vy+1, vx])
    if lx:
        adj.append([vy, vx-1])
    if hx:
        adj.append([vy, vx+1])
    return adj

# Hashes a position list
def e(l):
    return l[0] * 1000 + l[1]

# Unhashes a position list
def d(h):
    return [math.floor(h / 1000), h % 1000]

# Finds the path with a flood-fill algorithm (supposedly that's what its called)
def pathfind(source, dest):
    
    # Define the frontier and scanned dictionaries
    frontier = {e(source) : 0}
    scanned = {e(source) : 0}
    
    # While there is still frontier to explore
    while not len(frontier) == 0:
        
        # Define the modification dictionary
        nex = dict([])
        
        # Loop through the frontier
        for key, value in frontier.items():
            
            # Loops through all adjacent squares
            for adj in adjacent(d(key)):
                
                # Hashes the square
                encoded = e(adj)
                
                # Finds the branched value
                n = value + lines[adj[0]][adj[1]]
                
                # If it has already been scanned
                if encoded in scanned:
                    
                    # Check if the new value is lower than the previous cost value
                    if n < scanned[encoded]:
                        
                        # If so replace it and add to the frontier
                        nex[encoded] = n
                        scanned[encoded] = n
                else:
                    
                    # Add the point to the frontier and its cost to the scanned dictionary
                    nex[encoded] = n
                    scanned[encoded] = n
                    
        # Set the frontier to the temporary nex dictionary
        frontier = nex
        
    # Return the cost value of the destination
    return scanned[e(dest)]

# Get 'er done
print(pathfind([0, 0], [len(lines)-1, len(lines[0])-1]))         