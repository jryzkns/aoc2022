forest = Array( Array( Int32 ) ).new
File.open( "input" ).each_line do | line |
    row = Array( Int32 ).new
    line.each_char do | ch |
        row << ch.to_i
    end
    forest << row
end

def cardinalDirections( x, y, w, h )
    yield true, ( 0 .. y - 1 )
    yield true, ( y + 1 .. h - 1 )
    yield false, ( 0 .. x - 1 )
    yield false, ( x + 1 .. w - 1 )
end

def isVisible( forest, x, y, w, h )
    tree = forest[ y ][ x ]
    cardinalDirections( x, y, w, h ) do | isY, itr |
        visible = true
        if isY
            itr.each do | y_cursor |
                if forest[ y_cursor ][ x ] >= tree
                    visible = false
                    break
                end
            end
        else
            itr.each do | x_cursor |
                if forest[ y ][ x_cursor ] >= tree
                    visible = false
                    break
                end
            end
        end
        if visible == true
            return 1
        end
    end
    return 0
end

h = forest.size
w = forest[ 0 ].size

visibleTrees = 2 * h + 2 * w - 4

( 1 .. h - 2 ).each do | y |
    ( 1 .. w - 2 ).each do | x |
        visibleTrees += isVisible( forest, x, y, w, h )
    end
end

puts visibleTrees
