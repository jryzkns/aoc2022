TOURNAMENT_MULTIPLIER = 3
R = 1
P = 2
S = 3
symbolVal = {
    "X" => R,
    "Y" => P,
    "Z" => S,
    "A" => R,
    "B" => P,
    "C" => S,
}

PWIN = 2
PDRAW = 1
PLOSE = 0

rpsDecide = [ -1, -1, -1, -1,
    PDRAW, PLOSE,  PWIN,
     PWIN, PDRAW, PLOSE,
    PLOSE,  PWIN, PDRAW,
]

ttlScore = 0
File.open( "input" ).each_line do | line |
    elfChoice, playerChoice = line.split().map { | choice | symbolVal[ choice ] }
    ttlScore += playerChoice
    ttlScore += TOURNAMENT_MULTIPLIER * rpsDecide[ 3 * playerChoice + elfChoice ]
end

puts ttlScore
