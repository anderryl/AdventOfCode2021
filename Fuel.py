crabs = [int(crab) for crab in open("input.txt").read().strip().split(",")]
pts = [0 for i in range(max(crabs))]
def factorial(num):
    return sum([i for i in range(num+1)])
for i in range(max(crabs)):
    for crab in crabs:
        pts[i] += factorial(crab-i)#abs(crab - i)**2/2 + abs(crab - i)/2
print(min(pts))