class Board
  def initialize(player, board)
    @player = player] 
    @board = board
  end

  def board(lines)
    lines.each do  |x|
      puts x
    end
  end

  def player_role(player)  
    player.each_with_index do |val,ind| 
      puts "Player name #{val}"
      puts "Player index #{ind}"
    end
  end

  def sum(a,b)
    sum=a+b)  
  end

end
