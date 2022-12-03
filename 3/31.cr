def itemPrio( ch )
    if ch.ascii_uppercase?
        26 + ch.ord - 'A'.ord + 1
    else
        ch.ord - 'a'.ord + 1
    end
end

priorities = 0
File.open( "input" ).each_line do | ruckSack |
    compartmentSize = ruckSack.size >> 1

    comp1inventory = Hash( Char, Int16 ).new
    ruckSack[ ..compartmentSize - 1 ].each_char do | item |
        if !comp1inventory[ item ]?
            comp1inventory[ item ] = 0
        end
        comp1inventory[ item ] += 1
    end

    comp2inventory = Hash( Char, Int16 ).new
    ruckSack[ compartmentSize.. ].each_char do | item |
        if !comp2inventory[ item ]?
            comp2inventory[ item ] = 0
        end
        comp2inventory[ item ] += 1
    end

    comp1Items = Set( Char ).new( comp1inventory.each_key )
    comp2Items = Set( Char ).new( comp2inventory.each_key )
    ( comp1Items & comp2Items ).each do | item |
        priorities += itemPrio( item )
    end
end
puts priorities
