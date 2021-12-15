text = open('input.txt').read().strip()
# text = """
# NNCB
# 
# CH -> B
# HH -> N
# CB -> H
# NH -> C
# HB -> C
# HC -> B
# HN -> C
# NN -> C
# BH -> H
# NC -> B
# NB -> B
# BN -> B
# BB -> N
# BC -> B
# CC -> N
# CN -> C
# """
text = text.strip()
lines = [line.strip() for line in text.split('\n') if not line.strip() == ""]
template = [char for char in lines.pop(0)]
pairs = {line.split(' -> ')[0]:line.split(' -> ')[1] for line in lines}
current = dict([])
for i in range(len(template) - 1):
    comb = template[i] + template[i + 1]
    if comb in current:
        current[comb] += 1
    else:
        current[comb] = 1

for i in range(40):
    nex = dict([])
    for cons, value in current.items():
        if cons in pairs:
            mid = pairs[cons]
            lower = cons[0] + mid
            upper = mid + cons[1]
            if lower in nex:
                nex[lower] += value
            else:
                nex[lower] = value
            if upper in nex:
                nex[upper] += value
            else:
                nex[upper] = value
        else:
            if not cons in nex:
                nex[cons] = value
            else:
                nex[cons] += value
    current = nex

letters = dict([])
start = template[0]
end = template[len(template) - 1]
for cons, value in current.items():
    if cons[0] in letters:
        letters[cons[0]] += value
    else:
        letters[cons[0]] = value
    if cons[1] in letters:
        letters[cons[1]] += value
    else:
        letters[cons[1]] = value
        
letters[start] += 1
letters[end] += 1
nums = [int(val / 2) for val in letters.values()]
print(max(nums) - min(nums))