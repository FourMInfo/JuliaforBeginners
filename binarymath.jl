function half_adder(A, B) 
    S = xor(A, B)
    Cout = A & B
    Cout, S    
end

function full_adder(A, B, Cin)
    T = xor(A, B)
    S = xor(Cin, T)
    Cout = (A & B) | (Cin & T)
    Cout, S
end

function nibble_adder(A4, A3, A2, A1, B4, B3, B2, B1)
    carry, S1 = half_adder(A1, B1)
    carry, S2 = full_adder(A2, B2, carry)
    carry, S3 = full_adder(A3, B3, carry)
    carry, S4 = full_adder(A4, B4, carry)
            
    S4, S3, S2, S1
end

function binary_multiply(input, counter)
    accumulator = 0
    input += 0b0000_0000_0000_0000
    while counter > 0
        if counter & 1 == 1
            accumulator += input
        end
        counter >>= 1
        input <<= 1
    end
    accumulator
end