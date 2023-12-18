using HorizonSideRobots

r = Robot("untitled.sit", animate=true)

function double_way!(r, side)
    if isborder(r, side)
        return
    end

    move!(r, side)
    double_way!(r, side)

    move!(r, inverse(side))
    move!(r, inverse(side))

end

inverse(s::HorizonSide) = HorizonSide(mod(Int(s) + 2, 4))

double_way!(r, Sud)