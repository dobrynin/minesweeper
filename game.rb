require_relative 'board.rb'
require 'byebug'
class Game
  attr_reader :board
  def initialize
    @board = Board.new
  end

  def play
    until game_over?
      @board.render
      play_turn
    end
    @board.end_reveal
    @board.render
  end

  def game_over?
    lose = @board.grid.flatten.any? do |tile|
      tile.bombed && tile.revealed
    end

    win = @board.grid.flatten.all? do |tile|
      if tile.bombed
        true
      elsif tile.revealed
        true
      else
        false
      end
    end

    puts "You lose!" if lose
    puts "You win!" if win

    win || lose
  end

  def play_turn
    pos = get_pos
    choice = get_choice
    if choice == 'r'
      reveal_tiles(@board[pos])
    else
      @board[pos].flag
    end
  end

  def reveal_tiles(tile)
    tile.reveal
    if tile.neighbor_bomb_count == 0
      tile.neighbors.each do |neighbor|
        reveal_tiles(neighbor) unless neighbor.revealed
      end
    end
  end

  def get_pos
    pos = nil
    until pos && valid_pos?(pos)
      puts "Please enter a position on the board (e.g., '3,4')"
      print "> "

      begin
        pos = parse_pos(gets)
      rescue
        puts "Invalid position entered (did you use a comma?)"
        puts ""

        pos = nil
      end
    end
    pos
  end

  def valid_pos?(pos)
    puts "Already revealed!" if @board[pos].revealed
    pos.is_a?(Array) &&
    pos.length == 2 &&
    pos.all? { |x| x.between?(0, 8) } &&
    !@board[pos].revealed
  end

  def parse_pos(pos)
    pos.split(",").map(&:to_i)
  end

  def get_choice
    choice = nil
    until choice && valid_choice?(choice)
      puts "Please enter 'r' to reveal a square or 'f' to flag/unflag a bomb."
      print "> "
      choice = gets.chomp.downcase
    end
    choice
  end

  def valid_choice?(choice)
    ['r', 'f'].include?(choice)
  end

end

Game.new.play
