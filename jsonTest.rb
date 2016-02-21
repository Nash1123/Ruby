require 'json'

# Simply test for the output.json file
json = File.read("./output.json")
obj = JSON.parse(json)

puts obj
