class Player
	attr_accessor :name, :mark

	def initialize(name, mark)
		@name = name
		@mark = mark
	end

end

class Game
	attr_accessor :player1, :player2, :game_info, :turn
	def initialize 
		possible_marks = ["\u25B3", "\u25C0", "\u25C9", "\u25CE", "\u25D3", "\u03F0", "\u0583"]
		@game_info = [[],[],[],[],[],[],[]]
		@player1 = Player.new("Player 1", possible_marks.sample)
		possible_marks.delete(@player1.mark)
		@player2 = Player.new("Player 2", possible_marks.sample)
		@board = Board.new
		@turn = @player1
		puts "Welcome to Connect Four! Command Line Edition! Yeah!\r\n#{@player1.name} your piece is #{@player1.mark}\r\n#{@player2.name} your piece is #{@player2.mark}"
	end
	def game_lobby
		play_again = play_game

		while play_again
			#clear board
			@game_info = [[],[],[],[],[],[],[]]
			play_again = play_game
		end
			puts "Alright! Goodbye now!"
		
	end
	def play_game
		game_over = false
			puts "#{@turn.name} Please choose a column to place your piece (1-7)" 
			input = get_input - 1
			@game_info[input].push(@turn.mark)
			puts @board.draw(@game_info)


		until game_over
			switch_turn
			puts "#{@turn.name} Please choose a column to place your piece (1-7)" 
			input = get_input - 1
			@game_info[input].push(@turn.mark)
			puts @board.draw(@game_info)

			game_over = game_over?(@game_info, @turn)
		end

		puts "Do you want to play again? (y/n)"
		play_again = gets.chomp.downcase
		until play_again == "y" or play_again == "n"
			puts "Invalid Input, Please type \"y\" or  \"n\""
		end
		return play_again.downcase == "y" ? true : false

	end

	def get_input
		input = gets.chomp.to_i
		until  valid_input(input, @game_info)
			puts "Invalid Input! Please try again"
			input = gets.chomp.to_i
		end
		input 
	end
	def valid_input(input, game_info)
		if input.to_i < 8 and input.to_i > 0
			if game_info[input.to_i - 1].length < 6
				return true
			end
		end
		false
	end

	def switch_turn
		@turn = (@turn == @player1) ? @player2 : @player1
	end
	# My attempt to build a DFS way of telling if the game is concluded
	# It will grab a root and try and branch out in each direction. 
	# Once a pattern is established it will continue in that "Direction" until 4 matches are made or those coordinates stop being matched.
	def game_over?(game_info, turn)
		# there is not a row
		full = true
		game_info.each do |list|
		# puts list.to_s 
			full = false if list.length < 6
		end
		if full
			puts "Board is full! Noone Wins!"
			return true
		end
		game_over = false
		stack = []
		check_mark = turn.mark
		root = nil
		game_info.each_with_index do |list, i|
			list.each_with_index do |mark, j|
				if mark == check_mark
					root = Node.new([i, j], 1)

					#if game info i - 1
					if game_info[i-1]
						if game_info[i-1][j] == check_mark 
							node = Node.new([i-1, j], 2, root)
							node.pattern = [-1, 0]
							root.add_child(node)

							stack.push(node)
						end
					end
					#if game info i + 1
					if game_info[i+1] 
						if game_info[i+1][j] == check_mark 

							node = Node.new([i+1, j], 2, root)
							node.pattern = [1, 0]
							root.add_child(node)
							stack.push(node)
						end
					end					

					#if "" j + 1
					if game_info[i][j+1] == check_mark 

						node = Node.new([i, j+1], 2, root)
						node.pattern = [0, 1]
						root.add_child(node)
						stack.push(node)

					end		
					#if "" j - 1
					if j > 3
						if game_info[i][j-1] == check_mark 

							node = Node.new([i, j-1], 2, root)
							node.pattern = [0, -1]
							root.add_child(node)
							stack.push(node)
						end

					end	
					#if "" i + 1 and j + 1 

		 			if game_info[i+1]
						if game_info[i+1][j+1] == check_mark
 
							node = Node.new([i+1, j+1], 2, root)
							node.pattern = [1, 1]
							root.add_child(node)
							stack.push(node)

						end						
					end
					#if "" i + 1 and j - 1
					if game_info[i+1] and j > 3 
						if game_info[i+1][j-1] == check_mark 

							node = Node.new([i+1, j-1], 2, root)
							node.pattern = [1, -1]
							root.add_child(node)
							stack.push(node)

						end
					end	
					#if "" i - 1 and j + 1 
					if game_info[i-1]
						if game_info[i-1][j+1] == check_mark 

							node = Node.new([i-1, j+1], 2, root)
							node.pattern = [-1, 1]

							root.add_child(node)
							stack.push(node)

						end	
					end
					#if "" i - 1 and j - 1 
					if game_info[i+1] and j > 3
						if game_info[i+1][j-1] == check_mark 

							node = Node.new([i-1, j-1], 2, root)
							node.pattern = [1, 1]
							root.add_child(node)
							stack.push(node)

						end	
					end

					until stack == []
							current = stack.pop

						if current.increment == 4
							puts "#{turn.name} Wins!"
							return true

						else
							new_i = current.value[0]+ current.pattern[0]
							new_j = current.value[1]+ current.pattern[1]
							if game_info[new_i]
								if game_info[new_i][new_j] == check_mark
									node = Node.new([new_i, new_j], current.increment + 1, current)
									node.pattern = current.pattern
									current.add_child(node)
									stack.push(node)
									

								end
							end	

						end
					end

				end
			end
		end

		game_over
	end

end

class Node
	attr_accessor :value, :children, :parent, :pattern, :increment

	def initialize(value, increment, parent = nil, children = [] )
		@value = value
		@children = children
		@parent = parent
		@pattern = nil
		@increment = increment
	end

	def add_child(child)
		@children.push(child)
	end

	
end

class Board

	def draw input = []
		drawn_board = "
|   |   |   |   |   |   |   |
| [5,0] | [5,1] | [5,2] | [5,3] | [5,4] | [5,5] | [5,6] |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
| [4,0] | [4,1] | [4,2] | [4,3] | [4,4] | [4,5] | [4,6] |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
| [3,0] | [3,1] | [3,2] | [3,3] | [3,4] | [3,5] | [3,6] |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
| [2,0] | [2,1] | [2,2] | [2,3] | [2,4] | [2,5] | [2,6] |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
| [1,0] | [1,1] | [1,2] | [1,3] | [1,4] | [1,5] | [1,6] |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
| [0,0] | [0,1] | [0,2] | [0,3] | [0,4] | [0,5] | [0,6] |
|___|___|___|___|___|___|___|"
		input.each_with_index do |list, i|
			list.each_with_index do |mark, j|
				idx = "[#{j},#{i}]"
				drawn_board.gsub!(idx, mark)
			end
		end
		drawn_board.gsub!(/\[\d\,\d\]/, " ")
		drawn_board
	end
end

