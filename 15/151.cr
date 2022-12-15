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
File.open( "input" ).each_line do | line |
    match = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.match( line )
    if !match
        next
    end
    sx, sy, bx, by = match.not_nil!.captures.map { | v | v.not_nil!.to_i }
    if by == rowNum
        beaconAtRow << Coordinate.new( bx, by )
    end
    dist = manhattanDistance( sx, sy, bx, by )
    regionBottom = sy - dist
    regionTop = sy + dist
    if ! ( regionBottom <= rowNum <= regionTop )
        next
    end
    puts "( #{sx}, #{sy} ) is #{dist} far from ( #{bx}, #{by} )"
    diamondSliceItr( sx, sy, dist, rowNum - sy ) do | coord |
        if beaconAtRow.includes? coord
            next
        end
        blankAtRow << coord
    end
end

puts blankAtRow.size
