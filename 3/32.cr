def itemPrio( ch )
    if ch.ascii_uppercase?
        26 + ch.ord - 'A'.ord + 1
    else
        ch.ord - 'a'.ord + 1
    end
end

priorities = 0
File.open( "input" ).each_line.in_groups_of( 3 ) do | ( ruckSack1, ruckSack2, ruckSack3 ) |

    rsinventory1 = Hash( Char, Int16 ).new
    ruckSack1.not_nil!.each_char do | item |
        if !rsinventory1[ item ]?
            rsinventory1[ item ] = 0
        end
        rsinventory1[ item ] += 1
    end

    rsinventory2 = Hash( Char, Int16 ).new
    ruckSack2.not_nil!.each_char do | item |
        if !rsinventory2[ item ]?
            rsinventory2[ item ] = 0
        end
        rsinventory2[ item ] += 1
    end

    rsinventory3 = Hash( Char, Int16 ).new
    ruckSack3.not_nil!.each_char do | item |
        if !rsinventory3[ item ]?
            rsinventory3[ item ] = 0
        end
        rsinventory3[ item ] += 1
    end

    rs1Items = Set( Char ).new( rsinventory1.each_key )
    rs2Items = Set( Char ).new( rsinventory2.each_key )
    rs3Items = Set( Char ).new( rsinventory3.each_key )
    badge = ( rs1Items & rs2Items & rs3Items ).to_a[ 0 ]
    priorities += itemPrio( badge )
end
puts priorities
