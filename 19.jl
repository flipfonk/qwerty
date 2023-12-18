using HorizonSideRobots

r = Robot("untitled.sit", animate=true)

function recursion(r, side)
    if !isborder(r, side)
        move!(r, side)
        recursion(r, side)
    else
        return Nothing
    end
end

recursion(r, Sud)