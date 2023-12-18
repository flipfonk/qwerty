using HorizonSideRobots
robot = Robot("untitled.sit", animate=true)

function main(robot::Robot)
    direction = Ost
    first = count_steps(robot, West)
    second = count_steps(robot, Sud)
    chetnost = parity(first, second)
    while !isborder(robot, Nord) || !isborder(robot, Ost)
        along(robot, direction, chetnost)
        if isborder(robot, Nord) && isborder(robot, Ost)
            break
        else
            move!(robot, Nord)
            direction = inverse(direction)
        end
    end
    to_start(robot, second, first)
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

left(side) = HorizonSide(mod(Int(side) + 1, 4))

function parity(a, b)
    return (a + b) % 2 == 0
end

function to_start(r::Robot, ver::Int64, hor::Int64)
    while isborder(r, Sud) == false
        move!(r, Sud)
    end
    while isborder(r, West) == false
        move!(r, West)
    end
    for i in 1:ver
        move!(r, Nord)
    end
    for i in 1:hor
        move!(r, Ost)
    end
end

function count_steps(r::Robot, side::HorizonSide)::Int
    num_steps = 0
    while isborder(r, side) == false
        num_steps += 1
        move!(r, side)
    end
    return num_steps
end

function obhod(robot::Robot, side)
    normal_side = left(side)
    back_side = inverse(normal_side)
    n = 0
    while isborder(robot, side) == true && isborder(robot, normal_side) == false
        move!(robot, normal_side)
        n += 1
    end
    if isborder(robot, side) == true
        for i in 1:n
            move!(robot, back_side)
        end
        return false, 0
    end
    move!(robot, side)
    if n > 0
        k = along!(() -> !isborder(robot, back_side), robot, side)
        for i in 1:n
            move!(robot, back_side)
        end
    end
    return true, k
end
function try_move!(robot, side)
    if isborder(robot, side)
        return false
    else
        move!(robot, side)
        return true
    end
end
function along!(stop_condition::Function, robot, side)
    k = 0
    while stop_condition() == false && try_move!(robot, side)
        k += 1
    end
    return k
end
function along(robot::Robot, side::HorizonSide, parity::Bool)
    while true
        a, b = try_move(robot, side, parity)
        if a
            if b > 0
                parity = parity && (b + 1) % 2 == 0
            else
                parity = !parity
            end
        else
            break
        end
    end
end

function try_move(robot, side, parity)
    if isborder(robot, side)
        if parity
            putmarker!(robot)
        end
        return obhod(robot, side)
    else
        if parity
            putmarker!(robot)
        end
        move!(robot, side)
        return true, 0
    end
end


main(robot)