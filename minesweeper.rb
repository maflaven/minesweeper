require 'byebug'
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

  def play
    until won? || lost?
      display

      puts "Enter a coordinate (e.g. 5 6), or save (s):"
      prompt = gets.chomp
      if prompt == 's'
        save_game
        return nil
      else
        coordinates = prompt.split(' ')
        next if coordinates.count != 2
        x = coordinates.first.strip.to_i
        y = coordinates.last.strip.to_i
      end

      display([x, y])

      puts "Reveal: r, Flag: f, Unflag: u"
      choice = gets.chomp

      if choice == 'r'
        if @board[x,y].flagged
          puts "Can't reveal a flagged tile"
        else
          @board[x,y].reveal
        end
      elsif choice == 'f'
        @board[x,y].flagged = true
      elsif choice == 'u'
        @board[x,y].flagged = false
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

end
