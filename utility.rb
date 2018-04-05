#	DO NOT MODIFY THIS FILE
#	This file should NOT be included in your submission to the submission server


def read_file(file)
	lines = IO.readlines(file)
	if lines != nil
		for i in 0 .. lines.length-1
			lines[i] = lines[i].sub("\n","")
		end
		return lines[0..lines.length-1]
	end
	return nil
end

# this method returns the distance between 2 locations
def find_distance(from, to, id_from, id_to, distance)
  for i in 0..id_from.length
    if id_from[i]==from && id_to[i]==to
      return distance[i]
    end
  end
  return nil # cannot find
end

# this method returns a string with a message that either all locations have been
# visited, or an error message with the list of unvisited locations
def check_all_visited_and_get_msg(path, number_of_locations)
  visited = [] # array of booleans - keeps track of which locations have been visited
  
  # insert false, false, false etc... into visited. one for each location
  for i in 0..number_of_locations # ignore first slot (first slot not used)
    visited << false
  end
  
  # set to true in visited all locations found in path
  for i in 1..path.length-1 # go through all locations in path and set corresponding array element in visited to true
    visited[(path[i].to_i)] = true
  end
  
  all_visited = true # keeps track of whether all locations have been visited
  error_message = "ERROR: locations not visited :" # list of locations not visited
  
  for i in 1..number_of_locations # remember, the first slot is ignored
    if visited[i] == false
      error_message = error_message + (i).to_s + ", "
      all_visited = false
    end
  end
  
  # string to return
  if all_visited
    return "All locations visited"
  else
    return error_message
  end
end