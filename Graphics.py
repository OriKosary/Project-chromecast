from tkinter import *
import tkinter as tk

import keyboard as keyboard


class GUI(object):
    root = None  # type -> tk

    text = None  # type -> text
    input_text = None  # type -> string

    wait = True

    def __init__(self, root):
        self.root = root
        self.init_texts()
        self.place_all()

    def init_texts(self):
        self.text = tk.Text(master=self.root, width=60, height=1)
        self.text.bind('<Return>', lambda e: self.inputs(True))

    def place_all(self):
        self.text.place(x=0, y=100)

    def inputs(self, is_backspace):
        if is_backspace:
            keyboard.press_and_release('backspace')
            self.wait = False
        self.input_text = self.text.get('1.0', 'end-1c')
        fin__input = self.input_text
        # if u want to connect one after the other delete the next line
        self.root.destroy()
        return fin__input


if __name__ == '__main__':
    root = Tk()
    gui = GUI(root=root)
    root.mainloop()
