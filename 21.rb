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
  pad_hash.keys.permutation(2).each do |from, to|
    from_row, from_col = pad_hash[from]
    to_row, to_col = pad_hash[to]
    if from_row < to_row
      vertical_str = 'v' * (to_row - from_row)
      proposed_rows = (from_row..to_row)
    elsif from_row > to_row
      vertical_str = '^' * (from_row - to_row)
      proposed_rows = (to_row..from_row)
    else
      vertical_str = ''
      proposed_rows = [to_row]
    end
    if from_col < to_col
      horizontal_str = '>' * (to_col - from_col)
      proposed_cols = (from_col..to_col)
    elsif from_col > to_col
      horizontal_str = '<' * (from_col - to_col)
      proposed_cols = (to_col..from_col)
    else
      horizontal_str = ''
      proposed_cols = [to_col]
    end
    path_hash[[from, to]] = []
    if proposed_cols.all?{|col| pad[from_row][col]}
      path_hash[[from, to]] << horizontal_str + vertical_str + 'A'
    end
    if proposed_rows.all?{|row| pad[row][from_col]}
      path_hash[[from, to]] << vertical_str + horizontal_str + 'A'
    end
    path_hash[[from, to]].uniq!
  end
  path_hash
end

shortest_num_paths = build_shortest_path_hash(num_hash, num_pad)
shortest_arrow_paths = build_shortest_path_hash(arrow_hash, arrow_pad)

def possible_paths(str, path, shortest_paths_hash)
  return [path] if str.length == 1
  next_segments = shortest_paths_hash[[str[0],str[1]]] || ['A']
  paths = []
  next_segments.each do |segment|
    paths << possible_paths(str[1..], path + segment, shortest_paths_hash)
  end
  return paths.flatten
end

def keep_shortest(paths)
  length = paths.map(&:length).min
  paths.select {|path| path.length == length}
end

shortest_overall_lengths = {}
shortest_num_paths.each do |(from,to), paths|
  layer_2 = keep_shortest(paths.map{ |path| possible_paths('A' + path, '', shortest_arrow_paths)}).flatten
  layer_3 = keep_shortest(layer_2.map{ |path| possible_paths('A' + path, '', shortest_arrow_paths)}).flatten
  shortest_overall_lengths[[from, to]] = layer_3[0].length
end

total = 0
codes.each do |code|
  length = ('A' + code).chars.each_cons(2).sum{|segment| shortest_overall_lengths[segment]}
  total += code.to_i * length
end

puts total
