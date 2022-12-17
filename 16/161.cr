module Global
    class_property maxPressure : Int32 = 0
end

alias Valve = String
class ValveInfo
    getter flow : Int32
    getter destinations : Array( Valve )
    getter timeRemaining : Int32
    setter timeRemaining : Int32
    def initialize( @flow : Int32,
                    @destinations : Array( Valve ),
                    @timeRemaining : Int32 = 0 )
    end

  def clone
    self.class.new( @flow.clone,
                    @destinations.clone,
                    @timeRemaining.clone )
  end
end
alias Cave = Hash( Valve, ValveInfo )
cave = Cave.new
File.open( "input" ).each_line do | line |
    match = /Valve (\w\w) has flow rate=(\d+); tunnels? leads? to valves? (.+)/.match( line )
    if !match
        puts " rejected: #{line}"
        next
    end

    valveName, flow, destinations = match.not_nil!.captures
    cave[ valveName.not_nil! ] = ValveInfo.new( flow.not_nil!.to_i,
                                                destinations.not_nil!.split( ", " ) )
end

def gotoValve( valve : Valve,
               remainingTime : Int32,
               caveState : Cave )
    if remainingTime <= 0
        ttlPressure = 0
        caveState.each_value do | valveInfo |
            ttlPressure += valveInfo.flow * valveInfo.timeRemaining
        end
        premax = Global.maxPressure
        Global.maxPressure = Math.max( ttlPressure, Global.maxPressure )
        if premax != Global.maxPressure
            puts "new max: #{Global.maxPressure}"
        end
        return
    end

    # we can only open a valve if
    # - the valve has a nonzero flow
    # - the valve isn't already opened
    valveActions = [ false ]
    if caveState[ valve ].flow != 0 && caveState[ valve ].timeRemaining == 0
        valveActions << true
    end

    # we enumerate all possible actions by crossing whether if we want to open the
    # current valve or not, and each of the possible destinations to go
    valveActions.each do | valveAction |
        caveState[ valve ].destinations.each do | destination |
            newCaveState = caveState.clone
            newRemainingTime = remainingTime
            if valveAction
                newRemainingTime -= 1
                if newRemainingTime > 0
                    newCaveState[ valve ].timeRemaining = newRemainingTime
                end
            end
            gotoValve( destination,
                       newRemainingTime - 1,
                       newCaveState )
        end
    end
end

remainingTime = 30
gotoValve( "AA", remainingTime, cave )

puts Global.maxPressure
