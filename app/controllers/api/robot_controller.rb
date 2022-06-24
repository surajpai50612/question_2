module Api
    class RobotController < ApplicationController
        def orders
            # Declaration
            @x, @y, flag, @min = 0
            @max, @direction = 4, ""

            commands = params[:Commands]

            # Check until PLACE command found
            for j in 0..(commands.length-1) do
                if commands[j][0] == "P"
                    break
                end
            end

            # Loop for valid commands
            for i in j..(commands.length-1) do
                # Split the command
                cmd = commands[i].downcase!.gsub(","," ").split(" ")

                if cmd[0] == "place"
                    if cmd[1].to_i <= @max && cmd[2].to_i <= @max && cmd[1].to_i >= @min && cmd[2].to_i >= @min
                        place(cmd[1].to_i,cmd[2].to_i,cmd[3])
                    else
                        flag = 1
                        break
                    end
                elsif cmd[0] == "move"
                    move()
                elsif cmd[0] == "left" || cmd[0] == "right"
                    rotate(cmd[0])
                elsif cmd[0] == "report"
                    report()
                end
            end

            if flag == 1
                render json: { "warning": "Enter valid value for x & y in PLACE command" }
            end
        end

        private
            # PLACE
            def place(x, y, dir)
                @x, @y, @direction = x, y, dir
            end

            # MOVE
            def move
                if @direction == "north" && @y < @max
                        @y += 1
                elsif @direction == "south" && @y > @min
                        @y -= 1
                elsif @direction == "east" && @x < @max
                        @x += 1
                elsif @direction == "west" && @x > @min
                        @x -= 1
                end
            end

            # REPORT
            def report
                render json: { location: [@x,@y,@direction.upcase] }
            end

            # LEFT or RIGHT
            def rotate(dir)
                if dir == "left"
                    if @direction == "north"
                        @direction = "west"
                    elsif @direction == "west"
                        @direction = "south"
                    elsif @direction == "south"
                        @direction = "east"
                    else
                        @direction = "north"
                    end
                else
                    if @direction == "north"
                        @direction = "east"
                    elsif @direction == "east"
                        @direction = "south"
                    elsif @direction == "south"
                        @direction = "west"
                    else
                        @direction = "north"
                    end
                end
            end
    end
end