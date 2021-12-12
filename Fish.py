import math

fishes = [int(string) for string in open("input.txt").read().strip().split(",")]
count = 0
def prev(list):
    if len(list) >= 2:
        return list[len(list)-2]
    else:
        return 0
def last(list):
    if len(list) > 0:
        return list[len(list)-1]
    else:
        return 0
def life(days):
    first = [1, 1]
    second = []
    third = []
    fourth = []
    fifth = []
    sixth = []
    seventh = []
    for i in range(days):
        if i % 7 == 0 and i >= 9 * 0:
            second.append(last(second) + prev(first))
        if i % 7 == 2  and i >= 9 * 1:
            third.append(last(third) + prev(second))
        if i % 7 == 4 and i >= 9 * 2:
            fourth.append(last(fourth) + prev(third))
        if i % 7 == 6  and i >= 9 * 3:
            fifth.append(last(fifth) + prev(fourth))
        if i % 7 == 1 and i >= 9 * 4:
            sixth.append(last(sixth) + prev(fifth))
        if i % 7 == 3  and i >= 9 * 5:
            seventh.append(last(seventh) + prev(sixth))
        if i % 7 == 5 and i >= 9 * 6:
            first.append(last(first) + prev(seventh))
    return last(first) + last(second) + last(third) + last(fourth) + last(fifth) + last(sixth) + last(seventh)

for i in range(1, max(fishes)+1):
    amount = life(256-i)
    count += fishes.count(i) * amount
    print(fishes.count(i) * amount)
print("Tally is: ")
print(count)
