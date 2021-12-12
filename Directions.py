file = open("input.txt").read().strip()
lines = list(map(lambda x: [x.strip().split(" ")[0][0], int(x.strip().split(" ")[1])], file.split('\n')))
depth = 0
dist = 0
print(lines)
aim = 0
for line in lines:
    if line[0] == "f":
        dist += line[1]
        depth += line[1] * aim
    elif line[0] == "d":
        aim += line[1]
    elif line[0] == "u":
        aim -= line[1]
print(depth * dist)
print(dist)
print(depth)