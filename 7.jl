using HorizonSideRobots

r = Robot("untitled.sit", animate = true)

function find_hole_top(robot)
    if !isborder(robot, Nord)
        return
    end
    step = 1
    side = Ost
    while true
        for i in 1:step
            move!(robot, side)
        end
        if !isborder(robot, Nord)
            break
        end
        side = inverse(side)
        for i in 1:step
            move!(robot, side)
        end
        step += 0.5
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

find_hole_top(r)