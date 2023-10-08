using HorizonSideRobots

r=Robot("untitled.sit", animate=true)

function mark_perimeter(robot) #Робот - в исходном положении, и все клетки по периметру внешней рамки промаркированы
    nord_steps = num_steps_along!(robot, Nord)
    west_steps = num_steps_along!(robot, West)
    for side in (Sud, Ost, Nord, West)
        mark_along!(robot, side)
    end
    along!(robot, Sud, nord_steps)
    along!(robot, Ost, west_steps)
end

function num_steps_along!(robot, direct)::Int #перемещает робота в заданном направлении до упора и возвращает число фактически сделанных им шагов
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

function mark_along!(robot, direct)::Nothing #перемещает робота в заданном направлении до упора, после каждого шага ставя маркер
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
    end
end

function along!(robot, direct, num_steps)::Nothing #перемещает робота в заданном направлении на заданное число шагов (предполагается, что это возможно)
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

mark_perimeter(r)