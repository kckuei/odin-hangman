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
    puts "\n#{valid_input}"
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

# Intro class (maybe change to Menu/Navigation class)
class Intro
  include Graphics

  def game_intro
    puts LOGO
    puts "\n\nEnter any key to continue."
    gets
    show_intro_menu
    gets
  end

  def game_outro(game)
    show_outro_menu
    outro_menu_input(game)
  end

  def show_intro_menu
    puts "\nMenu:
    1: Play new game
    2. Load saved game
    3: Help/How to Play
    4. Leaderboard
    5: Quit"
  end

  def show_outro_menu
    puts "\nMenu:
    1: Continue playing
    2. Save game
    3: Quit"
  end

  def outro_menu_input(game)
    choice = gets.chomp.to_i
    case choice
    when 1
      game.continue
    when 2
      ## placeholder for save_game
    when 3
      exit_game
    else
      puts 'invalid choice'
    end
  end

  def exit_game
    puts "\nExiting game. Bye!"
  end
end

# Hangman class
class Hangman
  attr_reader :dict, :intro

  include Graphics

  def initialize
    @intro = Intro.new
    @dict = Dictionary.new('./../dictionary/google-10000-english-no-swears.txt', 1337)
    @player = Human.new
    @computer = Computer.new
    @display = nil
  end

  def make_display
    word = @computer.choose_word(@dict)
    @display = Display.new(word)
    puts "Computer chose a word: #{word}" # uncomment for debugging
  end

  def game_over?(guesses, word)
    return true if guesses.key?(word) || word_match_by_characters?(guesses, word) || guesses.length == 6
  end

  def win?(guesses, word)
    return true if (guesses.key?(word) || word_match_by_characters?(guesses, word)) && guesses.length <= 6
  end

  def word_match_by_characters?(guesses, word)
    Array(word.split('')).filter { |char| guesses.key?(char) }.length == word.length
  end

  def increment_scores(guesses, word)
    if win?(guesses, word)
      @player.wins += 1
      @computer.losses += 1
      puts "\nPlayer wins!\n"
    else
      @player.losses += 1
      @computer.wins += 1
      puts "\nPlayer loses!"
      puts "The correct word was: #{@computer.word.split('').join(' ')}.\n"
    end
    puts "\nWins:#{@player.wins}, Losses: #{@player.losses}"
  end

  def play_round
    loop do
      @display.render(@player.guesses)
      @player.make_guess
      next unless game_over?(@player.guesses, @computer.word)

      @display.render(@player.guesses)

      increment_scores(@player.guesses, @computer.word)
      break
    end
  end

  def new_game
    @intro.game_intro
    make_display
    continue
  end

  def continue
    play_round
    pick_new_word
    @player.reset_guesses
    @intro.game_outro(self)
  end

  def pick_new_word
    word = @computer.choose_word(@dict)
    @display.update_word(word)
    puts "Computer chose a word: #{word}" # uncomment for debugging
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

  def update_word(word)
    @word = word
  end
end

# Player class
class Player
  def initialize
    @wins = 0
    @losses = 0
  end
end

# Computer class
class Computer < Player
  attr_reader :word
  attr_accessor :wins, :losses

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
  attr_accessor :wins, :losses

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

  def reset_guesses
    @guesses = Hash.new(0)
  end
end

game = Hangman.new
game.new_game

# Need finish implementing menu/navigation
