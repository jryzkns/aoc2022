alias Point = Tuple( Int32, Int32 )
alias Strand = Array( Point )
cave = Array( Strand ).new

File.open( "input" ).each_line do | line |
# File.open( "testinput" ).each_line do | line |
    cave << line.split( " -> " ).map { | pair |
        Point.from pair.split( "," ).map { | val | val.to_i }
    }
end

firstPt = cave[ 0 ][ 0 ]
minX, maxX = firstPt[ 0 ], firstPt[ 0 ]
maxYpre = firstPt[ 1 ]
maxY = firstPt[ 1 ]
cave.each do | strand |
    strand.each do | ( x, y ) |
        minX = Math.min( x, minX )
        maxX = Math.max( x, maxX )
        maxY = Math.max( y, maxY )
    end
end

xOffset = minX - 500
minX = 0
maxX= maxX - xOffset + 500
maxYpre = maxY
maxY = maxYpre + 10
cave.each_with_index do | strand, strandIdx |
    strand.each_with_index do | ( x, y ), pointIdx |
        cave[ strandIdx ][ pointIdx ] = Point.new( x - xOffset - 1, y )
    end
end

caveMap = Array( Array( Int32 ) ).new
maxY.times do | _ |
    row = Array( Int32 ).new
    maxX.times do | _ |
        row << 0
    end
    caveMap << row
end

def sign( x )
    if x < 0
        return -1
    elsif x == 0
        return 0
    else # x > 0
        return 1
    end
end

def pointRange( startPoint, endPoint )
    ex, ey = endPoint
    yield startPoint
    while startPoint != endPoint
        sx, sy = startPoint
        # move startPoint towards endPoint by one step, yield it
        dx, dy = ex - sx, ey - sy
        startPoint = Point.new( sx + sign( dx ), sy + sign( dy ) )
        yield startPoint
    end
end

cave.each do | strand |
    strand.each.cons_pair.each do | src, dst |
        pointRange( src, dst ) do | ( x, y ) |
            caveMap[ y ][ x ] = 1
        end
    end
end

maxX.times do | i |
    caveMap[ maxYpre + 2 ][ i ] = 5
end

spawnPoint = Point.new( 500 - xOffset - 1, 0 )
caveMap[ spawnPoint[ 1 ] ][ spawnPoint[ 0 ] ] = 9

caveMap.each do | row |
    row.each do | v |
        print v
    end
    puts
end

stop = false
particleCount = 0
while !stop
    particle = spawnPoint.dup
    while true
        px, py = particle[ 0 ], particle[ 1 ]
        if ( py + 1 == maxY ) || ( px - 1 < 0 ) || ( px + 1 == maxX )
            stop = true
            break
        end
        if ( caveMap.dig py + 1, px ) == 0
            particle = Point.new( px, py + 1 )
        elsif ( caveMap.dig py + 1, px - 1 ) == 0
            particle = Point.new( px - 1, py + 1 )
        elsif ( caveMap.dig py + 1, px + 1 ) == 0
            particle = Point.new( px + 1, py + 1 )
        else
            if particle == spawnPoint
                particleCount += 1
                stop = true
                break
            end
            caveMap[ py ][ px ] = 2
            particleCount += 1
            break
        end
    end
end

caveMap.each do | row |
    row.each do | v |
        print v
    end
    puts
end
puts particleCount
