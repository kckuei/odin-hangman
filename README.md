# odin-hangman
Toy command line Hangman game implemented with `ruby` using OOP and mixins. Includes I/O serialization/deserialization for saving and loading game state.

### Background
* [Hangman wiki](https://en.wikipedia.org/wiki/Hangman_(game))
* [Google 10000 english dictionary file](https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt)

### Example Game - With Saving
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
    2. Continue last game
    3: Help/How to play
    4: Quit
3

R U L E S:  How to Play Hangman
    a. The computer picks a word of length N from the dictionary at random.
    b. The player must guess that word, which is comprised of letters from the alphabet (characters from a-z).
    c. The player gets at most 6 guesses to guess the correct word.
    d. The player may guess individual letters, or whole words.
    e. To guess whole words, precede the input with a '-w' flag.
    f. For example, to guess the word 'supercalifragilisticexpialidocious', enter:

         -w supercalifragilisticexpialidocious

    g. Have fun!
      

Menu:
    1: Play new game
    2. Continue last game
    3: Help/How to play
    4: Quit
1
New game selected!


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
e

  +---+
  |   |
  O   |
      |
      |
      |
=========
Guesses: e
_ e _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
a

  +---+
  |   |
  O   |
  |   |
      |
      |
=========
Guesses: e, a
_ e a _ 

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
Guesses: e, a, dean
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
h

  +---+
  |   |
  O   |
      |
      |
      |
=========
Guesses: h
h _ _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
n

  +---+
  |   |
  O   |
  |   |
      |
      |
=========
Guesses: h, n
h _ n _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
o

  +---+
  |   |
  O   |
 /|   |
      |
      |
=========
Guesses: h, n, o
h _ n _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
e

  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========
Guesses: h, n, o, e
h _ n _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
a

  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========
Guesses: h, n, o, e, a
h a n _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
s

  +---+
  |   |
  O   |
 /|\  |
 / \  |
      |
=========
Guesses: h, n, o, e, a, s
h a n s 

Player wins!

Wins:2, Losses: 0
Computer chose a word: lyrics

Menu:
    1: Continue playing
    2. Save game
    3: Quit
2
#<Serializer:0x00007f2faf324660>
Successfully saved game...
**Excited R2D2 noises**

Menu:
    1: Continue playing
    2. Save game
    3: Quit
3

Exiting game. Bye!
```


### Example Game - With Loading
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
    2. Continue last game
    3: Help/How to play
    4: Quit
2
Load saved game selected!

Successfully loaded game...
**Excited R2D2 noises**

  +---+
  |   |
      |
      |
      |
      |
=========
Guesses: 
_ _ _ _ _ _ _ _ _ _ _ _ _ 

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
i _ _ _ _ _ _ _ _ i _ _ _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
n

  +---+
  |   |
  O   |
  |   |
      |
      |
=========
Guesses: i, n
i n _ _ _ _ _ _ _ i _ n _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
-w intelligence
User enetered a word: ["intelligence"]

  +---+
  |   |
  O   |
 /|   |
      |
      |
=========
Guesses: i, n, intelligence
i n _ _ _ _ _ _ _ i _ n _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
o

  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========
Guesses: i, n, intelligence, o
i n _ _ _ _ _ _ _ i o n _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
a

  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========
Guesses: i, n, intelligence, o, a
i n _ _ a _ _ a _ i o n _ 

Enter a single letter A-Z, or a word using the -w flag: -w <your word>.
-w installations
User enetered a word: ["installations"]

  +---+
  |   |
  O   |
 /|\  |
 / \  |
      |
=========
Guesses: i, n, intelligence, o, a, installations
i n s t a l l a t i o n s

Player wins!

Wins:3, Losses: 0
Computer chose a word: blues

Menu:
    1: Continue playing
    2. Save game
    3: Quit
2
#<Serializer:0x00007f8933d04648>
Ran into an error when opening the hangman save file: Not a directory @ rb_sysopen - ./saves/saved_state.hangman/saved_state.hangman
**Excited R2D2 noises**

Menu:
    1: Continue playing
    2. Save game
    3: Quit
3

Exiting game. Bye!
```

### Future Improvements
* Add option to save and query multiple save states
* Add score/leaderboard
* Add option to add words to the dictionary