class Monkey
    @buffer : Deque( UInt128 )
    def initialize( buffer : Array( UInt128 ),
                    op : Proc( UInt128, UInt128 ) ,
                    test : Proc( UInt128, UInt128 ) )
        @buffer = Deque.new( buffer )
        @op = op
        @test = test
    end

    def buffer
        @buffer
    end

    def op( x : UInt128 )
        @op.call( x )
    end

    def test( x : UInt128 )
        @test.call( x )
    end
end


monkeys = [
    Monkey.new( [ 72_u128, 97_u128 ] ,
                ->( old : UInt128 ) { old * 13_u128 },
                ->( worry : UInt128 ) { ( worry % 19 == 0 ) ? 5_u128 : 6_u128 } ),
    Monkey.new( [ 55_u128, 70_u128, 90_u128, 74_u128, 95_u128 ] ,
                ->( old : UInt128 ) { old * old },
                ->( worry : UInt128 ) { ( worry % 7 == 0 ) ? 5_u128 : 0_u128 } ),
    Monkey.new( [ 74_u128, 97_u128, 66_u128, 57_u128 ] ,
                ->( old : UInt128 ) { old + 6_u128 },
                ->( worry : UInt128 ) { ( worry % 17 == 0 ) ? 1_u128 : 0_u128 } ),
    Monkey.new( [ 86_u128, 54_u128, 53_u128 ] ,
                ->( old : UInt128 ) { old + 2_u128 },
                ->( worry : UInt128 ) { ( worry % 13 == 0 ) ? 1_u128 : 2_u128 } ),
    Monkey.new( [ 50_u128, 65_u128, 78_u128, 50_u128, 62_u128, 99_u128 ] ,
                ->( old : UInt128 ) { old + 3_u128 },
                ->( worry : UInt128 ) { ( worry % 11 == 0 ) ? 3_u128 : 7_u128 } ),
    Monkey.new( [ 90_u128 ] ,
                ->( old : UInt128 ) { old + 4_u128 },
                ->( worry : UInt128 ) { ( worry % 2 == 0 ) ? 4_u128 : 6_u128 } ),
    Monkey.new( [ 88_u128, 92_u128, 63_u128, 94_u128, 96_u128, 82_u128, 53_u128, 53_u128 ] ,
                ->( old : UInt128 ) { old + 8_u128 },
                ->( worry : UInt128 ) { ( worry % 5 == 0 ) ? 4_u128 : 7_u128 } ),
    Monkey.new( [ 70_u128, 60_u128, 71_u128, 69_u128, 77_u128, 70_u128, 98_u128 ] ,
                ->( old : UInt128 ) { old * 7_u128 },
                ->( worry : UInt128 ) { ( worry % 3 == 0 ) ? 2_u128 : 3_u128 } ),
]

# monkeys = [
#     Monkey.new( [ 79_u128, 98_u128 ] ,
#                 ->( old : UInt128 ) { old * 19_u128 },
#                 ->( worry : UInt128 ) { ( worry % 23 == 0 ) ? 2_u128 : 3_u128 } ),
#     Monkey.new( [ 54_u128, 65_u128, 75_u128, 74_u128 ] ,
#                 ->( old : UInt128 ) { old + 6 },
#                 ->( worry : UInt128 ) { ( worry % 19 == 0 ) ? 2_u128 : 0_u128 } ),
#     Monkey.new( [ 79_u128, 60_u128, 97_u128 ] ,
#                 ->( old : UInt128 ) { old * old },
#                 ->( worry : UInt128 ) { ( worry % 13 == 0 ) ? 1_u128 : 3_u128 } ),
#     Monkey.new( [ 74_u128 ] ,
#                 ->( old : UInt128 ) { old + 3_u128 },
#                 ->( worry : UInt128 ) { ( worry % 17 == 0 ) ? 0_u128 : 1_u128 } ),
# ]

monkeyCounters = Array( Int128 ).new
monkeys.each do | _ |
    monkeyCounters << 0
end

NUM_ROUNDS = 10_000
NUM_ROUNDS.times do
    monkeys.each_with_index do | monkey, idx |
        while !monkey.buffer.empty?
            monkeyCounters[ idx ] += 1
            item = monkey.buffer.shift
            inspected = monkey.op( item )
            dst = monkey.test( inspected )
            monkeys[ dst ].buffer << inspected % ( 19 * 7 * 17 * 13 * 11 * 2 * 5 * 3 )
        end
    end
end

puts monkeyCounters
m1 = monkeyCounters.max
monkeyCounters.delete m1
m2 = monkeyCounters.max

puts m1 * m2
