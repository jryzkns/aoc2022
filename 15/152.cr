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

rowNum = 2_000_000
beaconAtRow = Set( Coordinate ).new
blankAtRow = Set( Coordinate ).new

knownCoords = Set( Coordinate ).new

File.open( "input" ).each_line do | line |
    match = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.match( line )
    if !match
        next
    end
    sx, sy, bx, by = match.not_nil!.captures.map { | v | v.not_nil!.to_i }

    knownCoords << Coordinate.new( sx, sy )
    knownCoords << Coordinate.new( bx, by )

    dist = manhattanDistance( sx, sy, bx, by )
    regionBottom = sy - dist
    regionTop = sy + dist
    ( regionBottom..regionTop ).each do | h |
        diamondSliceItr( sx, sy, dist, h - sy ) do | coord |
            if ( 0 <= coord[ 0 ] <= 4_000_000 ) && ( 0 <= coord[ 1 ] <= 4_000_000 )
                knownCoords << coord
            end
        end
    end
end

def lookForUnknown( knownCoords )
    ( 0..4_000_000 ).each do | xVal |
        ( 0..4_000_000 ).each do | yVal |
            pos = Coordinate.new xVal, yVal
            if knownCoords.includes? pos
                return pos
            end
        end
    end
    nil
end

found = lookForUnknown( knownCoords ).not_nil!

puts found
puts found[ 0 ] * 4_000_000 + found[ 1 ]
