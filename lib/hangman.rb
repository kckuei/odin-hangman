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

  def show_hangman(index)
    puts HANGMANPICS[index]
  end
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
    puts "\n #{valid_input}"
    input = gets.downcase.chomp
    loop do
      if guessing_word?(input)
        if valid_word_input?(input)
          input = input.split(' ')[1]
          break
        end
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
  attr_reader :dict, :intro

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

# Serializer class - placeholder, will be use for saving/loading game
class Serializer; end

# Display class
class Display
  include Graphics

  def initialize(word)
    @word = word
  end

  def render(guesses)
    show_hangman(guesses.length)
    Display.show_guesses(guesses)

    if guesses.key?(@word)
      puts @word.downcase.split('').join(' ')
    else
      output = ''
      Array(@word.split('')).each do |char|
        output << if guesses[char].positive?
                    "#{char.downcase} "
                  else
                    '_ '
                  end
      end
      puts output
    end
  end

  def self.show_guesses(guesses)
    puts "Guesses: #{guesses.keys.join(', ')}"
  end
end

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

  def right_word?(word)
    word == @word
  end
end

# Human class
class Human < Player
  attr_reader :guesses

  include Query

  def initialize
    super
    @guesses = Hash.new(0)
  end

  def make_guess
    guess = user_input
    loop do
      if @guesses[guess].zero?
        @guesses[guess] += 1
        break
      else
        puts "You already guessed `#{guess}`!"
        guess = user_input
      end
    end
  end
end

game = Hangman.new

game.intro.game_intro

computer = Computer.new

player = Human.new

word = computer.choose_word(game.dict)
puts "Computer chose a word: #{word}" # uncomment for debugging

display = Display.new(word)

display.render(player.guesses)

player.make_guess # first guess
player.make_guess # second guess

display.render(player.guesses)

## Next implement the following functionalities...
# 1 - new game
# 5 - quit
# 2, 3, or 4 - not implemented yet

## Implement one full game round
# choose word
# do-loop ...
#  make guess
#  display
#  win?
# end
# if lose/win - continue? or exit?
#    if continue -> to a new word
#                   & increment user score or loss
#    if exit     -> ask for user name for scoreboard

## Implement serilization
#
