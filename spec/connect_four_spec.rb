require 'spec_helper'

# test getting input from new player, choosing piece
describe Player do
	before :each do 
		@player = Player.new("Player 1", "\u25B3")
	end

	it "creates player" do
		expect(@player).to be_an_instance_of Player
	end

	it "is creates a name" do
		expect(@player.name).to eq("Player 1")
	end

	it "forces choice of a piece" do
		expect(@player.mark).to eq("\u25B3")
	end

end

describe Board do
	let(:board) {Board.new}

	it "draws the blank board" do
		expect(board.draw).to eq("
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |
|___|___|___|___|___|___|___|")
	end

	it "draws a gameplay board" do
		input = [["X", "O"],["X", "X"],["O", "X", "O"],[],[],["O"],["X", "O"]]
		expect(board.draw(input)).to eq("
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
|   |   | O |   |   |   |   |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
| O | X | X |   |   |   | O |
|___|___|___|___|___|___|___|
|   |   |   |   |   |   |   |
| X | X | O |   |   | O | X |
|___|___|___|___|___|___|___|")

	end
end

describe Game do
	let(:game) { Game.new }

	context "startup runs correctly" do

		it "sets players 1 & 2 and set a piece" do
			expect(game.player1.name).to eq("Player 1")
			expect(game.player2.name).to eq("Player 2")
			expect(game.player1.mark).to be_truthy
			expect(game.player2.mark).to be_truthy

		end

	end

	context "win conditions should win" do


		it "returns false when there is no win condition" do
			game.player1.mark = "X"
			game.player2.mark = "O"
			test_info = [[],[],[],[],["X"],["X","X"],[]]
			expect(game.game_over?(test_info, game.turn)).to eq(false)
		end
		it "returns true when the board is full" do
			game.player1.mark = "X"
			game.player2.mark = "O"
			test_info = [["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],]
			expect(game.game_over?(test_info, game.turn)).to eq(true)
		end

		#horizontal win
		it "returns true when there is a horizontal win" do
			p1 = game.player1.mark
			p2 = game.player1.mark
			test_info = [[p1, p2],[p1, p2],[p1, p2],[p1, p2],[],[],[]]
			expect(game.game_over?(test_info, game.turn)).to eq(true)

		end
		#diagonal win
		it "returns true when there is a diagonal win" do
			p1 = game.player1.mark
			p2 = game.player1.mark
			test_info = [[p1,p1,p1,p1],[p2,p2,p1, p2],[p2, p1],[p1],[],[],[]]
			expect(game.game_over?(test_info, game.turn)).to eq(true)

		end

		#vertical win
		it "returns true when there is a vertical win" do
			p1 = game.player1.mark
			p2 = game.player1.mark
			test_info = [[p1,p1,p1,p1],[p2,p2,p2],[],[],[],[],[]]
			expect(game.game_over?(test_info, game.turn)).to eq(true)

		end
		it "returns false when there is no win" do
			p1 = game.player1.mark
			p2 = game.player1.mark
			test_info = [[p1,p1,p1,p1],[p2,p2,p1, p2],[p2, p1],[p2],[p1],[p2],[p1, p2]]
			expect(game.game_over?(test_info, game.turn)).to eq(true)

		end
	end

	it "switch_turn should switch turns" do
		game.switch_turn
		expect(game.turn).to eq(game.player2)
	end
	context "valid input works correctly" do
		before :all do
			@test_info = [[],[],[],[],["X","X","X","X","X"],["X","X","X","X","X","X"],[]]
		end
		it "does not allow illegal column" do
			expect(game.valid_input("8", @test_info)).to eq(false)
		end

		it "does not allow full columns" do
			expect(game.valid_input("6", @test_info)).to eq(false)
		end

		it "allows a legal move" do
			expect(game.valid_input("5", @test_info)).to eq(true)
			expect(game.valid_input("1", @test_info)).to eq(true)
		end
	end
end



# test starting a game

