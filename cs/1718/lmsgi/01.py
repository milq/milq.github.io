import sys

a = sys.argv[1]
b = ''

for i in range(len(a)):
    if a[i] != 'a' and a[i] != 'e' and a[i] != 'i' and a[i] != 'o' and a[i] != 'u' and a[i] != 'A' and a[i] != 'E' and a[i] != 'I' and a[i] != 'O' and a[i] != 'U':
        b = b + a[i]

print(b)
