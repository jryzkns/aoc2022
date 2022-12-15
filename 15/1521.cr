alias Coordinate = Tuple( Int32, Int32 )

def manhattanDistance( sx, sy, bx, by )
    ( sx - bx ).abs + ( sy - by ).abs
end

def diamondSliceItr( x, y, d, vd )
    start = Coordinate.new x - ( d - vd.abs ), y + vd

    ( 2 * ( d - vd.abs ) + 1 ).times do | i |
        yield Coordinate.new start[ 0 ] + i, start[ 1 ]
    end
end

( 0..4_000_000 ).each do | rowNum |
    rowNum = 4_000_000 - rowNum
    print "checking row #{rowNum} "

    known = Set( Int32 ).new
    File.open( "input" ).each_line do | line |
        match = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.match( line )
        if !match
            next
        end
        sx, sy, bx, by = match.not_nil!.captures.map { | v | v.not_nil!.to_i }
        if by == rowNum
            known << bx
        end
        if sy == rowNum
            known << sx
        end
        dist = manhattanDistance( sx, sy, bx, by )
        regionBottom = sy - dist
        regionTop = sy + dist
        if ! ( regionBottom <= rowNum <= regionTop )
            next
        end
        diamondSliceItr( sx, sy, dist, rowNum - sy ) do | ( x, y ) |
            if 0 <= x <= 4_000_000
                known << x
            end
        end
    end
    if known.size != 4_000_000
        ( 0..4_000_000 ).each do | col |
            if !known.includes? col
                puts "#{col} -> #{4_000_000 * col + rowNum }"
            end
        end
    end
    puts "-- done"
end
