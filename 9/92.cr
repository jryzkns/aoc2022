alias Coordinate = Tuple( Int32, Int32 )

def moveHead( head : Coordinate, direction : String ) : Coordinate
    x, y = head
    case direction
    when "U"
        {     x, y + 1 }
    when "D"
        {     x, y - 1 }
    when "L"
        { x - 1,     y }
    when "R"
        { x + 1,     y }
    else
        head
    end
end

def chebyshevDist( a : Coordinate, b : Coordinate ) : Int32
    x1, y1 = a
    x2, y2 = b
    Math.max( ( x1 - x2 ).abs, ( y1 - y2 ).abs )
end

# the logic here isnt as clean as the clock in part 1, but same idea holds
def follow( tail : Coordinate, head : Coordinate ) : Coordinate
    if chebyshevDist( tail, head ) < 2
        return tail
    end
    tailFollowMove = {
        {  0,  2 } => {  0,  1 },
        {  1,  2 } => {  1,  1 },
        {  2,  2 } => {  1,  1 },
        {  2,  1 } => {  1,  1 },
        {  2,  0 } => {  1,  0 },
        {  2, -1 } => {  1, -1 },
        {  2, -2 } => {  1, -1 },
        {  1, -2 } => {  1, -1 },
        {  0, -2 } => {  0, -1 },
        { -1, -2 } => { -1, -1 },
        { -2, -2 } => { -1, -1 },
        { -2, -1 } => { -1, -1 },
        { -2,  0 } => { -1,  0 },
        { -2,  1 } => { -1,  1 },
        { -2,  2 } => { -1,  1 },
        { -1,  2 } => { -1,  1 },
    }
    move = tailFollowMove[ { head[ 0 ] - tail[ 0 ], head[ 1 ] - tail[ 1 ] } ]
    { tail[ 0 ] + move[ 0 ], tail[ 1 ] + move[ 1 ] }
end

head : Coordinate = { 0, 0 }
tail = Array( Coordinate ).new
9.times do tail << { 0, 0 } end
lastPositions = Set( Coordinate ).new
File.open( "input" ).each_line do | line |
    if cmdMatch = /(\w) (\d+)/.match( line )
        direction, steps = cmdMatch.not_nil!.captures.map { | val | val.not_nil! }
        steps = steps.to_i

        steps.times do
            head = moveHead( head, direction )

            h = head
            tail.each_with_index do | knot, idx |
                knot = follow( knot, h )
                tail[ idx ] = knot
                h = knot
            end

            lastPositions << tail[ -1 ]

        end

    end
end
p lastPositions.size
