require './route'

class Maze

  def initialize
    @current_step = 1
    @field = Array.new
    @count_field = Array.new($field.length).map{Array.new($field[0].length, -1)}
    @start_pos = Hash.new
    @goal_pos = Hash.new
    @loop_flag = true

    set_start

    check_around_start(@start_pos[:x], @start_pos[:y]-1)
    check_around_start(@start_pos[:x]+1, @start_pos[:y])
    check_around_start(@start_pos[:x], @start_pos[:y]+1)
    check_around_start(@start_pos[:x]-1, @start_pos[:y])

    while @loop_flag
      scanning
    end

    route_decision(@goal_pos[:x], @goal_pos[:y])
  end

  def set_start
    for i in 0...$field.length
      for j in 0...$field[i].length
        if($field[i][j] == 'S')
          @start_pos = { :x => j, :y => i }
          @count_field[i][j] = 0
          return
        end
      end
    end
  end

  def check_around_start(pos_x, pos_y)
    if($field[pos_y])
      return if(pos_x < 0)
      case $field[pos_y][pos_x]
      when 'G'
        @loop_flag = false
        @goal_pos = { :x => pos_x, :y => pos_y }
        return
      when '+'
        @count_field[pos_y][pos_x] = 1
      else
      end
    end
  end

  def scanning
    for i in 0...$field.length
      for j in 0...$field[i].length
        if(@count_field[i][j] == @current_step)
          fill_in_number(j, i-1)
          fill_in_number(j+1, i)
          fill_in_number(j, i+1)
          fill_in_number(j-1, i)
        end
      end
    end

    next_step
  end

  def fill_in_number(pos_x, pos_y)
    if($field[pos_y])
      return if(pos_x < 0)
      case $field[pos_y][pos_x]
      when 'G'
        @loop_flag = false
        @goal_pos = { :x => pos_x, :y => pos_y }
        return
      when '+'
        @count_field[pos_y][pos_x] = @current_step + 1 if @count_field[pos_y][pos_x] == -1
      else
      end
    end
  end

  def route_decision(pos_x, pos_y)

    @current_step -= 1
    return if @current_step < 1

    if(@count_field[pos_y-1])
      if(@count_field[pos_y-1][pos_x] == @current_step)
        route_decision(pos_x, pos_y-1)
        $field[pos_y-1][pos_x] = '@'
        return
      end
    end

    if(@count_field[pos_y][pos_x+1] == @current_step)
      route_decision(pos_x+1, pos_y)
      $field[pos_y][pos_x+1] = '@'
      return
    end

    if(@count_field[pos_y+1])
      if(@count_field[pos_y+1][pos_x] == @current_step)
        route_decision(pos_x, pos_y+1)
        $field[pos_y+1][pos_x] = '@'
        return
      end
    end

    if(@count_field[pos_y][pos_x-1] == @current_step)
      route_decision(pos_x-1, pos_y)
      $field[pos_y][pos_x-1] = '@'
      return
    end

 end

  def next_step
    @current_step += 1
  end

  def print_count_field
    for i in 0..@count_field.length
      print @count_field[i],"\n"
    end
  end

  def print_field
    for i in 0..$field.length
      print $field[i],"\n"
    end
  end

end

m = Maze.new
m.print_field
