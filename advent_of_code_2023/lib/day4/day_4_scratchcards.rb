require 'pry'
require 'pry-byebug'

module AdventOfCode2023
    class ScratchCard
        attr_reader :id, :winning_numbers, :play_numbers, :matching_numbers, :won_cards
        def initialize (input:)
            @id = parse_id(input)
            @winning_numbers = parse_winning(input)
            @play_numbers = parse_play(input)
            @matching_numbers = []
            @won_cards = []
        end

        # Calculate the score of the card using the following rules:
        # 1. If a number in the play_numbers array matches a number in the winning_numbers array, add 1 to the score
        # 2. For each additional matching play_number that matches a number in the winning_numbers array, double the score
        def score
            score = 0
            @matching_numbers = []
            @play_numbers.each do |play_number|
                if @winning_numbers.include?(play_number)
                    @matching_numbers << play_number 
                    score = 1 if @matching_numbers.length == 1
                    score += score if @matching_numbers.length > 1
                end
            end
            score
        end

        def matches
            score
            @matching_numbers.length
        end

        def all_won_card_ids
            flat_won_cards = []
            @won_cards.each do |won_card|
                flat_won_cards << won_card.id.to_i
                flat_won_cards.concat(won_card.all_won_card_ids)
            end
            flat_won_cards
        end

        # to_s override
        def to_s
            "ScratchCard: #{@id}: matching numbers: #{@matching_numbers}, score: #{score}"
        end

        private 
        
        def parse_id(input)
            input.split(':')[0].split(' ')[1]
        end

        def parse_winning(input)
            input.split(':')[1].split('|')[0].split(' ')
        end

        def parse_play(input)
            input.split(':')[1].split('|')[1].split(' ')
        end
    end

    class CardStack
        attr_reader :dealt_cards, :winnings_card_ids
        def initialize()
            @dealt_cards = []
            @winnings_card_ids = []
        end

        def add_card(card:)
            @dealt_cards << card
        end

        def parse_winnings
            @dealt_cards.each do |card|
                card.won_cards.concat(winnings_for_card(card: card))
            end

            @dealt_cards.each do |card|
                @winnings_card_ids << card.id.to_i
                if card.matches > 0
                    @winnings_card_ids.concat(card.all_won_card_ids)
                end
            end
        end

        def winnings_for_card(card:)
            won_cards = []
            if card.matches > 0
                index = card.id.to_i - 1
                won_cards.concat(@dealt_cards[(index + 1)..(index + card.matches)])
            end
            won_cards
        end

        def score
            @dealt_cards.inject(0) { |sum, card| sum + card.score }
        end

        def to_s
            @dealt_cards.each{|card| puts card.to_s}
        end
    end

    class Day4
        def initialize()
            @card_stack = CardStack.new()
            @day1_input_path = './day_4_full_input_part1.txt'
            initialize_scratch_cards
        end

        def initialize_scratch_cards
            File.open(@day1_input_path).each do |line|
                @card_stack.add_card(card: ScratchCard.new(input: line))
            end
        end

        def part1
            "Total Score: #{@card_stack.score}"
        end

        def part2
            @card_stack.parse_winnings
            @card_stack.winnings_card_ids.length
        end
    end
end

day4 = AdventOfCode2023::Day4.new

puts "Day 4 Part 1: #{day4.part1}"
puts "Day 4 Part 2: #{day4.part2}"