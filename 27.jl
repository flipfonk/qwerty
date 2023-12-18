function sum(vector, s=0)

    if length(vector) == 0
        return s
    end

    return sum(vector[end] + vector[1:end - 1], s)
end

vector = [1, 2, 3]

print(sum(vector))