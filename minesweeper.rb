require 'byebug'
require 'yaml'
require_relative './board'
require_relative './tile'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def display(highlight = nil)
    puts @board.render(highlight)
  end

  def prompt_for_load
    if File.exist?('minesweeper_save.yml')
      puts "Continue previous game (c) or start new game? (n)"
      choice = gets.chomp
      if choice.downcase == 'c'
        @board = load_game
      end
    end
  end

  def parse_coordinates(input)
    coordinates = input.split(' ')
    x = coordinates.first.strip.to_i
    y = coordinates.last.strip.to_i

    return [x,y]
  end

  def play
    prompt_for_load

    until won? || lost?
      display

      puts "Enter a coordinate (e.g. 5 6), or save (s):"
      prompt = gets.chomp
      if prompt.downcase == 's'
        save_game
        return nil
      else
        coordinates = parse_coordinates(prompt)

        next if coordinates.count != 2 || @board.coordinates_in_bounds(*coordinates)
        display(coordinates)
      end

      puts "Reveal: r, Flag: f, Unflag: u"
      choice = gets.chomp

      if choice == 'r'
        if @board[*coordinates].flagged
          puts "Can't reveal a flagged tile"
        else
          @board[*coordinates].reveal
        end
      elsif choice == 'f'
        @board[*coordinates].flagged = true
      elsif choice == 'u'
        @board[*coordinates].flagged = false
      else
        puts "Invalid command"
      end
    end

    display
    if won?
      puts "You win!"
    else
      puts "You died."
    end
  end

  def won?
    @board.solved?
  end

  def lost?
    @board.exploded?
  end

  def save_game
    File.open('minesweeper_save.yml', 'w') do |f|
      f.puts @board.to_yaml
    end
  end

  def load_game
    YAML.load_file('minesweeper_save.yml')
  end
end
