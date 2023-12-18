using HorizonSideRobots

r = Robot("untitled.sit", animate=true)

function move_mark_along!(r, side)
    if isborder(r, side)
        putmarker!(r)
        return
    end
    move!(r, side)
    move_mark_along!(r, side)
    move!(r, inverse(side))
end

inverse(s::HorizonSide) = HorizonSide(mod(Int(s) + 2, 4))

move_mark_along!(r, Sud)