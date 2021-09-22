import numpy
from PIL import Image

SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
WIDTH_BITS = 10
HEIGHT_BITS = 9

frame_file = 'frame.bin'
data = numpy.zeros((SCREEN_HEIGHT, SCREEN_WIDTH, 3), dtype=numpy.uint8)# Create an array that stores (Byte, Byte, Byte) in a [y, x] location

binary_file = open(frame_file, 'r')
if binary_file:
    address = 0
    #addresses = 2**(WIDTH_BITS+HEIGHT_BITS)
    max_x = 2**WIDTH_BITS - 1 #max_x = 0000000011111111 (00FF) ***ILUSTRATION*** It doesn't represent the true value
    color_operand = 2**4 - 1 #color_operand = 000000001111 (00F)

    for binary in binary_file:
        if(not binary.startswith('//')):
            pixel_y = (address >> WIDTH_BITS) #Get the pixel y-position from address -> YYXX >> WIDTH_BITS = 00YY
            pixel_x = address & (max_x) #Get the x-position from address -> YYXX & 00FF = 00XX

            if (pixel_y < SCREEN_HEIGHT) and (pixel_x < SCREEN_WIDTH): #If the pixel is in the visible region
                if(binary.find('x') == -1):
                    pixel = int(binary, base=2)
                else:
                    pixel = 0

                pixel_red = pixel >> 8 #Get the red color bits from pixel -> RGB >> 8 = 00R
                pixel_red = (pixel_red << 4) | pixel_red #Get 8 bits color representation for 4 bits  -> R0 | 0R = RR
                pixel_green = (pixel >> 4) #pixel RGB >> 4 = 0RG
                pixel_green = pixel_green & color_operand #Get the green color bits from pixel -> RG & 0F = 0G
                pixel_green = (pixel_green << 4) | pixel_green #Get 8 bits color representation for 4 bits  -> G0 | 0G = GG
                pixel_blue = pixel & color_operand #Get the blue color bits from pixel -> RGB & 00F = 00B
                pixel_blue = (pixel_blue << 4) | pixel_blue #Get 8 bits color representation for 4 bits  -> B0 | 0B = BB
                data[pixel_y, pixel_x] = (pixel_red, pixel_green, pixel_blue) # Save (RR, GG, BB)

            address += 1
    image = Image.fromarray(data)
    #image.save('image_generator_out.png', 'png')
    image.show()
else:
    print("Error opening file :(")
