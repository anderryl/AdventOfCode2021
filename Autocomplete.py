import math
text = open('input.txt').read().strip()
lines = [line.strip() for line in text.split('\n')]

def openers(line): return line.count('[') + line.count('{') + line.count('<') + line.count('(')
def closers(line): return line.count('>') + line.count('}') + line.count('>') + line.count(')')
def isopener(char): return char == "{" or char == "<" or char == "(" or char == "["
def iscloser(char): return char == "}" or char == ">" or char == ")" or char == "]"
def opposite(char):
    o = "{"
    c = "}"
    if char == o:
        return c
    if char == c:
        return o
    o = "["
    c = "]"
    if char == o:
        return c
    if char == c:
        return o
    o = "<"
    c = ">"
    if char == o:
        return c
    if char == c:
        return o
    o = "("
    c = ")"
    if char == o:
        return c
    if char == c:
        return o
        
#lines = ["<{([{{}}[<[[[<>{}]]]>[]]", "{<[[]]>}<{[{[{[]{()[[[]", "(((({<>}<{<{<>}{[]{[]{}", "[(()[<>])]({[<{<<[]>>(", "[({(<(())[]>[[{[]{<()<>>"]
def excise(line):
    stack = []
    for char in line:
        if isopener(char):
            stack.append(char)
        if iscloser(char):
            if stack[len(stack) - 1] == opposite(char):
                stack.pop()
            else:
                return None
    rem = ""
    for char in stack:
        rem = opposite(char) + rem
    return rem

excisions = [excise(line) for line in lines if excise(line) != None]

def score(char):
    if char == ")":
        return 1
    if char == "}":
        return 3
    if char == "]":
        return 2
    if char == ">":
        return 4
    
def scorestring(string):
    cur = 0
    for char in string:
        cur *= 5
        cur += score(char)
    return cur


scores = sorted([scorestring(ex) for ex in excisions])
print(scores)
mid = math.ceil(len(scores) / 2) - 1
print(scores[mid])