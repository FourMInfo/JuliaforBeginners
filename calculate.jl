# function simple_multiply(x, y)
#    product = 0
#    for i in 1:x
#        product += y
#    end
#    product 
# end

# function simpledivide(dividend, divisor)
#     quotient = 0
#     remainder = dividend

#     while remainder - divisor >= 0
#         remainder -= divisor
#         quotient += 1
#     end
#     quotient, remainder 
# end

addend = 0
accumulator = 0
counter = 0
shifter = 0

function clear()
    global addend = 0
    global accumulator = 0
    global counter = 0
    global shifter = 0
    nothing
end

function setaddend!(x)
   global addend = x 
end

function leftshift!()
   global shifter += 1 
end

function rightshift!()
   global shifter -= 1 
end

function crank!(n)
    for _ in 1:n
        global accumulator += addend * 10^shifter
        global counter += 10^shifter
    end
    
    accumulator, counter 
end

function uncrank!(n)
    for _ in 1:n
        global accumulator -= addend * 10^shifter
        global counter -= 10^shifter
    end
    
    accumulator, counter 
end