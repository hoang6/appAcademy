require 'byebug'
require 'yaml'

class Tile
  attr_reader :pos, :board
  attr_accessor :value, :revealed, :flagged, :bombed

  def initialize(pos, board)
    @bombed = false
    @pos = pos

    @flagged = false
    @revealed = false
    @board = board
    @value = @board[@pos]
  end

  def reveal
    @revealed = true

    if @value == '*'
      @board.lost = true
    elsif @value > 0
      @board[@pos] = @value
    elsif @value == 0
      queue = [self]
      visited_tiles = [self]
      @board[@pos] = '_'

      until queue.empty?
        tile = queue.shift
        neighbor_tiles = tile.get_neighbor_tiles

        neighbor_tiles.each do |neighbor|
          neighbor.revealed = true

          if neighbor.value > 0
            @board[neighbor.pos] = neighbor.value
          elsif neighbor.value == 0 && !visited_tiles.include?(neighbor)
            queue << neighbor
            visited_tiles << neighbor
            @board[neighbor.pos] = '_'
          end
        end
      end

    end
  end

  def place_flag
    @revealed = true
    @flagged = true # can make something like out of bomb
    @board[@pos] = 'F'
  end

  def neighbors
    neighbors = []
    (-1..1).each do |i|
      (-1..1).each do |j|
        neighbor_pos = [@pos[0] + i, @pos[1] + j] unless i == 0 && j == 0
        neighbors << neighbor_pos if self.board.valid_tile?(neighbor_pos)
      end
    end

    neighbors
  end

  def get_neighbor_tiles
    @board.tiles.select { |tile| self.neighbors.include?(tile.pos) }
  end

  # def inspect
  #   "Bombed? #{@bombed} - Flagged? #{@flagged} - Revealed? #{@revealed}"
  # end

  def neighbor_bomb_count
    count = 0

    neighbors.each do |neighbor|
      count += 1 if @board.has_bomb?(neighbor) == true
    end

    count
  end
end

class Board
  attr_accessor :board, :lost, :won
  attr_reader :tiles

  def initialize(size, num)
    @size = size
    @board = Array.new(size) { Array.new(size) {'+'} }

    @coords_list = coords_list
    @bomb_locations = generate_bomb(num)

    @tiles = Array.new
    @won = @lost = false

    @coords_list.each do |coords|
      tile = Tile.new(coords, self)
      tile.value = @bomb_locations.include?(coords) ? '*' : 0
      @tiles << tile
    end

    @tiles.each do |tile|
      tile.value = tile.neighbor_bomb_count unless tile.value == '*'
    end

  end

  def valid_tile?(pos)
    return true if @coords_list.include?(pos)
    false
  end

  def generate_bomb(num)
    bomb_locations = @coords_list.sample(num)
    # @bomb_locations.each { |pos| self[pos] = '*' }
  end

  def has_bomb?(pos)
    return true if @bomb_locations.include?(pos)
    false
  end

  def [](pos)
    x, y = pos
    @board[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @board[x][y] = value
  end

  def coords_list
    list = []
    @size.times do |row|
      @size.times do |col|
        list << [row, col]
      end
    end

    list
  end

  def get_move
    puts "Enter move: Mark X Y"
    gets.chomp
  end

  def handle_move(input)
    input = input.split(' ')

    mark = input[0]
    x = input[1].to_i
    y = input[2].to_i

    coords = [x, y]

    if mark.downcase == 'r'
      tile = @tiles.select { |tile| tile.pos == coords }
      tile.first.reveal

    elsif mark.downcase == 'f'
      tile = @tiles.select { |tile| tile.pos == coords }
      tile.first.place_flag
    end
  end

  def display_board
    (0...@size).each do |row|
      (0...@size).each do |col|
        # pos = [row, col]
        if col == @size - 1
          print "#{self[[row, col]]}  "
          puts
        elsif col == 0
          print "#{self[[row, col]]}  "
        else
          print "#{self[[row, col]]}  "
        end
      end
    end
  end

  def won?
    @tiles.all? { |tile| tile.revealed == true }
  end

  def lost?
    @lost
  end

  def save?(input)
    contents = self.to_yaml
    if input == 'y'
      file = File.open('minesweeper.yml', 'w')
      file.puts contents
      file.close

      exit
    end
  end

  def self.load
    YAML.load_file('minesweeper.yml')
  end

  def run
    until won? || lost?
      display_board
      handle_move(get_move)
      # puts "Won: #{won?} | Lost: #{lost?}"

      puts "Want to save game for later?"
      input = gets.chomp.downcase
      save?(input)
    end


    if won?
      display_board
      puts "Congrats, you won!"
    elsif lost?
      display_board
      puts "Damn, good luck next time!"
    end
  end

end

# game = Board.new(9, 5)
# game.run
