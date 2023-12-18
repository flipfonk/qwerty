using HorizonSideRobots

r = Robot("untitled.sit", animate=true)

function throw_wall(robot::Robot, side::HorizonSide, steps::Int=0)
    normal = left(side)

    if try_move!(robot, side)
        move!(robot, inverse(normal), steps)

    else
        if isborder(robot, side)
            move!(robot, normal)
            steps += 1

            x = throw_wall(robot, side, steps)
            steps += x
            return steps
        end
    end
    
    return 0
end

function HorizonSideRobots.move!(robot::Robot, s::HorizonSide, num::Integer)
    for i in 1:num
        move!(robot, s)
    end
end

function try_move!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        return true
    else
        return false
    end
end

inverse(s::HorizonSide) = HorizonSide(mod(Int(s) + 2, 4))

left(side) = HorizonSide(mod(Int(side) + 1, 4))

throw_wall(r, Ost)