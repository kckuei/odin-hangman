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

  def game_intro(game)
    puts LOGO
    puts "\n\nEnter any key to continue."
    gets

    show_intro_menu
    intro_menu_input(game)
  end

  def game_outro(game)
    show_outro_menu
    outro_menu_input(game)
  end

  def show_intro_menu
    puts "\nMenu:
    1: Play new game
    2. Load saved game
    3: Help/How to play
    4: Quit"
  end

  def show_outro_menu
    puts "\nMenu:
    1: Continue playing
    2. Save game
    3: Quit"
  end

  def intro_menu_input(game)
    choice = gets.chomp.to_i
    case choice
    when 1
      puts "New game selected!\n\n"
    when 2
      ## placeholder for loading
      # game.serializer.class.list_hangman_saves
      # game.serializer.deserialize()
      puts 'load saved game'
    when 3
      puts "\nR U L E S:  How to Play Hangman
    a. The computer picks a word of length N from the dictionary at random.
    b. The player must guess that word, which is comprised of letters from the alphabet (characters from a-z).
    c. The player gets at most 6 guesses to guess the correct word.
    d. The player may guess individual letters, or whole words.
    e. To guess whole words, precede the input with a '-w' flag.
    f. For example, to guess the word 'supercalifragilisticexpialidocious', enter:

         -w supercalifragilisticexpialidocious

    g. Have fun!
      "
      show_intro_menu
      intro_menu_input(game)
    when 4
      exit_game
      'exit'
    else
      puts "\nInvalid input: #{choice}. Pick an option from the menu."
      show_intro_menu
      intro_menu_input(game)
    end
  end

  def outro_menu_input(game)
    choice = gets.chomp.to_i
    case choice
    when 1
      game.continue
    when 2
      puts game.serializer
      game.save_game
      show_outro_menu
      outro_menu_input(game)
    when 3
      exit_game
    else
      puts "\nInvalid input: #{choice}. Pick an option from the menu."
      show_outro_menu
      outro_menu_input(game)
    end
  end

  def exit_game
    puts "\nExiting game. Bye!"
  end
end

# Hangman class
class Hangman
  attr_reader :dict, :intro, :serializer

  include Graphics

  def initialize
    @intro = Intro.new
    @dict = Dictionary.new('./../dictionary/google-10000-english-no-swears.txt', 1337)
    @player = Human.new
    @computer = Computer.new
    @serializer = Serializer.new
    @display = nil
  end

  def save_game
    @serializer.serialize(self)
  end

  def load_game(path)
    ## placeholder
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
    flag = @intro.game_intro(self)
    return if flag == 'exit'

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

# Serializer class
class Serializer
  def initialize(dirname = './saves')
    @dirname = dirname
  end

  def serialize(game)
    Dir.mkdir(@dirname) unless File.exist? @dirname
    str = Marshal.dump(game)
    File.open(@dirname << '/saved_state.hangman', 'w') { |f| f.puts(str) }
  rescue StandardError => e
    puts "Ran into an error when opening the hangman save file: #{e}"
  else
    puts 'Successfully saved game...'
  ensure
    puts "**Excited R2D2 noises**\n"
  end

  def deserialize
    file = File.open(@dirname << '/saved_state.hangman', 'r')
  rescue StandardError => e
    puts "Ran into an error when opening the hangman save file: #{e}"
  else
    str = file.read
    file.close
    Marshal.load(str)
    puts 'Successfully loaded game...'
    # game = Marshal.load(str)
    # game.continue
  ensure
    puts "**Excited R2D2 noises**\n"
  end

  def self.list_hangman_saves
    Dir.glob(@dirname << '/*.{hangman}')
  end
end

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
