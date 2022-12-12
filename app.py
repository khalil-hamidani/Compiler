from cProfile import run
from logging import root
from tkinter import *
import tkinter as tk
import subprocess
from turtle import width

root=tk.Tk()

root.configure(background = '#c49e85')
root.geometry("700x500")
#! window name
root.title("Part 2")


def clear():
    word1_field.delete(0,END)
    word2_field.delete(1.0,END)  

def run():
    input1=word1_field.get()
    word2_field.delete(1.0,END) 
    test1=subprocess.run(f"java WordsMain {input1}",capture_output=True,shell=True).stdout
    test1.decode(encoding="UTF-8")
    word2_field.insert(1.0, test1)
def pp():
    subprocess.Popen(r"C:\Users\RGB\Desktop\coding\TpTHL\part0.exe")
    root.quit()
    root.destroy()

headlabel = Label(root, text = 'Partie 2 de TP THL : ',bg = "#c49e85",font=50)
headlabel.grid(row = 0, column = 0 ,columnspan=2)

label1 = Label(root, text = "Donner la longueur des mots:", bg = '#c49e85',font=50)
label1.grid(row = 1, column = 0  , pady=(5,0))

word1_field = Entry( width=4 ,bg="#ffd6af" ,font=('Arial', 17 ))
word1_field.grid(row = 2, column = 0,pady=1, padx=0)

button1 = Button(root, text = "Run",bg="#6b4b3e",fg="#ffd6af",font=50, command=run)
button1.grid(row = 2, column = 0,padx=(200,0), pady=5,columnspan=1)

word2_field = Text( width=30 ,height=13 ,bg="#ffd6af" , font=('Arial', 15))
word2_field.grid(row = 3, column = 0, padx=(6,8) , columnspan=2 )

button2 = Button(root, text = "Clear",bg="#6b4b3e",fg="#ffd6af",font=50 ,command= clear)
button2.grid(row = 5, column = 0, pady=5,columnspan=2 )

button3 = Button(root, text = "Programme principal", bg="#6b4b3e",fg="#ffd6af", font=50, command=pp)
button3.grid(row = 5, column = 2, pady=1 )

word4_field = Text( width=30 ,height=18 ,bg="#ffd6af" , font=('Roboto', 15))
word4_field.grid(row = 0, column = 2, padx=7 ,pady=(20,10), rowspan=5)
text="         Langage et grammaires :                                                                  Soit un langage L(G) généré par la                                                            grammaire G=<T, N, S, P> tel que :                                                              T={a, b}         N={S, A, B, C}                                                                    P : S→AB        A→aA/bA/ab                                                                     B→bC            C→aC/bC/ɛ                                                                 Ce programme permet de générer    tous les mots de L(G) d’une longueur donnée n (n ≥ 0).                                                                                     Travaille de : Labtani Sarah Daouia    Design de : khalil hamidani"
word4_field.insert(1.0,text)
word4_field.config(state=DISABLED)
root.mainloop()
