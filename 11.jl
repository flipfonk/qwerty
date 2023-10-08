using HorizonSideRobots

r = Robot("untitled.sit", animate = true)

function walls_count(robot)
    west_steps = num_steps_along!(robot, West)
    sud_steps = num_steps_along!(robot, Sud)

    walls = 0
    flag = 0
    side = West
    while !isborder(robot, Nord)
        flag = 0
        side = inverse(side)
        while !isborder(robot, side)
            if isborder(robot, Nord) && flag == 0
                walls += 1
                flag = 1
            end
            if !isborder(robot, Nord)
                flag = 0
            end
            move!(robot, side)
        end
        move!(robot, Nord)
    end

    num_steps_along!(robot, West)
    num_steps_along!(robot, Sud)
    along!(robot, Nord, sud_steps)
    along!(robot, Ost, west_steps)

    return(walls)
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

print(walls_count(r))