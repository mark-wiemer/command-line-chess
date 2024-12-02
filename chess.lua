-- b[1][2] is h2
function new_board()
    return {
        {'R2', 'N2', 'B2', 'Q2', 'K2', 'B2', 'N2', 'R2'},
        {'P2', 'P2', 'P2', 'P2', 'P2', 'P2', 'P2', 'P2'}, {}, {}, {}, {},
        {'P1', 'P1', 'P1', 'P1', 'P1', 'P1', 'P1', 'P1'},
        {'R1', 'N1', 'B1', 'Q1', 'K1', 'B1', 'N1', 'R1'}
    }
end

function print_board(b)
    for r = 1, 8 do
        for c = 1, 8 do
            local s = b[r][c] or nil
            s = s or (r + c) % 2 == 1 and '--' or '..'
            io.write(' ' .. s .. '  ')
        end
        io.write('\n\n')
    end
    io.write('\n')
end

function to_f_c(f_i) return ({'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'})[f_i] end

function to_chess(r_i, f_i)
    -- print('to_chess '..r_i..' '..f_i)
    local r_c = 9 - r_i
    local f_c = to_f_c(f_i)
    return f_c .. r_c
end

function to_i(coord)
    -- print('to_i '..coord)
    local f_c = coord:sub(1, 1)
    local r_c = tonumber(coord:sub(2, 2))
    local res = {f_i = to_f_i(f_c), r_i = 9 - r_c}
    -- print ('res '..res.r_i..' '..res.f_i)
    return res
end

function to_f_i(f_c)
    local f_i = ({a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8})[f_c]
    return f_i
end

function find_pawn(player, f_c, b)
    print('find_pawn ' .. player .. ' ' .. f_c)
    local f_i = to_f_i(f_c)
    local s = 1
    local e = 8
    local step = 1
    if (player == 2) then
        s = 8
        e = 1
        step = -1
    end
    for r_i = s, e, step do
        local row = b[r_i]
        print('Checking ' .. to_chess(r_i, f_i))
        local piece = row[f_i]
        io.write('Found ')
        if (piece) then
            io.write(piece)
        else
            io.write('nil')
        end
        io.write('\n')
        if (piece and piece:sub(1, 1) == 'P' and piece:sub(2, 2) ==
            tostring(player)) then
            local coord = to_chess(r_i, f_i)
            print('Found pawn at ' .. coord)
            return coord
        end
    end
    return nil
end

function find_piece(piece, player, coord)
    print("Can't find piece '" .. piece .. "' for player " .. player ..
              " that can move to coord " .. coord)
    return nil
end

function parse_alg(input, player, board)
    -- move pawn
    print('Parsing move')
    local from = nil
    if (#input == 2) then
        -- print('Finding pawn')
        from = find_pawn(player, input:sub(1, 1), board)
    end
    if (#input == 3) then
        print('Parsing common move')
        local piece = input:sub(1, 1)
        local coord = input:sub(2, 3)
        from = find_piece(piece, 1, coord)
    end
    if (from == nil) then return nil end
    return {from = from, dest = input}
end

function play()
    local board = new_board()
    print("Welcome to Command Line Chess :)\n")
    while (true) do
        print_board(board)
        io.write('Next move (q to quit): ')
        local input = io.read()

        -- quit
        if (input == 'q') then
            io.write('Quit? (q to confirm): ')
            input = io.read()
            if (input == 'q') then
                print('Goodbye!')
                break
            end
        end

        -- parse input
        local move = parse_alg(input, 1, board)
        if (move == nil) then
            print("Unrecognized move '" .. input .. "'")
            goto continue
        else
            print('Moving from ' .. move.from .. ' to ' .. move.dest)
        end

        -- todo validate move

        -- make move
        local from_i = to_i(move.from)
        local dest_i = to_i(move.dest)
        local from_p = board[from_i.r_i][from_i.f_i]
        board[from_i.r_i][from_i.f_i] = nil
        board[dest_i.r_i][dest_i.f_i] = from_p
        ::continue::
    end
end

play()
