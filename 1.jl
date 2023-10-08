using HorizonSideRobots

r = Robot("untitled.sit", animate = true)

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

function mark_kross!(robot) #1 #робот - в исходном положении в центре из прямого креста из маркеров
    for side in (Nord, West, Sud, Ost)
        num_steps = numsteps_mark_along!(robot, side)
        along!(robot, inverse(side), num_steps)
    end
    putmarker!(robot)
end

function numsteps_mark_along!(robot, direct)::Int #перемещает робота в заданном направлении до упора, после каждого шага ставя маркер, и возвращает число фактически сделанных им шагов
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
        num_steps += 1
    end
    return num_steps
end

mark_kross!(r)