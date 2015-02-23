class Tile
  attr_writer :bomb
  attr_accessor :neighbors, :flagged
  attr_reader :revealed

  def initialize
    @bomb = false
    @flag = false
    @revealed = false
    @neighbors = []
  end

  def render
    unless @revealed
      if @flagged
        return "F"
      else
        return "*"
      end
    else #revealed
      if @bomb
        return "B"
      elsif 0 ==  bombs_nearby
        return '_'
      else
        return "#{bombs_nearby}"
      end
    end
  end


  def is_bomb?
    @bomb
  end

  def reveal
    #debugger
    return nil if @revealed
    @revealed = true
    return nil if @bomb || bombs_nearby > 0

    @neighbors.each do |neighbor|
      neighbor.reveal
    end
  end

  private

  def bombs_nearby
    bombs_nearby = 0
    @neighbors.each do |neighbor|
      bombs_nearby += 1 if neighbor.is_bomb?
    end

    bombs_nearby
  end
end
