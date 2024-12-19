input = File.open("inputs/19-sample.txt")
input = File.open("inputs/19.txt")

towel_regex = Regexp.new("^(#{input.readline.strip.gsub(/, /,'|')})+$")
puts input.count { |line| line.strip.match? towel_regex }
