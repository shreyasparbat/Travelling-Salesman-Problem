# q1.rb

# Fill this up:
#   Team ID : G3-T10
#   Name of Team member 1: Joel Koh
#   Name of Team member 2: Shreyas Parbat


=begin
    Global variables
=end

$distance_hash = Hash.new
$limit_no_improvement = 25 # No of times the algo will run while there are no solutions


=begin
    Main function

    -> returns the recommended path as an array
    -> the first and last elements in the returned array should be location 1 (the warehouse)
    -> givenDistances[i] is distance between id_from[i] to id_to[i]  
=end

def find_path(number_of_locations, id_from, id_to, givenDistances)
    # Set global variables
    for i in 0...givenDistances.length
        $distance_hash[id_from[i].to_s + "," + id_to[i].to_s] = givenDistances[i]
    end
    
    # insert IDs of locations into path
    locations = (2..number_of_locations).to_a

    # Get greedy solution
    path = get_greedy_solution(locations.clone)

    # Begin 2-opt heuristic
    number_no_improvement = 0
    while number_no_improvement < $limit_no_improvement
        # Get total distance of current path
        record_distance = get_total_dist(path)

        # Get new_path and check for improvement
        for i in 1...path.length-2
            for j in i+1...path.length-1
                new_path = two_opt_swap(i, j, path)
                new_distance = get_total_dist(new_path)
                if new_distance < record_distance
                    # Improvement found!
                    number_no_improvement = 0
                    path = new_path.clone
                    record_distance = new_distance

                    # # Testing
                    # p "-----", record_distance, path, "-----"
                end
            end
        end

        # No improvement found
        number_no_improvement += 1
    end

    # Return
    return path
end

# Doing the swap
def two_opt_swap(location_1, location_2, path)
    new_path = []

    # Add path[0] to path[location_1-1] to new_path
    for i in 0...location_1
        new_path << path[i]
    end

    # In reverse order, add path[location_1] to path[location_2] to new_ path
    index = location_2
    for i in location_1..location_2
        new_path << path[index]
        index -= 1
    end

    # Add remaining locations to new_path
    for i in location_2+1...path.length
        new_path << path[i]
    end

    return new_path
end

# Finding greedy solution (by optimising local answers)
def get_greedy_solution(locations)
    path = [1]
    while !locations.empty?
        # Add city to path which has the least distance to current_city (i.e. the city at the end of the current path)
        current_city = path[path.length - 1]
        city_to_visit = 1
        min_distance = (2**(0.size * 8 -2) -1) # max possible number
        locations.each { |location|
        distance = get_distance(current_city, location)
        if distance < min_distance
            city_to_visit = location
        end
        }
  
      # Delete city from 'locations to visit' and insert into 'path'
      locations.delete(city_to_visit)
      path.push(city_to_visit)
    end
  
    # insert 1 behind
    path << 1
    return path
end

# Returns total distance of the path
def get_total_dist(path)
    total_distance = 0
    for i in 1...path.length
        total_distance += $distance_hash[path[i-1].to_s + "," + path[i].to_s]
    end
    return total_distance
end

# Returns the distance between any two cities (needed for greedy solution)
def get_distance (current_location, location_to_visit)
    return $distance_hash[current_location.to_s + "," + location_to_visit.to_s]
end