data = open("input.txt").read()

lines = data.split("\n")

numbersraw = lines[0].split(",")
potential = []
for num in numbersraw:
    potential.append(int(num))

numbers = []

def evaluateBoard(board):
    for row in board:
        if evaluateRow(row):
            return True
    for colo in range(0, 5):
        col = []
        for colt in range(0, 5):
            col.append(board[colt][colo])
        if evaluateRow(col):
            return True
    return False

def evaluateRow(row):
    for num in row:
        if numbers.count(num) == 0:
            return False
    return True

boards = []
for i in range(2, len(lines), 6):
    board = []
    for j in range(i, i+5):
        row = []
        for num in lines[j].split(' '):
            if num != "":
                row.append(int(num))
        board.append(row)
    boards.append(board)
print(boards)
    
winner = -1
recent = 0
for i in range(0, len(potential)):
    recent = potential.pop(0)
    numbers.append(recent)
    for board in boards:
        if evaluateBoard(board):
            boards.remove(board)
        
    if len(boards) == 1:
        winner = boards[0]
    if len(boards) == 0:
        break

total = 0
for row in winner:
    for col in row:
        if numbers.count(col) == 0:
            total += col
            print(col)
total *= recent
print(recent)
for row in winner:
    print(row)
print(total)
