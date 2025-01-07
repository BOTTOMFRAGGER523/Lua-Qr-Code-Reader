# This file will be exposed to qr.lua by using pyinstaller if you want to build it make sure you have python 3.13.0 and pyinstaller
import sys
from pyzbar.pyzbar import decode
from PIL import Image

def read_qr(image_path):
    image = Image.open(image_path)
    decoded_objects = decode(image)
    for obj in decoded_objects:
        print(obj.data.decode('utf-8'))

if __name__ == '__main__':
    read_qr(sys.argv[1])