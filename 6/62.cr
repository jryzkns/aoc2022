idx = 14
File.open( "input" ).each_char.cons( 14, reuse = true ).each do | window |
    if window.to_set.size == 14
        break
    end
    idx += 1
end
puts idx
