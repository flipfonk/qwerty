using HorizonSideRobots

r = Robot("untitled.sit", animate = true)

function chess_marker(robot)
    sud_steps = num_steps_along!(robot, Sud)
    west_steps = num_steps_along!(robot, West)

    flag = 1
    if west_steps % 2 == 0
        flag = 0
    end
    
    side = Ost
    while !isborder(robot, Nord) || !isborder(robot, Ost)
        mark_along_chess_flag!(robot, side, flag)
        try_move!(robot, Nord)
        side = inverse(side)
    end

    num_steps_along!(robot, Sud)
    num_steps_along!(robot, West)
    along!(robot, Nord, sud_steps)
    along!(robot, Ost, west_steps)
end

function along!(robot, direct, num_steps)::Nothing #перемещает робота в заданном направлении на заданное число шагов (предполагается, что это возможно)
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

function num_steps_along!(robot, direct)::Int #перемещает робота в заданном направлении до упора и возвращает число фактически сделанных им шагов
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

function mark_along_chess_flag!(robot, direct, flag)::Nothing #перемещает робота в заданном направлении до упора, после каждого второго шага ставя маркер 
    if flag == 1
        while !isborder(robot, direct)
            if flag == 1
                putmarker!(robot)
            end
            move!(robot, direct)
            if flag == 1
                flag = 0
            else
                flag = 1
            end
        end
    else
        flag = 1
        while !isborder(robot, direct)
            move!(robot, direct)
            if flag == 1
                putmarker!(robot)
            end
            if flag == 1
                flag = 0
            else
                flag = 1
            end
        end
    end
end

function inverse(side::HorizonSide)::HorizonSide #возвращает направление, противоположное заданному
    if side == Nord
        return Sud
    elseif side == Sud
        return Nord
    elseif side == Ost
        return West
    else
        return Ost
    end
end

function try_move!(robot, direct)::Bool #делает попытку одного шага в заданном направлении и возвращает true, в случае, если это возможно, и false - в
    if isborder(robot, direct)          #противном случае (робот остается в исходном положении) 
        return false
    end
    move!(robot, direct)
    return true
end

chess_marker(r)