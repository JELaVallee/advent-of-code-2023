module AdventOfCode2023
    class MappedRange
        attr_reader :source_range, :destination_range

        def initialize(source_start:, destination_start:, span:)
            @source_range = (source_start...source_start + span)
            @destination_range = (destination_start...destination_start + span)
        end

        def value_in_source_range?(value:)
            source_range.include?(value)
        end

        def transposed_value(value:)
            if value_in_source_range?(value: value)
                destination_range.begin + (value - source_range.begin)
            end
        end
    end

    class MultiRangeTransposer
        attr_reader :mapped_ranges

        def initialize
            @mapped_ranges = []
        end

        def add_mapped_range(input_string)
            destination_start, source_start, span = input_string.split.map(&:to_i)
            mapped_range = MappedRange.new(source_start: source_start, destination_start: destination_start, span: span)
            mapped_ranges << mapped_range
        end

        def transpose_source_to_destination(value)
            mapped_ranges.each do |mapped_range|
                if mapped_range.value_in_source_range?(value: value)
                    return mapped_range.transposed_value(value: value)
                end
            end
            value
        end
    end

    class SeedLocator
        attr_reader :seed_to_soil, :soil_to_fertilizer, :fertilizer_to_water 
        attr_reader :water_to_light, :light_to_temp, :temp_to_humidity, :humidity_to_location

        def initialize
            @seed_to_soil = MultiRangeTransposer.new
            @soil_to_fertilizer = MultiRangeTransposer.new
            @fertilizer_to_water = MultiRangeTransposer.new
            @water_to_light = MultiRangeTransposer.new
            @light_to_temp = MultiRangeTransposer.new
            @temp_to_humidity = MultiRangeTransposer.new
            @humidity_to_location = MultiRangeTransposer.new
        end

        def add_seed_to_soil_range(input_string)
            seed_to_soil.add_mapped_range(input_string)
        end

        def add_soil_to_fertilizer_range(input_string)
            soil_to_fertilizer.add_mapped_range(input_string)
        end

        def add_fertilizer_to_water_range(input_string)
            fertilizer_to_water.add_mapped_range(input_string)
        end

        def add_water_to_light_range(input_string)
            water_to_light.add_mapped_range(input_string)
        end

        def add_light_to_temp_range(input_string)
            light_to_temp.add_mapped_range(input_string)
        end

        def add_temp_to_humidity_range(input_string)
            temp_to_humidity.add_mapped_range(input_string)
        end

        def add_humidity_to_location_range(input_string)
            humidity_to_location.add_mapped_range(input_string)
        end

        def location_for(seed:)
            soil = seed_to_soil.transpose_source_to_destination(seed)
            fertilizer = soil_to_fertilizer.transpose_source_to_destination(soil)
            water = fertilizer_to_water.transpose_source_to_destination(fertilizer)
            light = water_to_light.transpose_source_to_destination(water)
            temp = light_to_temp.transpose_source_to_destination(light)
            humidity = temp_to_humidity.transpose_source_to_destination(temp)
            humidity_to_location.transpose_source_to_destination(humidity)
        end
    end

    class SeedMapper
        attr_reader :seeds, :seed_locator

        def initialize(input_file:)
            @seeds = []
            @seed_locator = SeedLocator.new
            parse_input_file(input_file: input_file)
        end

        def map_seed_to_location(seed:)
            seed_locator.location_for(seed: seed)
        end

        def find_lowest_seed_location
            lowest_location = nil
            seeds.each do |seed|
                seed_location = map_seed_to_location(seed: seed)
                if lowest_location.nil? || seed_location < lowest_location
                    lowest_location = seed_location
                end
            end
            lowest_location
        end

        private

        def parse_input_file(input_file:)
            File.open(input_file, "r") do |file|
                seeds_line = file.readline.strip
                seeds = seeds_line.split(":")[1].split.map(&:to_i)
                seeds.each { |seed| @seeds << seed }

                file.each_line do |line|
                    case line.strip
                    when "seed-to-soil map:"
                        read_map(file, :add_seed_to_soil_range)
                    when "soil-to-fertilizer map:"
                        read_map(file, :add_soil_to_fertilizer_range)
                    when "fertilizer-to-water map:"
                        read_map(file, :add_fertilizer_to_water_range)
                    when "water-to-light map:"
                        read_map(file, :add_water_to_light_range)
                    when "light-to-temperature map:"
                        read_map(file, :add_light_to_temp_range)
                    when "temperature-to-humidity map:"
                        read_map(file, :add_temp_to_humidity_range)
                    when "humidity-to-location map:"
                        read_map(file, :add_humidity_to_location_range)
                    end
                end
            end
        end

        def read_map(file, add_method)
            file.each_line do |line|
                break if line.strip.empty?

                input_string = line.strip
                seed_locator.send(add_method, input_string)
            end
        end
    end
    
    class Day5
        def self.part1
            seed_mapper = SeedMapper.new(input_file: './day_5_full_input.txt')
            seed_mapper.find_lowest_seed_location
        end

        def self.part2
            # TODO: Implement part 2 logic here
        end
    end
end

puts "Day5: Part1: #{AdventOfCode2023::Day5.part1}"