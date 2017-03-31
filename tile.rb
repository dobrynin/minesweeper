require 'byebug'
require 'colorize'

class Tile
  attr_reader :pos, :revealed, :bombed

  def initialize(board, pos, bombed)
    @board = board
    @pos = pos
    @bombed = bombed
    @flagged = false
    @revealed = false
  end

  def reveal
    @revealed = true
  end

  def flag
    @flagged ? @flagged = false : @flagged = true
  end

  def neighbors
    neighbs = []
    i, j = @pos
    ((i-1)..(i+1)).each do |row|
      ((j-1)..(j+1)).each do |col|
        neighbs << @board[[row, col]] unless [row, col] == @pos ||
          !row.between?(0, 8) || !col.between?(0, 8)
      end
    end

    neighbs
  end

  def neighbor_bomb_count
    neighbors.count(&:bombed)
  end

  def inspect
    {
      'position' => @pos,
      'bombed' => @bombed,
      'flagged' => @flagged,
      'revealed' => @revealed
    }.inspect
  end

  def to_s
    if @revealed
      if @bombed
        "💣"
      else
        bomb_count = neighbor_bomb_count
        bomb_count > 0 ? neighbor_bomb_count.to_s : "□"
      end
    elsif @flagged
      "⚑".colorize(:red)
    else
      "▣"
    end
  end
end
