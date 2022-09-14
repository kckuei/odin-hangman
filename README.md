# odin-hangman
Toy command line Hangman game implemented with `ruby` using OOP and mixins. Includes I/O serializations/deserialization for saving and loading game state.

### Background
* [Hangman wiki](https://en.wikipedia.org/wiki/Hangman_(game))
* [Google 10000 english dictionary file](https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt)

### Example Game
```
  +---+ ██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗
  |   | ██║  ██║██╔══██╗████╗  ██║██╔════╝ ████╗ ████║██╔══██╗████╗  ██║
  O   | ███████║███████║██╔██╗ ██║██║  ███╗██╔████╔██║███████║██╔██╗ ██║
 /|\  | ██╔══██║██╔══██║██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██║██║╚██╗██║
 / \  | ██║  ██║██║  ██║██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║
      | ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
========================================================================


Enter any key to continue.


Menu:
    1: Play new game
    2. Load saved game
    3: Help/How to Play
    4: Quit
1
Computer chose a word: dean

  +---+
  |   |
      |
      |
      |
      |
=========
Guesses: 
_ _ _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
d

  +---+
  |   |
  O   |
      |
      |
      |
=========
Guesses: d
d _ _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
e

  +---+
  |   |
  O   |
  |   |
      |
      |
=========
Guesses: d, e
d e _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
-w dean
User enetered a word: ["dean"]

  +---+
  |   |
  O   |
 /|   |
      |
      |
=========
Guesses: d, e, dean
d e a n

Player wins!

Wins:1, Losses: 0
Computer chose a word: hans

Menu:
    1: Continue playing
    2. Save game
    3: Quit
1

  +---+
  |   |
      |
      |
      |
      |
=========
Guesses: 
_ _ _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
a

  +---+
  |   |
  O   |
      |
      |
      |
=========
Guesses: a
_ a _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
n

  +---+
  |   |
  O   |
  |   |
      |
      |
=========
Guesses: a, n
_ a n _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
s

  +---+
  |   |
  O   |
 /|   |
      |
      |
=========
Guesses: a, n, s
_ a n s 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
b

  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========
Guesses: a, n, s, b
_ a n s 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
h

  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========
Guesses: a, n, s, b, h
h a n s 

Player wins!

Wins:2, Losses: 0
Computer chose a word: lyrics

Menu:
    1: Continue playing
    2. Save game
    3: Quit
1

  +---+
  |   |
      |
      |
      |
      |
=========
Guesses: 
_ _ _ _ _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
i

  +---+
  |   |
  O   |
      |
      |
      |
=========
Guesses: i
_ _ _ i _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
s

  +---+
  |   |
  O   |
  |   |
      |
      |
=========
Guesses: i, s
_ _ _ i _ s 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
o

  +---+
  |   |
  O   |
 /|   |
      |
      |
=========
Guesses: i, s, o
_ _ _ i _ s 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
l

  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========
Guesses: i, s, o, l
l _ _ i _ s 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
-w lyrics
User enetered a word: ["lyrics"]

  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========
Guesses: i, s, o, l, lyrics
l y r i c s

Player wins!

Wins:3, Losses: 0
Computer chose a word: installations

Menu:
    1: Continue playing
    2. Save game
    3: Quit
3

Exiting game. Bye!
```