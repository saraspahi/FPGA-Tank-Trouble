import math

def main():
    accuracy = 8
    vel = 1
    print("{0:b}".format(-4))
    for i in range(0,360, accuracy):
        decompX = vel*math.cos(i*(math.pi/180))
        decompY = vel*math.sin(i*(math.pi/180))
        unsigned = int(format(round((decompY)*2**4)))
        if(unsigned < 0):
            print("AnglesSin[",int(i/8),"] = 8'd", unsigned, ";")
        else:
            print("AnglesSin[",int(i/8),"] = 8'd", unsigned, ";")

        #print("Angles[",i,"] = ", "{0:b}".format(round((decompY)*2**8)))
        
if __name__ == "__main__":
    main()

