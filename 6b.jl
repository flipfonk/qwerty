using HorizonSideRobots

r = Robot("untitled.sit", animate = true)

function mark_perimeter_complex_in_4_pos!(robot) #Робот - в исходном положении и - a) по всему периметру внешней рамки стоят маркеры
    pos = (1, 1)
    back_path = move_to_angle_complex!(robot)
    flag = 0
    for i in back_path
        if flag == 0
            pos = (pos[1], pos[2] + i)
            flag = 1
        else 
            pos = (pos[1] + i, pos[2])
            flag = 0
        end
    end

    along!(robot, Ost, pos[1] - 1)
    putmarker!(robot)
    num_steps_along!(robot, Ost)
    along!(robot, Nord, pos[2] - 1)
    putmarker!(robot)
    num_steps_along!(robot, Nord)
    num_steps_along!(robot, West)
    along!(robot, Ost, pos[1] - 1)
    putmarker!(robot)
    num_steps_along!(robot, West)
    num_steps_along!(robot, Sud)
    along!(robot, Nord, pos[2] - 1)
    putmarker!(robot)
    num_steps_along!(robot, Sud)

    move_to_back_complex!(robot, back_path)
end

function move_to_angle_complex!(robot)
    moves = []
    side = Sud
    while !isborder(robot, West) || !isborder(robot, Sud)
        push!(moves, num_steps_along!(robot, side))
        if side == Sud
            side = West
        else
            side = Sud
        end
    end
    return moves
end

function num_steps_along!(robot, direct)::Int #перемещает робота в заданном направлении до упора и возвращает число фактически сделанных им шагов
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

function move_to_back_complex!(robot, back_path)
    back_path = reverse(back_path)
    side = Nord
    if size(back_path)[1] % 2 == 0
        side = Ost
    end

    for i in back_path
        along!(robot, side, i)
        if side == Nord
            side = Ost
        else
            side = Nord
        end
    end
end

function along!(robot, direct, num_steps)::Nothing #перемещает робота в заданном направлении на заданное число шагов (предполагается, что это возможно)
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

mark_perimeter_complex_in_4_pos!(r)