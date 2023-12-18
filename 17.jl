using HorizonSideRobots

r = Robot("untitled.sit", animate = true)

function spiral!(stop_condition, robot)
    side = Ost
    side_length = 1
    while !stop_condition()
        for i in 1:2
            move!(stop_condition, robot, side, side_length)
            side = left(side)
        end
        side_length += 1
    end
end

left(side) = HorizonSide(mod(Int(side) + 1, 4))

function try_move!(stop_condition, robot, side)
    if !stop_condition()     
        move!(robot, side)
    end
end

function HorizonSideRobots.move!(stop_condition::Function, robot::Robot, side::HorizonSide, num::Integer)
    for i in 1:num
        try_move!(stop_condition, robot, side)
    end
end

spiral!(() -> ismarker(r), r)