import sys

import os


if len(sys.argv) < 5:
    print("Please provide a filename, SnapshotDirection dir, Max Height height, and output file name as arguments")
    sys.exit()

filename = sys.argv[1]
dir = sys.argv[2]
height = sys.argv[3]
output = sys.argv[4]

if not os.path.isfile(filename):
    print("File does not exist")
    sys.exit()

with open(filename, 'r') as f:
    genes = f.read().splitlines()

with open(f'{output}.bat', 'w') as f:
    f.write(f'snapshotDirectory {dir}\n')
    f.write(f'maxPanelHeight {height}\n')
    for gene in genes:
        f.write(f'goto {gene}\n')
        f.write(f'snapshot {gene}_height{height}.png\n')
