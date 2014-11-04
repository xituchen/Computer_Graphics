def parse(file):
    out = 'face.txt'
    output = open(out, 'w+')
    stuff = open(file)
    for line in stuff:
        if line[0] is 'f':
            temp = line.split(' ')
            for one in temp:
                if one[0] is not 'f':
                    two = one.split('/')
                    output.write(str(two[0]) + ', ')

parse('slime.obj')


