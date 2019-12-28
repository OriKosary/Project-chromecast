import pickle
from socket import socket
from threading import Thread
# from zlib import compress
# from gzip import compress
# import pyautogui
from mss import mss
from PIL import ImageGrab

WIDTH = 375
HEIGHT = 812
# WIDTH, HEIGHT = pyautogui.size()
# HEIGHT -= 20

HEADERSIZE = 10


def retreive_try(conn):
    while 'recording':
        # screen_shot = pyautogui.screenshot()
        screen_shot = ImageGrab.grab()
        pkl = pickle.dumps(screen_shot.tobytes())
        msg = bytes(f'{len(pkl):<{HEADERSIZE}}', 'utf-8') + pkl
        conn.send(msg)


def retreive_screenshot(conn):
    with mss() as sct:
        # The region to capture
        rect = {'top': 0, 'left': 0, 'width': WIDTH, 'height': HEIGHT}

        while 'recording':
            # Capture the screen
            img = sct.grab(rect)
            # Tweak the compression level here (0-9)
            # pixels = compress(img.rgb, 6)
            #
            # # Send the size of the pixels length
            # size = len(pixels)
            # size_len = (size.bit_length() + 7) // 8
            # conn.send(bytes([size_len]))
            #
            # # Send the actual pixels length
            # size_bytes = size.to_bytes(size_len, 'big')
            # conn.send(size_bytes)
            #
            # # Send pixels
            # conn.sendall(pixels)

            pkl = pickle.dumps(img.rgb)
            msg = bytes(f'{len(pkl):<{HEADERSIZE}}', 'utf-8') + pkl
            conn.send(msg)


def main(host='127.0.0.2', port=8200):
    sock = socket()
    sock.bind(('', port))
    try:
        sock.listen(5)
        print('Server started.')

        while 'connected':
            conn, addr = sock.accept()
            print('Client connected IP:', addr)
            # thread = Thread(target=retreive_screenshot, args=(conn,))
            thread = Thread(target=retreive_try, args=(conn,))
            thread.start()
    finally:
        sock.close()


if __name__ == '__main__':
    main()
