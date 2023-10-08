using HorizonSideRobots

r = Robot("untitled.sit", animate = true)

function mark_kross_x!(robot) #1 #робот - в исходном положении в центре из косого креста из маркеров
    putmarker!(robot)
    for side in ((Nord,West), (Sud,West), (Sud,Ost), (Nord,Ost))
        num_steps = numsteps_mark_along!(robot, side)
        along!(robot, inverse(side), num_steps)
    end
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

function numsteps_mark_along!(robot, direct)::Int #перемещает робота в заданном направлении до упора, после каждого шага ставя маркер, и возвращает число фактически сделанных им шагов
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
        num_steps += 1
    end
    return num_steps
end

HorizonSideRobots.move!(robot, side::NTuple{2,HorizonSide}) = for s in side move!(robot, s) end

HorizonSideRobots.isborder(robot, side::NTuple{2,HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])

inverse(direct::NTuple{2, HorizonSide}) = inverse.(direct)

mark_kross_x!(r)