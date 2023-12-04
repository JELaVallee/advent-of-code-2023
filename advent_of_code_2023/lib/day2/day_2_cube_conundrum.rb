require 'pry'

module AdventOfCode2023
    class Game
        attr_reader :id, :bag

        def initialize(id:)
            @id = id
            @bag = BagOfCubes.new
            @turns = []
        end

        def parse_turns(turn_set)
            @turns = turn_set.split(';')
            @turns.each do |turn|
                parse_turn(turn)
            end
        end

        def parse_turn(turn)
            drawn_red = 0
            drawn_green = 0
            drawn_blue = 0

            drawn_cubes_set = turn.split(',')
            drawn_cubes_set.each do |drawn_cubes|
                draw = drawn_cubes.split(' ')
                drawn_red = draw[0].to_i if (draw[1] == 'red') 
                drawn_green = draw[0].to_i if (draw[1] == 'green') 
                drawn_blue = draw[0].to_i if (draw[1] == 'blue') 
                @bag.account_for(red: drawn_red, green: drawn_green, blue: drawn_blue)
            end
        end

        def can_play_with(red:, green:, blue:)
            ( @bag.red_max <= red && @bag.green_max <= green) && (@bag.blue_max <= blue)
        end
    end

    class BagOfCubes
        attr_reader :red_max, :blue_max, :green_max
        def initialize
            @red_max = 0
            @blue_max = 0
            @green_max = 0
        end

        def account_for(red:, green:, blue:)
            @red_max = red if (red > @red_max)
            @blue_max = blue if (blue > @blue_max)
            @green_max = green if (green > @green_max)
        end

        def power_of_bag
            @red_max * @blue_max * @green_max
        end
    end

    class Day2 
        def initialize()
            @part1_path = "./day_2_input_1.txt"
            @part2_path = "./day_2_input_2.txt"
            @total_red = 12
            @total_green = 13
            @total_blue = 14
        end

        def part1
            input_path = @part1_path
            games = []

            File.open(input_path, "r") do |file|
                file.each_line do |line|
                    game_and_turns = line.split(':')
                    game_number = game_and_turns[0].match(/\d+/)[0].to_i
                    game = Game.new(id: game_number)
                    game.parse_turns(game_and_turns[1])
                    games.push(game)
                end
            end

            rolling_total = 0

            games.each do |game|
                if game.can_play_with(red: @total_red, green: @total_green, blue: @total_blue)
                    rolling_total += game.id
                end
            end

            rolling_total
        end

        def part2
            input_path = @part1_path
            games = []

            File.open(input_path, "r") do |file|
                file.each_line do |line|
                    game_and_turns = line.split(':')
                    game_number = game_and_turns[0].match(/\d+/)[0].to_i
                    game = Game.new(id: game_number)
                    game.parse_turns(game_and_turns[1])
                    games.push(game)
                end
            end

            rolling_total = 0

            games.each do |game|
                rolling_total += game.bag.power_of_bag
            end

            rolling_total
        end
    end
end

day2 = AdventOfCode2023::Day2.new
puts "Part 1: #{day2.part1}"
puts "Part 2: #{day2.part2}"
