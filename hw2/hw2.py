f = open('data.txt','r')
g = open('newdata.txt','w')
number = float(0)
print f

for line in f:
    para = line.split()
    g.write("[")
    tag = 0
    for item in para:
        tag = tag + 1
        if tag%3 == 1:
            g.write("vec3(")
            g.write(str(float(item)/5))
        elif tag%3 == 2:
            g.write(",")
            g.write(str(float(item)/5))
        else:
            g.write(",")
            g.write(str(float(item)/5))
            if tag == 9:
                tag = 0
                g.write(")")
            else:
                g.write("),")
    g.write("],\n")
                
f.close()
g.close()
print "Action completed"
