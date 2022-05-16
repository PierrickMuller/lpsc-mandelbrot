# Based on https://www.codingame.com/playgrounds/2358/how-to-plot-the-mandelbrot-set/mandelbrot-set

from PIL import Image, ImageDraw
import math
#from mandelbrot import mandelbrot, MAX_ITER

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

    result_real = bin_whole_real + frac_to_binary(abs(frac_real))
    result_imag = bin_whole_imag + frac_to_binary(abs(frac_imag))
    end_real = 0
    end_imag = 0
    if (whole_real < 0 or (whole_real == 0 and frac_real < 0)):
        end_real = 1
        temp_int = int(result_real,2)
        if whole_real == 0:
            result_real = '{:018b}'.format(- temp_int & 0b111111111111111111)
        else:
            result_real = '{:018b}'.format(temp_int & 0b111111111111111111)
        print("Value real : " + result_real + " (" + "1" + bin_whole_real[1:] + frac_to_binary(abs(frac_real))+")")

    if (whole_imag < 0 or (whole_imag == 0 and frac_imag < 0)):
        end_imag = 1
        temp_int = int(result_imag,2)
        if whole_imag == 0:
            result_imag = '{:018b}'.format(- temp_int & 0b111111111111111111)
        else:
            result_imag = '{:018b}'.format(temp_int & 0b111111111111111111)
        print("Value imag : " + result_imag + " (" + "1" + bin_whole_imag[1:] + frac_to_binary(abs(frac_imag))+")")

    if (end_real == 0):
        print("Value real : " + result_real)
    if (end_imag == 0):
        print("Value imag : " + result_imag)



def mandelbrot(c):
    z = 0
    n = 0
    #while abs(z) <= 2 and n < MAX_ITER:
    while (z.real*z.real + z.imag*z.imag) <= 4 and n < MAX_ITER:
        z = z*z + c
        n += 1
        #complex_to_binary(z,n)
    return z,n


# Image size (pixels)
WIDTH = 1#800
HEIGHT =1# 600

# Plot window
RE_START = -2
RE_END = 1
IM_START = -1
IM_END = 1

palette = []

im = Image.new('RGB', (WIDTH, HEIGHT), (0, 0, 0))
draw = ImageDraw.Draw(im)

for x in range(0, WIDTH):
    for y in range(0, HEIGHT):
        # Convert pixel coordinate to complex number
        c = complex(RE_START + (x / WIDTH) * (RE_END - RE_START),
                    IM_START + (y / HEIGHT) * (IM_END - IM_START))
        
        print("X : " + str(x) + " Y : " + str(y) + "--> C : " + str(c)) 
        print(complex_to_binary(c,0))
        print("START : ")
	# Compute the number of iterations
        z,m = mandelbrot(c)
        complex_to_binary(z,m)
        # The color depends on the number of iterations
        color = 255 - int(m * 255 / MAX_ITER)
        # Plot the point
        draw.point([x, y], (color, color, color))

c = complex(-2,1)
z,m = mandelbrot(c)
#complex_to_binary(c,0);

im.save('output.png', 'PNG')
