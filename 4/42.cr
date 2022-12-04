counts = 0
File.open( "input" ).each_line do | line |
    interval1, interval2 = line.split( "," )
    interval1start, interval1end = interval1.split( "-" ).map{ | num | num.to_i }
    interval1size =  interval1end - interval1start + 1
    interval2start, interval2end = interval2.split( "-" ).map{ | num | num.to_i }
    interval2size =  interval2end - interval2start + 1

    if interval2start <= interval1start <= interval1end <= interval2end
        counts += 1
        next
    end

    if interval1start <= interval2start <= interval2end <= interval1end
        counts += 1
        next
    end

    if interval2start <= interval1start <= interval2end
        counts += 1
        next
    end

    if interval2start <= interval1end <= interval2end
        counts += 1
        next
    end

end

puts counts
