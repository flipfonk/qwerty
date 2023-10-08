using HorizonSideRobots

r=Robot("untitled.sit", animate=true)

function mark_field!(robot)  #Робот - в исходном положении, и все клетки поля промаркированы
    nord_steps = num_steps_along!(robot, Nord)
    west_steps = num_steps_along!(robot, West)
    height = 1
    width = 1
    while !isborder(robot, Ost)  #делаем один проход вне основного цикла while, чтобы посчитать ширину поля, нужную для возвращения в исходную точку
        mark_row!(robot, Ost)
        width += 1
    end
    putmarker!(robot)
    move!(robot, Sud)
    side = West
    while !isborder(robot, Ost) || !isborder(robot, Sud)
        while !isborder(robot, side)
            mark_row!(robot, side)
        end
        putmarker!(robot)
        try_move!(robot, Sud)
        height += 1
        if side == Ost
            side = West
        else
            side = Ost
        end
    end
    along!(robot, Nord, height - nord_steps - 1)
    along!(robot, West, width - west_steps - 1)
end

function num_steps_along!(robot, direct)::Int #перемещает робота в заданном направлении до упора и возвращает число фактически сделанных им шагов
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

mark_row!(robot, side) = (putmarker!(robot); markstaigth!(robot, side)) #функция из указания, не совсем понял, в чем ее суть (можно было сделать кратче)

function markstaigth!(robot, side)
    move!(robot, side)
end

function try_move!(robot, direct)::Bool #делает попытку одного шага в заданном направлении и возвращает true, в случае, если это возможно, и false - в
    if isborder(robot, direct)          #противном случае (робот остается в исходном положении) 
        return false
    end
    move!(robot, direct)
    return true
end

function along!(robot, direct, num_steps)::Nothing #перемещает робота в заданном направлении на заданное число шагов (предполагается, что это возможно)
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

mark_field!(r)