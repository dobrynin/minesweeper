require_relative 'tile.rb'
require 'byebug'

class Board
  attr_reader :grid

  def initialize
    @grid = create_grid
  end

  def create_grid
    grid = []
    9.times do |i|
      row = []
      9.times do |j|
        pos = [i, j]
        board = self
        bools = [true] + [false] * 10
        bombed = bools.sample
        row << Tile.new(board, pos, bombed)
      end
      grid << row
    end

    grid
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def render
    puts "  " + (0..8).to_a.join(" ")
    @grid.each_with_index do |row, i|
      puts "#{i} #{row.join(" ")}"
    end
  end

  def end_reveal
    @grid.flatten.each(&:reveal)
  end

end
