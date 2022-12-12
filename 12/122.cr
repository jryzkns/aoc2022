alias Coordinate = Tuple( Int32, Int32 )
alias Edge = Tuple( Coordinate, Coordinate )

def reachable( map, pos, dst )
    elevationGain = map.dig( *dst ) - map.dig( *pos )
    elevationGain < 2
end

def formNeighbors( r, c, w, h )
    if r > 0
        yield ( { r - 1, c } )
    end
    if r < h - 1
        yield ( { r + 1, c } )
    end
    if c > 0
        yield ( { r, c - 1 } )
    end
    if c < w - 1
        yield ( { r, c + 1 } )
    end
end

def reachableNeighbors( map, r, c, w, h )
    formNeighbors( r, c, w, h ) do | dst |
        if reachable( map, { r, c }, dst )
            yield dst
        end
    end
end

map = Array( Array( Int32 ) ).new
possibleStartPos = Array( Coordinate ).new
endPos : ( Coordinate | Nil ) = nil
File.open( "input" ).each_line.each_with_index do | line, r |
    row = Array( Int32 ).new
    line.each_char.each_with_index do | elevation, c |
        if elevation == 'S'
            elevation = 'a'
            startPos = { r, c }
        end
        if elevation == 'E'
            elevation = 'z'
            endPos = { r, c }
        end
        if elevation == 'a'
            possibleStartPos << { r, c }
        end
        row << ( elevation.ord - 'a'.ord )
    end
    map << row
end

endPos = endPos.as( Coordinate )

def shortestPath( map, startPos, endPos )
    mapH, mapW = map.size, map[ 0 ].size
    shortestPaths = Array( Array( Int32 ) ).new
    map.each_index do | r |
        row = Array( Int32 ).new
        map[ 0 ].each_index do | c |
            row << Int32::MAX
        end
        shortestPaths << row
    end

    shortestPaths[ startPos[ 0 ] ][ startPos[ 1 ] ] = 0
    queue = Deque( Coordinate ).new
    queue << startPos
    while !queue.empty?
        pos = queue.shift
        shortestPathPos = shortestPaths.dig( *pos )
        reachableNeighbors( map, *pos, mapW, mapH ) do | nx, ny |
            # dont bother considering this neighbor if there was a faster way to get here already
            if shortestPaths[ nx ][ ny ] < shortestPathPos + 1
                next
            end
            shortestPaths[ nx ][ ny ] = Math.min( shortestPathPos + 1, shortestPaths[ nx ][ ny ] )
            queue.delete ( { nx, ny } ) # hacky af but this makes sure we don't have duplicates in queue
            queue << { nx, ny }
        end
    end

    shortestPaths.dig *endPos
end

p possibleStartPos.map { | startPos |
    shortestPath( map, startPos, endPos )
}.min
