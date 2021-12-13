text = open('input.txt').read().strip()
# text = """
# 6,10
# 0,14
# 9,10
# 0,3
# 10,4
# 4,11
# 6,0
# 6,12
# 4,1
# 0,13
# 10,12
# 3,4
# 3,0
# 8,4
# 1,10
# 2,14
# 8,10
# 9,0
# 
# fold along y=7
# fold along x=5
# """

# I will simply not be commenting this one
text = text.strip()
lines = [line.strip() for line in text.split('\n')]

dots = []
folds = []
for line in lines:
    if line.count("fold along") > 0:
        parts = line.split("=")
        comp = parts[0][len(parts[0]) - 1]
        num = int(parts[1])
        folds.append([comp, num])
    if line.count(',') > 0:
        parts = line.split(',')
        dots.append([int(parts[0]), int(parts[1])])
        
def filt(axis, value, dot):
    if axis == "x":
        if dot[0] > value:
            return True
        return False
    if axis == "y":
        if dot[1] > value:
            return True
        return False
    
def move(axis, value, dot):
    if axis == "x":
        return [value - abs(dot[0] - value), dot[1]]
    if axis == "y":
        return [dot[0], value - abs(dot[1] - value)]
    
    
def fold(axis, value):
    moved = [move(axis, value, dot) for dot in dots if filt(axis, value, dot)]
    static = [dot for dot in dots if not filt(axis, value, dot)]
    for motioned in moved:
        if static.count(motioned) == 0:
            static.append(motioned)
    return static
    
for fol in folds:
    dots = fold(fol[0], fol[1])
print(dots)


for y in range(max([dot[1] for dot in dots]) + 1):
    row = ""
    for x in range(max([dot[0] for dot in dots]) + 1):
        if dots.count([x, y]) > 0:
            row += "#"
        else:
            row += "."
    print(row)
        