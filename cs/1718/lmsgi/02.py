import sys

a = sys.argv[1]
b = sys.argv[2:]
c = -1
found = False

for i in range(len(b)):
    if a == b[i] and found == False:
        found = True
        c = i

if c >= 0:
    print(c)
