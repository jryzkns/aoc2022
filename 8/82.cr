forest = Array( Array( Int32 ) ).new
File.open( "input" ).each_line do | line |
    row = Array( Int32 ).new
    line.each_char do | ch |
        row << ch.to_i
    end
    forest << row
end

def cardinalDirections( x, y, w, h )
    yield true, ( 0 .. y - 1 ).reverse_each
    yield true, ( y + 1 .. h - 1 ).each
    yield false, ( 0 .. x - 1 ).reverse_each
    yield false, ( x + 1 .. w - 1 ).each
end

def visibilityScore( forest, x, y, w, h )
    tree = forest[ y ][ x ]
    score = 1
    cardinalDirections( x, y, w, h ) do | isY, itr |
        viewDist = 0
        if isY
            itr.each do | y_cursor |
                viewDist += 1
                if forest[ y_cursor ][ x ] >= tree
                    break
                end
            end
        else
            itr.each do | x_cursor |
                viewDist += 1
                if forest[ y ][ x_cursor ] >= tree
                    break
                end
            end
        end
        score *= viewDist
    end
    return score
end

h = forest.size
w = forest[ 0 ].size

maxVisScore = 0
( 0 .. h - 1 ).each do | y |
    ( 0 .. w - 1 ).each do | x |
        maxVisScore = Math.max( maxVisScore, visibilityScore( forest, x, y, w, h ) )
    end
end

puts maxVisScore
