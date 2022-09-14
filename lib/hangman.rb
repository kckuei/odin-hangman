# graphics module
module Graphics
  LOGO = "
  +---+ ██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗
  |   | ██║  ██║██╔══██╗████╗  ██║██╔════╝ ████╗ ████║██╔══██╗████╗  ██║
  O   | ███████║███████║██╔██╗ ██║██║  ███╗██╔████╔██║███████║██╔██╗ ██║
 /|\\  | ██╔══██║██╔══██║██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██║██║╚██╗██║
 / \\  | ██║  ██║██║  ██║██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║
      | ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
========================================================================
"

  HANGMANPICS = ["
  +---+
  |   |
      |
      |
      |
      |
=========", "
  +---+
  |   |
  O   |
      |
      |
      |
=========", "
  +---+
  |   |
  O   |
  |   |
      |
      |
=========", "
  +---+
  |   |
  O   |
 /|   |
      |
      |
=========", "
  +---+
  |   |
  O   |
 /|\\  |
      |
      |
=========", "
  +---+
  |   |
  O   |
 /|\\  |
 /    |
      |
=========", "
  +---+
  |   |
  O   |
 /|\\  |
 / \\  |
      |
========="]
end

# Query module
module Query
  def alpha_characters?(string)
    !string.match(/\A[a-zA-Z]*\z/).nil?
  end

  def word?(string)
    !string.nil? && alpha_characters?(string)
  end

  def letter?(string)
    word?(string) && string.length == 1
  end

  def guessing_word?(string)
    if string.split(' ')[0] == '-w'
      puts "User enetered a word: #{string.split(' ')[1..]}"
      return true
    end
    false
  end

  def valid_word_input?(string)
    splits = string.split(' ')
    return true if splits[0] == '-w' && splits.length == 2 && word?(splits[1])

    false
  end

  def valid_input
    'Enter a single letter A-Z, or a word using the -w flag: -w <your word>.'
  end

  def invalid_input(input)
    puts "Invalid input: #{input}. #{valid_input}"
  end

  def user_input
    puts valid_input
    input = gets.downcase.chomp
    loop do
      if guessing_word?(input)
        break if valid_word_input?(input)
      elsif letter?(input)
        break
      end
      invalid_input(input)
      input = gets.downcase.chomp
    end
    input
  end
end

# Intro class
class Intro
  include Graphics
  def game_intro
    puts LOGO
    puts "\n\nEnter any key to continue."
    gets
    show_menu
    gets
  end

  def show_menu
    puts " Menu:
    1: Play new game
    2. Load saved game
    3: Help/How to Play
    4. Leaderboard
    5: Quit
    "
  end
end

# Hangman class
class Hangman
  attr_reader :dict

  include Graphics

  def initialize
    @intro = Intro.new
    @dict = Dictionary.new('./../dictionary/google-10000-english-no-swears.txt', 1337)
  end
end

# Dictionary class
class Dictionary
  attr_reader :words

  def initialize(dict_path, seed = 1234)
    file = File.open(dict_path, 'r')
    @words = file.readlines.map(&:chomp)
    file.close
    @random = Random.new(seed)
  end

  def random_word
    random_num = @random.rand(@words.length)
    @words[random_num]
  end
end

# Serializer class
class Serializer; end

# Display class
class Display; end

# Player class
class Player
  def initialize
    @wins = 0
  end
end

# Computer class
class Computer < Player
  attr_reader :word

  def initialize
    super
    @word = nil
  end

  def choose_word(dictionary)
    @word = dictionary.random_word
  end
end

# Human class
class Human < Player
  include Query

  def initialize
    super
  end

  def make_guess
    user_input
  end
end

game = Hangman.new

computer = Computer.new

player = Human.new

word = computer.choose_word(game.dict)
puts "Chosen word is: #{word}"

player.make_guess
