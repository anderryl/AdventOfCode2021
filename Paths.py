text = open('input.txt').read().strip()

# Creates a two dimensional list containing all of the possible pathways
def parse(path):
    parts = path.strip().split('-')
    return [parts[0], parts[1]]
paths = [parse(line) for line in text.split('\n')]

# Create a dictionary of destinations coming from each point
nodes = dict([])

# For all paths, add each endpoint as destinations from the current path
for path in paths:
    
    # If the node doesn't yet exist, initialize with the current destination
    if not path[0] in nodes:
        nodes[path[0]] = [path[1]]
    
    # If it does, add the current destination
    else: 
        nodes[path[0]].append(path[1])
        
    # Mama Mia, do it all again
    if not path[1] in nodes:
        nodes[path[1]] = [path[0]]
    else:
        nodes[path[1]].append(path[0])

# Recursive function to check all possible paths 
def find(location, history, doubled):
    
    # Number of viable paths counted
    viable = 0
    
    # Copy the history to prevent side effects
    visited = history.copy()
    
    # If the current location is a small cave, add it to the visited list
    if not location.isupper():
        visited.add(location)
        
    # If the current location is the end, pass one up the recursion chain
    if location == "end":
        return 1
    
    # Loop through possible destinations for the current node
    for nex in nodes[location]:
        
        # If the node can be visited, branch into it
        if not nex in visited:
            viable += find(nex, visited, doubled)
            
        # If the node hasn't been visited and it isn't the start, branch into it
        elif not doubled and nex != "start":
            viable += find(nex, visited, True)
        
    # Return the sum of the children branches
    return viable

# Run it
print(find("start", set([]), False))