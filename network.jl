function generator()
    # the Channel() function is a constructor for a channel. First it creates the channel
    # since no capacity is defined, the default is one character
    # the do-end defines an anonymous function that is scheduled by the constructor
    Channel() do channel
        # the for loop defines the task scheduled:
        # Characters are placed in the channel when it is empty. There is only room for 1 characters
        # so the task is blocked until someones takes the character from the channel
        for i in 0:5
            println("putting ", 
                    Char('A' + i), 
                    " into the channel\n")
            put!(channel, Char('A' + i))
        end
    end
end
# Example
# when you create generator, it puts first letter A in the channel. 
# when you take A, the channel empties out and it puts B etc.
# julia> g = generator()
# putting A into the channel
# Channel{Any}(0) (1 item available)
# julia> take!(g)
# putting B' into the channel
# A 
# ': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)
# julia> take!(g)
# putting C' into the channel
# B
# ': ASCII/Unicode U+0042 (category Lu: Letter, uppercase)
# As the collect iterates over the channel, it pulls a letter into the array, 
# and the generator puts another one into the empty channel
# julia> g = generator()

# putting A into the channel

# Channel{Any}(0) (1 item available)
# julia> collect(g)
# putting B into the channel

# putting C into the channel

# putting D into the channel

# putting E into the channel

# putting F into the channel

# 6-element Vector{Any}:
#  'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)
#  'B': ASCII/Unicode U+0042 (category Lu: Letter, uppercase)
#  'C': ASCII/Unicode U+0043 (category Lu: Letter, uppercase)
#  'D': ASCII/Unicode U+0044 (category Lu: Letter, uppercase)
#  'E': ASCII/Unicode U+0045 (category Lu: Letter, uppercase)
#  'F': ASCII/Unicode U+0046 (category Lu: Letter, uppercase)

# server side
# copy and run in Julia terminal
# using Sockets

# @async begin
     # this is the first task which listens on port 2001
#    server = listen(2001)

#    while true
         # this waits for connection and so blocks server task
#        sock = accept(server)
         # When the client connects we block on the readline since the client hasn't written anything
#        @async while isopen(sock)
             # when the client writes to the socket this task is scheduled
            # it reads the line sent
#           line = readline(sock, keep=true)  
            # uppercases read line, and sends it back to client
#           write(sock, uppercase(line))
#        end
#    end
# end

# client side
# copy and run in another Julia terminal
# julia> using Sockets
# connect to server post
# julia> clientside = connect(2001)
# TCPSocket(RawFD(22) open, 0 bytes waiting)
# we create another asnchronous task to read from the server
# since there is nothing written to the server it blocks oon readline
# julia> @async while isopen(clientside)
#            line = readline(clientside, keep=true)  
#            write(stdout, line)
#        end
# Task (runnable) @0x000000011438ca90
# while the task is blocked we can write to the server
# julia> println(clientside, "Hello World")
# the readline task is now scheduled, reads the line that the server has converted to uppercase and prints in on terminal
# julia> HELLO WORLD
# julia> 
# lets write another line
# julia> println(clientside, "This is cool")
# the unblocked readline task above brings us back the response
# julia> THIS IS COOL