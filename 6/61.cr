idx = 4
File.open( "input" ).each_char.cons( 4, reuse = true ).each do | window |
    if window.to_set.size == 4
        break
    end
    idx += 1
end
puts idx
