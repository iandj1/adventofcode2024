input = File.open("inputs/9-sample.txt")
input = File.open("inputs/9.txt")

files = {}
spaces = []

index = 0
input.readline.chars.each_slice(2).with_index do |(data, space), num|
  files[num] = [index, data.to_i] # file_no => [location, length]
  spaces << [index + data.to_i, space.to_i] if space && space.to_i > 0
  index += data.to_i + space.to_i
end

files.keys.reverse.each do |file|
  file_index = files[file][0]
  file_length = files[file][1]

  spaces.each_with_index do |(space_index, space_length), space_no|
    break if space_index > file_index # never move file right
    if file_length == space_length
      spaces.delete_at(space_no)
      files[file][0] = space_index
      break
    elsif file_length < space_length
      spaces[space_no] = [space_index + file_length, space_length - file_length]
      files[file][0] = space_index
      break
    end
  end
end

total = 0
files.each do |file_num, (location, length)|
  (location...location+length).each do |index|
    total += index * file_num
  end
end

puts total
