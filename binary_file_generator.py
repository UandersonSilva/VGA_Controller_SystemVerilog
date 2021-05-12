
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
WIDTH_BITS = 10
HEIGHT_BITS = 9

def fill_file(frame_file):
    color = (format(int('F00', base=16),'012b'), format(int('0F0', base=16),'012b'), format(int('00F', base=16),'012b'))
    file = open(frame_file, "w")

    if file:
        addresses = 2**(WIDTH_BITS+HEIGHT_BITS)
        max_x = 2**WIDTH_BITS - 1  #max_x = 0000000011111111 (00FF)
        color_position = 0
        counter = 0

        for address in range(addresses):
            pixel_y = (address >> WIDTH_BITS) #Get the pixel y-position from address -> YYXX >> WIDTH_BITS = 00YY
            pixel_x = address & (max_x) #Get the x-position from address -> YYXX & 00FF = 00XX

            if (pixel_y < SCREEN_HEIGHT) and (pixel_x < SCREEN_WIDTH): #If the address is in the visible region
                file.write(color[color_position]+"\n")
                if (pixel_x == (SCREEN_WIDTH - 1)):
                    if (counter<15):
                        counter += 1
                    else:
                        counter = 0                        
                        if (color_position<2):
                            color_position += 1
                        else:
                            color_position = 0
            else:
                if (address != (addresses - 1)):
                    file.write(format(int('000', base=16),'012b')+"\n")
                else:
                    file.write(format(int('000', base=16),'012b'))
        file.close()
    else:
        print("Error creating|opening file :(")
    
fill_file('frame.bin')