$field = [
			['+','+','+','+','+','+','+','+','+','G'],
			['+','+','+','+','+','+','+','+','#','+'],
			['+','+','+','+','+','+','+','#','+','+'],
			['+','+','+','+','+','+','+','+','#','#'],
			['+','+','+','+','+','+','+','+','+','+'],
			['+','+','+','#','#','#','#','#','+','+'],
			['+','+','+','+','+','+','+','+','+','+'],
			['+','+','+','+','+','+','+','+','#','+'],
			['+','+','+','+','+','+','+','+','+','+'],
			['+','+','+','+','+','+','+','+','+','+'],
			['+','+','+','+','+','+','#','+','+','+'],
			['+','+','+','+','+','#','+','#','+','+'],
			['+','+','+','+','#','+','+','+','+','+'],
			['+','+','+','+','+','+','+','+','+','+'],
			['+','+','+','+','+','+','+','+','+','+'],
			['+','#','+','#','#','+','+','+','+','+'],
			['#','+','#','+','+','+','+','+','+','+'],
			['+','+','+','#','+','+','+','#','+','+'],
			['+','#','+','+','+','#','+','#','+','#'],
			['S','#','+','+','+','+','+','+','+','+']
		]

$field_count = [
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		]

$field_result = Marshal.load(Marshal.dump($field))

$goal_count = 10000



for i in 0..19 do
	$s_position_x = $field[i].find_index('S')
	$s_position_y = i
	break if $s_position_x != nil
end

for i in 0..19 do
	$g_position_x = $field[i].find_index('G')
	$g_position_y = i
	break if $g_position_x != nil
end



def saiki(y, x, n = 0)
#捜査終了
	if $goal_count < (n + ($s_position_x - x).abs + ($s_position_y - y).abs) || $field_count[y][x] < n && $field_count[y][x] > 0
		$field[y][x] = '+'
		return
	end

	$field_count[y][x] = n

#アウトプット
	#for i in 0 .. 19 do
	#	print $field_count[i]
	#	print "\n"
	#end
	#print "\n"

#下方向へ
	work = x
	while true
		work += 1
		break if work > 9
		break if $field[y][work] == '#' || ($field_count[y][work] > 0 && $field_count[y][work] <= $field_count[y][work-1]+1)
		$field_count[y][work] = $field_count[y][work-1] + 1
	end

	work = x
	while true
		work -= 1
		break if work < 0
		break if $field[y][work] == '#' || ($field_count[y][work] > 0 && $field_count[y][work] <= $field_count[y][work+1]+1)
		$field_count[y][work] = $field_count[y][work+1] + 1
	end

	if y != 19
		if $field[y+1][x] == 'S'
			result_mapping(y, x, n)
			return
		end

		if $field[y+1][x] == '+' && $field_count[y+1][x] != $field_count[y][x]+1
			$field[y+1][x] = '@'
			saiki(y+1, x, n+1)
		end
	end

#右方向へ
	work = y
	while true
		work -= 1
		break if work < 0
		break if $field[work][x] == '#' || ($field_count[work][x] > 0 && $field_count[work][x] <= $field_count[work+1][x])
		$field_count[work][x] = $field_count[work+1][x] + 1
	end

	if x != 9
		if $field[y][x+1] == 'S'
			result_mapping(y, x, n)
			return
		end

		if $field[y][x+1] == '+'
			$field[y][x+1] = '@'
			saiki(y, x+1, n+1)
		end
	end

#上方向へ
	work = x
	while true
		work -= 1
		break if work < 0
		break if $field[y][work] == '#' || ($field_count[y][work] > 0 && $field_count[y][work] <= $field_count[y][work+1])
		$field_count[y][work] = $field_count[y][work+1] + 1
	end

	if y != 0
		if $field[y-1][x] == 'S'
			result_mapping(y, x, n)
			return
		end

		if $field[y-1][x] == '+'
			$field[y-1][x] = '@'
			saiki(y-1, x, n+1)
		end
	end

#左方向へ
	#work = y
	#while true
	#	work += 1
	#	break if work > 19
	#	break if $field[work][x] == '#' || ($field_count[work][x] > 0 && $field_count[work][x] <= $field_count[work-1][x])
	#	$field_count[work][x] = $field_count[work-1][x] + 1
	#end

	if x != 0
		if $field[y][x-1] == 'S'
			result_mapping(y, x, n)
			return
		end

		if $field[y][x-1] == '+'
			$field[y][x-1] = '@'
			saiki(y, x-1, n+1)
		end
	end

	$field[y][x] = '+'

end

def result_mapping(y, x, n)
	if $goal_count > n
		$goal_count = n
		for i in 0 .. 19 do
			for j in 0 .. 9 do
				$field_result = Marshal.load(Marshal.dump($field))
			end
		end
	end

	$field[y][x] = '+'
end

saiki($g_position_y, $g_position_x)

for i in 0 .. 19 do
	print $field_result[i]
	print "\n"
end
