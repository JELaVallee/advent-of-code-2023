require 'pry'
require 'pry-byebug'
require_relative 'grid'

module AdventOfCode2023
    class Schematic
        attr_reader :grid, :part_numbers
        def initialize(data:)
            @grid = Grid.new(data:)
            @part_numbers = parse_numbers(data:)
        end

        def parse_numbers(data:)
            row_index = 0
            parts = []
            data.each do |line|
                matches = line.scan(/\d+/)
                
                matches.each do |match|
                    is_part_number = false
                    if (match.to_i == 444)
                        binding.pry
                    end

                    start_index = line.index(match)
                    end_index = start_index + match.length - 1
                    (start_index..end_index).each do |col_index|
                        neighbors = @grid.get_neighbors(row_index, col_index)
                        match_count = 0
                        neighbors.each do |neighbor|
                            is_part_number = true if (neighbor.match?(/[^a-zA-Z0-9.]/))
                            match_count += 1 if (neighbor.match?(/[^a-zA-Z0-9.]/))
                        end
                        # puts "#{match} has #{match_count}" if (match_count > 1)
                    end
                    parts << match.to_i.abs if (is_part_number)
                end      

                row_index += 1          
            end
            parts
        end
    end

    class NumberNode
        attr_reader :start_index, :end_index, :value
        def initialize(start_index:, end_index:, value:)
            @start_index = start_index
            @end_index = end_index
            @value = value
        end
    end

    class Day3
        def initialize()
            @part1_sample_path = "./day_3_sample_input.txt"
            @part1_full_path = "./day_3_full_input.txt"
        end

        def part1
            input_path = @part1_full_path
            schematic_data = File.readlines(input_path, chomp: true)
            schematic = Schematic.new(data: schematic_data)
            schematic.part_numbers.sum
        end
    end
end

day3 = AdventOfCode2023::Day3.new

puts "Part 1: #{day3.part1}"