x = 1
cycle = 0
spritePositions = { 0 , 1 , 2 }.to_set
def setSpritePositions( x )
    { x - 1 , x, x + 1 }.to_set
end

notableCycles = { 20, 60, 100, 140, 180, 220 }.to_set
File.open( "input" ).each_line do | instruction |
    if addMatch = /addx (-?\d+)/.match( instruction )
        v = addMatch.not_nil!.captures[ 0 ].not_nil!.to_i
        if cycle % 40 == 0
            puts
        end
        print( ( spritePositions.includes? ( cycle % 40 ) ) ? '#' : '.' )
        cycle += 1
        if cycle % 40 == 0
            puts
        end
        print( ( spritePositions.includes? ( cycle % 40 ) ) ? '#' : '.' )
        cycle += 1
        x += v
        spritePositions = setSpritePositions( x )
    elsif instruction == "noop"
        if cycle % 40 == 0
            puts
        end
        print( ( spritePositions.includes? ( cycle % 40 ) ) ? '#' : '.' )
        cycle += 1
    end
end

if cycle % 40 == 0
    puts
end
print( ( spritePositions.includes? cycle ) ? '#' : '.' )
