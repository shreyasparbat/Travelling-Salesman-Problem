# q1.rb

# Fill this up:
#   Team ID : G3-T10
#   Name of Team member 1: Joel Koh
#   Name of Team member 2: Shreyas Parbat


=begin
  Global variables
=end

$id_from = []
$id_to = []
$givenDistances = []
$population_size = 100
$number_of_generations = 10


=begin
  Main function

  -> returns the recommended path as an array
  -> the first and last elements in the returned array should be location 1 (the warehouse)
  -> givenDistances[i] is distance between id_from[i] to id_to[i]  
=end

def find_path(number_of_locations, id_from, id_to, givenDistances)

  # Set global variables
  $id_from = id_from
  $id_to = id_to
  $givenDistances = givenDistances

  # insert IDs of locations into path
  locations = (2..number_of_locations).to_a

  # Get greedy solution
  greedy_species = get_greedy_solution(locations.clone)
  
  # Initialise population
  population = []
  population << greedy_species
  for i in 1...$population_size
    population << locations.shuffle

    # Add 1 to the front and back
    population[i].unshift(1)
    population[i] << 1
  end

  # Run epochs
  global_record_distance = (2**(0.size * 8 -2) -1) # max possible number
  recommended_species = []
  for i in 0...$number_of_generations
    # Construct fitness score
    fitness, record_distance, most_fit_species = calculate_fitness(population)
    p record_distance

    # Update global best
    if record_distance < global_record_distance
      global_record_distance = record_distance
      recommended_species = most_fit_species
      # Do other shit here
    end

    # Get next generation
    population = get_next_generation(population, fitness)
  end

  # Return recommendation
  p "Global best = ", global_record_distance, greedy_species
  return greedy_species
end


=begin
  Genetic Algorithm Functions
=end

# fitness of algo at population[i] is given by value at fitness[i]
def calculate_fitness(population)

  # Must also return best performing species
  record_distance = (2**(0.size * 8 -2) -1) # max possible number
  most_fit_species = []
  fitness = []
  
  # Get total_distance for that path (species)
  population.each { |species|
    total_distance = 0
    for j in 1...species.length
      total_distance += get_distance(species[j-1], species[j])
    end

    # Lower distance should signify higher fitness, so we inverse the total_distance
    fitness << 1 / (total_distance + 1)

    # Take note of best performing species
    if total_distance < record_distance
      record_distance = total_distance
      most_fit_species = species
    end
  }

  return normalise_fitness(fitness), record_distance, most_fit_species
end

# Map the fitnesses to probabilities (i.e. to values between 0-1 such that all add up to 1)
def normalise_fitness(fitness)

  # Get sum of all fitness values
  sum = 0
  fitness.each { |fitness_value|
    sum += fitness_value
  }

  # Divide each fitness value by sum to normalise it
  normalised_fitness = []
  fitness.each { |fitness_value|
    normalised_fitness << fitness_value / sum
  }

  return normalised_fitness
end

# Pick the best species, cross them over and mutate
def get_next_generation(population, fitness)
  new_population = []
  for i in 0...population.length
    # Pick 2 species according to probability distribution (as given by fitness) and cross them over
    species_1 = population[pool_selection(fitness)]
    # species_2 = population[pool_selection(fitness)]
    # child_species = cross_over(species_1, species_2)

    # Mutate and insert into new population
    new_population << mutate(species_1, 0.01)
  end
  return new_population
end

# Pick index of a species with probability = it's fitness
def pool_selection(fitness)
  # To specify which species we will be picking from the population
  index = 0

  # Pick a random number between 0-1
  r = Random.new
  random_number = r.rand

  # This will pick one of the indices with probability given by fitness
  while random_number > 0
    random_number -= fitness[index]
    index += 1
  end

  # We need to reduce the index to account for the extra increment at the end of the loop
  index -= 1
  return index
end

# Mutates the species passed in by swapping two randomly selected cities
def mutate(species, mutation_rate)
  # Make two instances of Random so that the two randomly selected indices are independently selected
  r_index_1 = Random.new
  r_index_2 = Random.new

  # Select two indices at random (except '1' at the beginning and end)
  index_1 = r_index_1.rand(1...species.length-1)
  index_2 = r_index_2.rand(1...species.length-1)
  
  # Swap and return
  species[index_1], species[index_2] = species[index_2], species[index_1]
  return species
end

# To do cross overs
def cross_over (species_1, species_2)
  # Pick a random slice in species_1 and add it to child
  r = Random.new
  start_index = r.rand(1...species_1.length-1)
  end_index = r.rand(start_index+1...species_2.length-1)
  child_species = species_1.values_at(start_index..end_index)

  # Pick locations from species_2 (which aren't already in child) and add them to child
  species_2.each { |location|
    unless child_species.include?(location)
      child_species << location
    end
  }

  # Return child
  return child_species
end


=begin
  Utility functions
=end

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


# Returns the distance between any two cities
def get_distance (current_city, city_to_visit)
  for i in 0...$givenDistances.length
    if $id_from[i] == current_city && $id_to[i] == city_to_visit
      return $givenDistances[i]
    end
  end
end