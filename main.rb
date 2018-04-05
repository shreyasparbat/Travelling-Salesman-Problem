# Project 2
# You may modify this file for testing purposes, 
# but your final q1.rb must be able to run with the original main.rb.

load "utility.rb"
load "q1.rb"

id_from  = [] # array of IDs (from)
id_to    = [] # array of IDs (to)
distance = [] # array of distances between corresponding id_from and id_to
# for example, the distance between id_from[5] and id_to[5] is distance[5]

# modify the CSV file name here to change the source for distanceX.csv
read_file("data/distance2_new.csv").each{ |line|
  array = line.split(",")
  id_from  << array[0].to_i
  id_to    << array[1].to_i
  distance << array[2].to_f
}
# IMPORTANT: change this variable manually whenever you change the distanceX file used
number_of_locations = 81

# ---------------------------------------
# call find_path in q1.rb and print the resulting path
path = find_path(number_of_locations, id_from, id_to, distance)

# ---------------------------------------
# print out recommended path
display = ""
for i in 0..path.length-1
  display = display + path[i].to_s + ", "
end
p "Recommended path: " + display

# ---------------------------------------
# calculate the total distance required for the path
total_distance = 0
for i in 0..path.length-2
  # find distance between i and i+1
  d = find_distance(path[i], path[i+1], id_from, id_to, distance)
  p path[i].to_s + " -> " + path[i+1].to_s + ", Distance: " + d.to_s # comment this out if you want
  total_distance = total_distance + d
end
p "Total distance for whole path is " + total_distance.to_s

# ---------------------------------------
# check if all locations have been visited
p check_all_visited_and_get_msg(path, number_of_locations)