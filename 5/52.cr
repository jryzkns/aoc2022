fp = File.open( "input" ).each_line

line = "<>"
stacksBuffer = Array( String ).new
while true
    line = fp.next.to_s
    if line == ""
        break
    end
    stacksBuffer << line
end

stacks = Hash( Int32, Array( Char ) ).new

binNums = stacksBuffer[ -1 ].split().map { | num | num.to_i }
binNums.each do | binNum |
    stacks[ binNum ] = Array( Char ).new
end

def readBufferPosition( binNum )
    4 * ( binNum - 1 ) + 1
end

stacksBuffer = stacksBuffer[ ..-2 ].reverse
stacksBuffer.each do | line |
    stacks.each_key do | key |
        pos = line[ readBufferPosition( key ) ]
        case pos
        when .whitespace?
            nil
        else
            stacks[ key ] << pos
        end
    end
end

instructionMatcher = /move (\d+) from (\d+) to (\d+)/
line = "<>"
while true
    line = fp.next
    if line == Iterator::Stop::INSTANCE
        break
    end
    matches = instructionMatcher.match( line.to_s ).not_nil!.captures
    numMoves, srcBin, dstBin = matches.map { | val | val.not_nil!.to_i }

    crates = stacks[ srcBin ].pop( numMoves )
    stacks[ dstBin ].concat( crates.reverse )
end

puts stacks.map { | k, v | v[ -1 ] }.join
