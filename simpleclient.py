import pickle
import threading
import time
from socket import socket
# from zlib import decompress
# from gzip import decompress
from Graphics import *

import pygame

WIDTH = 375
HEIGHT = 812
HEADERSIZE = 10

class Client(GUI):
    def __init__(self, root=None):
        super().__init__(root=root)
        t = threading.Thread(target=self.main)
        t.start()
        # self.main()

    def open_windo(self):
        self.root.mainloop()

    def recvall(self, conn, length):
        """ Retreive all pixels. """

        buf = b''
        while len(buf) < length:
            data = conn.recv(length - len(buf))
            if not data:
                return data
            buf += data
        return buf

    def recv_pkl(self, conn):
        full_msg = b''
        new_msg = True
        while True:
            data = conn.recv(16)
            if new_msg:
                msg_len = int(data[:HEADERSIZE])
                new_msg = False

            full_msg += data

            if len(full_msg) - HEADERSIZE == msg_len:
                data_recv = pickle.loads(full_msg[HEADERSIZE:])
                break
        return data_recv

    def main(self, host='127.0.0.1', port=8200):
        # host = input("Choose IPv4 : ")
        while self.wait:
            time.sleep(0.01)
        host = self.input_text
        # host = self.inputs(False)
        pygame.init()
        screen = pygame.display.set_mode((WIDTH, HEIGHT))
        clock = pygame.time.Clock()
        watching = True

        sock = socket()
        sock.connect((host, port))
        try:
            while watching:
                for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                        watching = False
                        break

                # Retreive the size of the pixels length, the pixels length and pixels
                # size_len = int.from_bytes(sock.recv(1), byteorder='big')
                # size = int.from_bytes(sock.recv(size_len), byteorder='big')
                # pixels = decompress(self.recvall(sock, size))

                pixels = self.recv_pkl(sock)

                # Create the Surface from raw pixels
                img = pygame.image.fromstring(pixels, (WIDTH, HEIGHT), 'RGB')

                # Display the picture
                screen.blit(img, (0, 0))
                pygame.display.flip()
                clock.tick(10)
        finally:
            sock.close()


if __name__ == '__main__':
    root = Tk()
    c = Client(root=root)
    # c.main()
    root.mainloop()