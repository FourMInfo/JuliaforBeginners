score = 0
n = 5
for i in 1:n
    a = rand(1:10)
    b = rand(1:10)
    print(a, "*", b, " = ")
    c = parse(Int, readline(stdin))
    if a * b == c
        printstyled("Yay! Correct\n", color=:green)
        global score += 1
    else
        printstyled("Dumbass!\n", color=:red)
    end
end
printstyled("Score is $score out of $n\n", color=:yellow)