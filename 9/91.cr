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

# the possible positions where a head can be relative to the tail is as follows:
# .HHH.
# H...H
# H.T.H
# H...H
# .HHH.
# note how there is a ring of 9 spaces between H and T, and that there are 12 possible
# spots for H to be in. For simplicity we will say that H follows clock convention.
# ex. H at 0 oclock means T moves up 1, H at 7 or 8 oclock means T moves SW by 1
def tailFollow( tail : Coordinate, head : Coordinate ) : Coordinate
    if chebyshevDist( tail, head ) < 2
        return tail
    end
    tailFollowMove = {
        {  0,  2 } => {  0,  1 }, #  0'oclock
        {  1,  2 } => {  1,  1 }, #  1'oclock
        {  2,  1 } => {  1,  1 }, #  2'oclock
        {  2,  0 } => {  1,  0 }, #  3'oclock
        {  2, -1 } => {  1, -1 }, #  4'oclock
        {  1, -2 } => {  1, -1 }, #  5'oclock
        {  0, -2 } => {  0, -1 }, #  6'oclock
        { -1, -2 } => { -1, -1 }, #  7'oclock
        { -2, -1 } => { -1, -1 }, #  8'oclock
        { -2,  0 } => { -1,  0 }, #  9'oclock
        { -2,  1 } => { -1,  1 }, # 10'oclock
        { -1,  2 } => { -1,  1 }, # 11'oclock
    }
    move = tailFollowMove[ { head[ 0 ] - tail[ 0 ], head[ 1 ] - tail[ 1 ] } ]
    { tail[ 0 ] + move[ 0 ], tail[ 1 ] + move[ 1 ] }
end

headPosition : Coordinate = { 0, 0 }
tailPosition : Coordinate = { 0, 0 }
tailPositions = Set( Coordinate ).new
File.open( "input" ).each_line do | line |
    if cmdMatch = /(\w) (\d+)/.match( line )
        direction, steps = cmdMatch.not_nil!.captures.map { | val | val.not_nil! }
        steps = steps.to_i

        steps.times do
            headPosition = moveHead( headPosition, direction )
            tailPosition = tailFollow( tailPosition, headPosition )
            tailPositions << tailPosition
        end

    end
end
p tailPositions.size
