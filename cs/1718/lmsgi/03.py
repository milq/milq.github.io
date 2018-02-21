import sys

a = sys.argv[1:6]
b = sys.argv[6:]
c = 0

for i in range(len(a)):
    found = False
    for j in range(len(b)):
        found = True
        if a[i] == b[j] and found == True:
            c = c + 1

if c == 5:
    print('Sí.')
else:
    print('No.')
