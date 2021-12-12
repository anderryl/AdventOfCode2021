file = open("input.txt").read().strip()
lines = file.split("\n")

def decimate(string):
    i = 1
    count = 0
    for char in reversed(string):
        if char == "1":
            count += i
        i *= 2
    return count
index = 0
def compare(first):
    for i in range(0, 12):
        if not first[i] == epsilon[i]:
            return (i, first)

def remove(item):
    return item[1:len(item)]

def first(item):
    return item[index]

survivors = lines
while len(survivors) > 1:
    firsts = list(map(first, survivors))
    survivors = list(filter(lambda x: (x[index] == "0")  == (firsts.count("0") > firsts.count('1')), survivors))
    print(survivors)
    index += 1
index = 0
gamma = survivors[0]
survivors = lines
while len(survivors) > 1:
    firsts = list(map(first, survivors))
    survivors = list(filter(lambda x: (x[index] == "0")  != (firsts.count("0") > firsts.count('1')), survivors))
    print(survivors)
    index += 1
epsilon = survivors[0]
print(survivors)
print(decimate(epsilon) * decimate(gamma))
        