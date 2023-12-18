using HorizonSideRobots

r = Robot("untitled.sit", animate = true) 

function spiral!(robot)
    s = Ost
    n = 1

    while !ismarker(robot)
        s = left(s)
        line!(robot, s, n)
        n += 1
    end
end

function wall(robot::Robot, side::HorizonSide, steps::Int)
    ort = left(side)
    t = try_move!(robot, side)
    if t == 4
        return 0
    elseif t
        try_along!(robot, inverse(ort), steps)
    else
        if isborder(robot, side)
            move!(robot, ort)
            steps += 1
            x = wall(robot, side, steps)
            steps += x
            return steps
        end
    end
    return 0
end

function line!(robot, s, n)
    t = 1
    
    while t < n
        wall(robot, s, 0)
        t += 1
    end
end

function try_along!(robot, side, n)
    for i in 1:n
        try_move!(robot, side)
    end
end

function inverse(s)
    return HorizonSide(mod(Int(s) + 2, 4))
end

left(side) = HorizonSide(mod(Int(side) + 1, 4))

function try_move!(robot, side)
    if ismarker(robot)
        return 4
    end
    if !isborder(robot, side) 
        move!(robot, side)
        return true
    else 
        return false
    end
end



spiral!(r)