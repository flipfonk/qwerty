using HorizonSideRobots

r = Robot("untitled.sit", animate = true)

function chess_marker_n(robot, n)
    sud_steps = num_steps_along!(robot, Sud)
    west_steps = num_steps_along!(robot, West)

    count = 0
    flag = 1
    flag_height = 1
    flag_end = 0
    while true
        for i in 1:n
            count = 0
            flag = flag_height
            while !isborder(robot, Ost)
                if count < n && flag == 1
                    putmarker!(robot)
                end
                move!(robot, Ost)

                count += 1

                if count == n
                    if flag == 1
                        flag = 0
                    else
                        flag = 1
                    end
                    count = 0
                end
            end
            if isborder(robot, Ost) && flag == 1
                putmarker!(robot)
            end
            num_steps_along!(robot, West)

            if isborder(robot, Nord)
                flag_end = 1
                break
            end

            move!(robot, Nord)
        end
        if flag_end == 1
            break
        end
        if flag_height == 1
            flag_height = 0
        else
            flag_height = 1
        end
    end

    num_steps_along!(robot, Sud)
    num_steps_along!(robot, West)
    along!(robot, Nord, sud_steps)
    along!(robot, Ost, west_steps)
end

function num_steps_along!(robot, direct)::Int #перемещает робота в заданном направлении до упора и возвращает число фактически сделанных им шагов
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

function along!(robot, direct, num_steps)::Nothing #перемещает робота в заданном направлении на заданное число шагов (предполагается, что это возможно)
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

chess_marker_n(r, 2)