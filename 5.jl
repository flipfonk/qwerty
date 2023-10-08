using HorizonSideRobots

r = Robot("untitled.sit", animate = true)

function mark_external_internal(robot) #Робот - в исходном положении и по всему периметру внутренней, как внутренней, так и внешней, перегородки поставлены маркеры.
    back_path = move_to_angle!(robot)
    #УТВ: робот - в юго-западном углу поля
    mark_external_rect!(robot)
    #УТВ: по периметру внешней рамки стоят маркеры
    find_internal_border!(robot)
    #УТВ: с севера от робота - внутренняя прямоугольная перегородка
    move_to_internal_sudwest!(robot)
    #УТВ: робот - во внешнем юго-западном углу внутренней прямоугольной перегородки
    mark_internal_rect!(robot)
    #УТВ: по периметру внутренней прямоугольной перегородки стоят маркеры
    move_to_angle!(robot)
    #УТВ: робот - в юго-западном углу поля
    move_to_back!(robot, back_path)
    #УТВ: робот - в исходном положении
end

function move_to_angle!(robot)
    return (side = Nord, num_steps = num_steps_along!(robot, Sud)), (side = Ost, num_steps = num_steps_along!(robot, West)), (side = Nord, num_steps = num_steps_along!(robot, Sud))
end

function num_steps_along!(robot, direct)::Int #перемещает робота в заданном направлении до упора и возвращает число фактически сделанных им шагов
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

function mark_external_rect!(robot)
    for side in (Ost, Nord, West, Sud)
        mark_along!(robot, side)
    end
end

function mark_along!(robot, direct)::Nothing #перемещает робота в заданном направлении до упора, после каждого шага ставя маркер
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
    end
end

function find_internal_border!(robot)
    function find_in_row(side) # - это определение локальной вспомогательной функции
        while !isborder(robot, Nord) && !isborder(robot, side)
            move!(robot, side)
        end
    end
    side = Ost
    find_in_row(side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        find_in_row(side)
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

function move_to_internal_sudwest!(robot)
    while isborder(robot, Nord)
        move!(robot, West)
    end
end

function mark_internal_rect!(robot)
    for side in (Ost, Nord, West, Sud)
        mark_along!(robot, side, left(side))
    end 
end

function mark_along!(robot, move_side, border_side)
    move!(robot, move_side)
    putmarker!(robot)
    while isborder(robot, border_side)
        move!(robot, move_side)
        putmarker!(robot)
    end
end

left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1, 4))

function move_to_back!(robot, back_path)
    for next in back_path
        along!(robot, next.side, next.num_steps)
    end
end

function along!(robot, direct, num_steps)::Nothing #перемещает робота в заданном направлении на заданное число шагов (предполагается, что это возможно)
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

mark_external_internal(r)