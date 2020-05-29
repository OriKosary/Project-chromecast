import select
import socket
import base64
import os
import sys
import shutil
import os.path
from termcolor import colored
import pyautogui
from playsound import playsound

from tkinter import filedialog

WIDTH = 375
HEIGHT = 812

HEADERSIZE = 10

# 
# print(socket.getfqdn())
# Gets host name and ip
def get_ip():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    hostname_for_print = "Hostname: {0}".format(hostname)
    ip_address_for_print = "IP address: {0}".format(ip_address)
    print(hostname_for_print)
    print(ip_address_for_print)


def send_waiting_messages(wlist, messages_to_send):
    for message in messages_to_send:
        (client_socket, data) = message
        if client_socket in wlist:
            # if type(data) != str:  # TODO : check this!
            client_socket.send(message)
            messages_to_send.remove(message)


# the data that comes out of recvall is b'b64string'
def recvall(sock, length):  # 1857368
    BUFF_SIZE = 4096
    data = b''
    while True:
        part = sock.recv(BUFF_SIZE)
        data += part
        if len(part) < BUFF_SIZE:
            # either 0 or end of data
            break
    return data


open_client_sockets = []
name_socket = []
# data_parts = []
messages_to_send = []
user_name = ""
users = [("ori", "ori1")]  # this will be everybody that has access to server (tuple of name and password)


def security_protocol():
    # username, password
    access_granted = False
    while not access_granted:
        temp_user_name = input("Enter username : ")
        temp_password = input("Enter password : ")
        trying_username = (temp_user_name, temp_password)
        if trying_username in users:
            access_granted = True
            print(colored("Access granted.", "green"))
        if access_granted is False:
            print(colored("Access denied. Please check you entered the correct user name and password", "red"))


def register():  # This will be an option for people who want to join
    new_user_name = input("Enter username : ")
    new_password = input("Enter password : ")
    users.append((new_user_name, new_password))


def kick_user():
    pass


def main(host='127.0.0.1', port=8200):
    sock = socket.socket()
    sock.bind(('', port))

    try:
        sock.listen(5)
        print('Server started.')

        while 'connected':
            # write = False
            # rlist, wlist, xlist = select.select([sock] + open_client_sockets, open_client_sockets, [])
            # for current_socket in rlist:
            #     if current_socket is sock:
            #         conn, addr = sock.accept()
            #         open_client_sockets.append(conn)
            #         print('Client connected IP:', addr)
            #     else:
            conn, addr = sock.accept()
            # print('Client connected IP:', addr) maybe this adds latency
            imgdata = recvall(conn, 1)
            if len(imgdata) < 10000:
                data = imgdata.decode()
                parts = data.split(',')
                if data == 'client is connected':
                    playsound('ding.mp3')
                if data == 'B7kj89':
                    pyautogui.click()
                if data.__contains__('Q3bv76'):  # i can do a unique code for every function
                    pyautogui.moveTo(int(parts[0]), int(parts[1]))  # it wants int
                if data.__contains__('P2lw60'):
                    print(data)
                    data = data.replace('P2lw60', "")
                    print(data)
                    pyautogui.write(data, interval=0.10)
                if data == "A4up21":  # move up
                    pyautogui.move(0, -10)
                if data == "A4dw21":  # move down
                    pyautogui.move(0, 10)
                if data == "A4lt21":  # move left
                    pyautogui.move(10, 0)
                if data == "A4rt21":  # move right
                    pyautogui.move(-10, 0)
                if data == "S3hu22":
                    pyautogui.press('enter')
                if data == "S7tl23":
                    pyautogui.press('backspace')
            else:
                imgdata = imgdata.decode()
                imgdata = base64.b64decode(imgdata)
                print("hope")
                filename = input("Please enter file name: ") + ".jpg"  # "test_out.jpg"
                if "/" in filename or "%" in filename:  # all illegal file characters
                    filename = "test_out.jpg"
                print(filename)
                with open(filename, 'wb') as f:
                    f.write(imgdata)
                    # f gets closed when you exit the with statement
                    # Now save the value of filename to your database
                path = filedialog.askdirectory()
                shutil.move(filename, path)  # maybe add feature to create dir
                # if user_name != "":
                #     # i don't want all the users to see where the file is @ (at)
                #     img_message = user_name + " has sent an image and"  # it is stored in " + path
                #     print(user_name + " has sent an image and it is stored in " + path)
                #     messages_to_send.append((current_socket, img_message))
                # else:
                #     img_message = "User has sent an image"
                #     print("User has sent an image and it is stored in " + path)
                #     messages_to_send.append((current_socket, img_message))
        # send_waiting_messages(wlist, messages_to_send) TODO: need to work on def send_waiting_messages

    finally:
        sock.close()


if __name__ == '__main__':
    # security_protocol()  # this will ensure only right personal can use
    main()
