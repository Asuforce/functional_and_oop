st = Time.now

class Maze

  def initialize
    @field = Array.new
    File.open('maze.txt') do |file|
      file.each_line do |line|
        @field << line
      end
    end
    @current_step = 0
    @count_field = Array.new(@field.length).map{ Array.new(@field[0].length, -1) }
    @start_pos = Hash.new
    @goal_pos = Hash.new
    @loop_flag = true
  end

  def search_root
    set_start

    fill_in_number(@start_pos[:x], @start_pos[:y]-1)
    fill_in_number(@start_pos[:x]+1, @start_pos[:y])
    fill_in_number(@start_pos[:x], @start_pos[:y]+1)
    fill_in_number(@start_pos[:x]-1, @start_pos[:y])

    scanning

    route_decision(@goal_pos[:x], @goal_pos[:y])
  end

  def set_start
    for i in 0...@field.length
      for j in 0...@field[i].length
        if(@field[i][j] == 'S')
          @start_pos = { :x => j, :y => i }
          @count_field[i][j] = 0
          return
        end
      end
    end
  end

  def fill_in_number(pos_x, pos_y)
    if(@field[pos_y])
      return if(pos_x < 0)

      case @field[pos_y][pos_x]
      when 'G'
        @loop_flag = false
        @goal_pos = { :x => pos_x, :y => pos_y }
        @current_step += 1
        return
      when ' '
        if(@current_step == 0)
          @count_field[pos_y][pos_x] = 1
          @current_step = 1
        else
          @count_field[pos_y][pos_x] = @current_step + 1 if @count_field[pos_y][pos_x] == -1
        end
      else
      end
    end
  end

  def scanning
    while @loop_flag
      for i in 0...@field.length
        for j in 0...@field[i].length
          if(@count_field[i][j] == @current_step)
            fill_in_number(j, i-1)
            fill_in_number(j+1, i)
            fill_in_number(j, i+1)
            fill_in_number(j-1, i)
          end
          return unless(@loop_flag)
        end
      end

      @current_step += 1
    end
  end

  def route_decision(pos_x, pos_y)
    @current_step -= 1
    return if @current_step < 1

    if(@count_field[pos_y-1])
      if(@count_field[pos_y-1][pos_x] == @current_step)
        route_decision(pos_x, pos_y-1)
        @field[pos_y-1][pos_x] = '@'
        return
      end
    end

    if(@count_field[pos_y][pos_x+1] == @current_step)
      route_decision(pos_x+1, pos_y)
      @field[pos_y][pos_x+1] = '@'
      return
    end

    if(@count_field[pos_y+1])
      if(@count_field[pos_y+1][pos_x] == @current_step)
        route_decision(pos_x, pos_y+1)
        @field[pos_y+1][pos_x] = '@'
        return
      end
    end

    if(@count_field[pos_y][pos_x-1] == @current_step)
      route_decision(pos_x-1, pos_y)
      @field[pos_y][pos_x-1] = '@'
      return
    end

  end

  def print_count_field
    for i in 0..@count_field.length
      print @count_field[i], "\n"
    end
  end

  def print_field
    for i in 0..@field.length
      print @field[i]
    end
  end

end

m = Maze.new
m.search_root
m.print_count_field
p "処理概要 #{Time.now - st}s"
