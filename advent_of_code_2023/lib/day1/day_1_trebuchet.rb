require 'pry'

module AdventOfCode2023 
    class Day1
        @@word_to_number = {
            'one' => 'o1ne',
            'two' => 't2wo',
            'three' => 't3hree',
            'four' => 'f4our',
            'five' => 'f5ive',
            'six' => 's6ix',
            'seven' => 's7even',
            'eight' => 'e8ight',
            'nine' => 'n9ine',
          }

        def initialize()  
            @part1_path = "./day_1_trebuchet_input_1.txt"
            @part2_path = "./day_1_trebuchet_input_2.txt"
            @rolling_sum = 0
        end   

        def part1
            @rolling_sum = 0
            input_path = @part1_path
            
            File.open(input_path, "r") do |file|
                file.each_line do |line|
                  numbers = line.scan(/\d/)
                  numbers = numbers.map(&:to_s)
                  first_and_last = numbers.first + numbers.last
                  @rolling_sum += first_and_last.to_i
                #   puts "#{line} :: #{numbers} :: #{first_and_last}" 
                end
            end
            
            @rolling_sum
        end
        
        def part2
            @rolling_sum = 0
            line_number = 0
            input_path = @part2_path
            
            File.open(input_path, "r") do |file|
                file.each_line do |line|
                    line = line.chomp
                    line_number += 1
                    line_ints = line.gsub(/#{@@word_to_number.keys.join('|')}/i) do |match|
                        @@word_to_number[match.downcase]
                    end
                    line_ints = line_ints.gsub(/#{@@word_to_number.keys.join('|')}/i) do |match|
                        @@word_to_number[match.downcase]
                    end
                    numbers = line_ints.scan(/\d/)
                    numbers = numbers.map(&:to_s)
                    first_and_last = numbers.first + numbers.last
                    @rolling_sum += first_and_last.to_i
                    # puts "#{line_number} : #{line} -- #{first_and_last.to_i} -- #{@rolling_sum}" 
                end
            end
            
            @rolling_sum
        end
    end    
end

day1 = AdventOfCode2023::Day1.new
puts "Part 1: #{day1.part1}"
puts "Part 2: #{day1.part2}"
