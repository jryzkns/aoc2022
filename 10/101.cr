x = 1
cycle = 0
ttl = 0

notableCycles = { 20, 60, 100, 140, 180, 220 }.to_set
File.open( "input" ).each_line do | instruction |
    if addMatch = /addx (-?\d+)/.match( instruction )
        v = addMatch.not_nil!.captures[ 0 ].not_nil!.to_i
        cycle += 1
        if notableCycles.includes? cycle
            puts "at cycle #{cycle}, #{cycle} x #{x} = #{ cycle * x }"
            ttl += cycle * x
        end
        cycle += 1
        if notableCycles.includes? cycle
            puts "at cycle #{cycle}, #{cycle} x #{x} = #{ cycle * x }"
            ttl += cycle * x
        end
        x += v
    elsif instruction == "noop"
        cycle += 1
        if notableCycles.includes? cycle
            puts "at cycle #{cycle}, #{cycle} x #{x} = #{ cycle * x }"
            ttl += cycle * x
        end
    end
end

if notableCycles.includes? cycle
    puts "at cycle #{cycle}, #{cycle} x #{x} = #{ cycle * x }"
    ttl += cycle * x
end

puts ttl
