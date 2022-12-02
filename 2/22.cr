TOURNAMENT_MULTIPLIER = 3
R = 1
P = 2
S = 3
PWIN = 2
PDRAW = 1
PLOSE = 0

symbolVal = {
    "X" => PLOSE,
    "Y" => PDRAW,
    "Z" => PWIN,
    "A" => R,
    "B" => P,
    "C" => S,
}

rpsDecide = {
    R => { R => PDRAW, P =>  PWIN, S => PLOSE },
    P => { R => PLOSE, P => PDRAW, S =>  PWIN },
    S => { R =>  PWIN, P => PLOSE, S => PDRAW },
}

ttlScore = 0
File.open( "input" ).each_line do | line |
    elfChoice, outcome = line.split().map { | choice | symbolVal[ choice ] }
    playerChoice = rpsDecide[ elfChoice ].invert[ outcome ]
    ttlScore += playerChoice
    ttlScore += TOURNAMENT_MULTIPLIER * outcome
end

puts ttlScore
