import math

MAX_ITER = 80

def frac_to_binary(f):
    ret = ""
    for i in range(1,15):
        f = f - pow(2,i*-1)
        if f >= 0:
            ret = ret + "1"
        else:
            f = f + pow(2,i*-1)
            ret = ret + "0"
    return ret

def complex_to_binary(c,n):
    frac_real, whole_real = math.modf(c.real)
    frac_imag, whole_imag = math.modf(c.imag)
    bin_whole_real = '{:04b}'.format(int(whole_real))
    bin_whole_imag = '{:04b}'.format(int(whole_imag))

    print("Iteration number : " + str(n))
    print("---------------------")

    print("frac_real " + str(frac_real) + " whole_real " + str(whole_real))
    print("frac_imag " + str(frac_imag) + " whole_imag " + str(whole_imag))

    if (whole_real < 0 or (whole_real == 0 and frac_real < 0)):
        bin_whole_real = "1" + bin_whole_real[1:]

    if (whole_imag < 0 or (whole_imag == 0 and frac_imag < 0)):
        bin_whole_imag = "1" + bin_whole_imag[1:]
    
    print("Value real : " + bin_whole_real + frac_to_binary(abs(frac_real)))
    print("Value imag : " + bin_whole_imag + frac_to_binary(abs(frac_imag)))

    #print("frac_real " + str(frac_real) + " whole_real " + str(whole_real))
    #print(str(bin(int(whole_real))))
    #print('{:04b}'.format(int(whole_real)))
    #print(frac_to_binary(abs(frac_real)))
    
def mandelbrot(c):
    z = 0
    n = 0
    #while abs(z) <= 2 and n < MAX_ITER:
    while (z.real*z.real + z.imag*z.imag) <= 4 and n < MAX_ITER:
        z = z*z + c
        n += 1
        complex_to_binary(z,n)
    return n


# Image size (pixels)
WIDTH = 800
HEIGHT = 600

# Plot window
RE_START = -2
RE_END = 1
IM_START = -1
IM_END = 1

c = complex(0.5,1)
print(" C0 : " + str(c)) 

# Compute the number of iterations
m = mandelbrot(c)


