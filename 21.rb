input = File.open("inputs/21-sample.txt")
input = File.open("inputs/21.txt")

codes = []
input.each do |line|
  codes << line.strip
end

num_pad = [
  ['7','8','9'],
  ['4','5','6'],
  ['1','2','3'],
  [nil,'0','A']
]

arrow_pad = [
  [nil,'^','A'],
  ['<','v','>']
]

def build_pad_hash(pad)
  pad_hash = {}
  pad.each_with_index do |line, row|
    line.each_with_index do |key, col|
      pad_hash[key] = [row, col] if key
    end
  end
  pad_hash
end

num_hash = build_pad_hash(num_pad)
arrow_hash = build_pad_hash(arrow_pad)

def build_shortest_path_hash(pad_hash, pad)
  path_hash = {}
  pad_hash.keys.product(pad_hash.keys).each do |from, to|
    from_row, from_col = pad_hash[from]
    to_row, to_col = pad_hash[to]
    vertical_str = (from_row < to_row ? 'v' : '^') * (from_row - to_row).abs
    horizontal_str = (from_col < to_col ? '>' : '<') * (from_col - to_col).abs
    options = []
    if pad[from_row][to_col]
      options << horizontal_str + vertical_str + 'A'
    end
    if pad[to_row][from_col]
      options << vertical_str + horizontal_str + 'A'
    end
    if options.uniq.count == 1 # both options are the same, just return the first
      path_hash[[from, to]] = options[0]
    elsif ['v>', '<v', '<^', '^>'].any?{|x| options[0].include? x} # these directions are better than alternatives
      path_hash[[from, to]] = options[0]
    else
      path_hash[[from, to]] = options[1]
    end
  end
  path_hash
end

shortest_num_paths = build_shortest_path_hash(num_hash, num_pad)
shortest_arrow_paths = build_shortest_path_hash(arrow_hash, arrow_pad)

def new_path_arr(str, path_hash)
  ('A' + str).chars.each_cons(2).map{|pair| path_hash[pair]} # split into pairs, assuming we start on A
end

def path_len(str, path_hash, n, memo)
  key = [str, n]
  if !memo[key] # return if we've already seen this
    new_paths = new_path_arr(str, path_hash)
    if n == 1
      memo[key] = new_paths.sum(&:length)
    else
      memo[key] = new_paths.sum{|path| path_len(path, path_hash, n-1, memo)}
    end
  end
  memo[key]
end

memo = {}
total_1 = 0
total_2 = 0
codes.each do |code|
  path = new_path_arr(code, shortest_num_paths).join
  total_1 += code.to_i * path_len(path, shortest_arrow_paths, 2, memo)
  total_2 += code.to_i * path_len(path, shortest_arrow_paths, 25, memo)
end
puts total_1
puts total_2
