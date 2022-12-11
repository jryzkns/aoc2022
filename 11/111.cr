class Monkey
    @buffer : Deque( Int64 )
    def initialize( buffer : Array( Int64 ),
                    op : Proc( Int64, Int64 ) ,
                    test : Proc( Int64, Int64 ) )
        @buffer = Deque.new( buffer )
        @op = op
        @test = test
    end

    def buffer
        @buffer
    end

    def op( x : Int64 )
        @op.call( x )
    end

    def test( x : Int64 )
        @test.call( x )
    end
end


monkeys = [
    Monkey.new( [ 72_i64, 97_i64 ] ,
                ->( old : Int64 ) { old * 13_i64 },
                ->( worry : Int64 ) { ( worry % 19 == 0 ) ? 5_i64 : 6_i64 } ),
    Monkey.new( [ 55_i64, 70_i64, 90_i64, 74_i64, 95_i64 ] ,
                ->( old : Int64 ) { old * old },
                ->( worry : Int64 ) { ( worry % 7 == 0 ) ? 5_i64 : 0_i64 } ),
    Monkey.new( [ 74_i64, 97_i64, 66_i64, 57_i64 ] ,
                ->( old : Int64 ) { old + 6_i64 },
                ->( worry : Int64 ) { ( worry % 17 == 0 ) ? 1_i64 : 0_i64 } ),
    Monkey.new( [ 86_i64, 54_i64, 53_i64 ] ,
                ->( old : Int64 ) { old + 2_i64 },
                ->( worry : Int64 ) { ( worry % 13 == 0 ) ? 1_i64 : 2_i64 } ),
    Monkey.new( [ 50_i64, 65_i64, 78_i64, 50_i64, 62_i64, 99_i64 ] ,
                ->( old : Int64 ) { old + 3_i64 },
                ->( worry : Int64 ) { ( worry % 11 == 0 ) ? 3_i64 : 7_i64 } ),
    Monkey.new( [ 90_i64 ] ,
                ->( old : Int64 ) { old + 4_i64 },
                ->( worry : Int64 ) { ( worry % 2 == 0 ) ? 4_i64 : 6_i64 } ),
    Monkey.new( [ 88_i64, 92_i64, 63_i64, 94_i64, 96_i64, 82_i64, 53_i64, 53_i64 ] ,
                ->( old : Int64 ) { old + 8_i64 },
                ->( worry : Int64 ) { ( worry % 5 == 0 ) ? 4_i64 : 7_i64 } ),
    Monkey.new( [ 70_i64, 60_i64, 71_i64, 69_i64, 77_i64, 70_i64, 98_i64 ] ,
                ->( old : Int64 ) { old * 7_i64 },
                ->( worry : Int64 ) { ( worry % 3 == 0 ) ? 2_i64 : 3_i64 } ),
]

# monkeys = [
#     Monkey.new( [ 79_i64, 98_i64 ] ,
#                 ->( old : Int64 ) { old * 19_i64 },
#                 ->( worry : Int64 ) { ( worry % 23 == 0 ) ? 2_i64 : 3_i64 } ),
#     Monkey.new( [ 54_i64, 65_i64, 75_i64, 74_i64 ] ,
#                 ->( old : Int64 ) { old + 6 },
#                 ->( worry : Int64 ) { ( worry % 19 == 0 ) ? 2_i64 : 0_i64 } ),
#     Monkey.new( [ 79_i64, 60_i64, 97_i64 ] ,
#                 ->( old : Int64 ) { old * old },
#                 ->( worry : Int64 ) { ( worry % 13 == 0 ) ? 1_i64 : 3_i64 } ),
#     Monkey.new( [ 74_i64 ] ,
#                 ->( old : Int64 ) { old + 3_i64 },
#                 ->( worry : Int64 ) { ( worry % 17 == 0 ) ? 0_i64 : 1_i64 } ),
# ]

monkeyCounters = Array( Int32 ).new
monkeys.each do | _ |
    monkeyCounters << 0
end

NUM_ROUNDS = 20
NUM_ROUNDS.times do
    monkeys.each_with_index do | monkey, idx |
        while !monkey.buffer.empty?
            monkeyCounters[ idx ] += 1
            item = monkey.buffer.shift
            inspected = monkey.op( item ) // 3
            dst = monkey.test( inspected )
            monkeys[ dst ].buffer << inspected
        end
    end
end

puts monkeyCounters
m1 = monkeyCounters.max
monkeyCounters.delete m1
m2 = monkeyCounters.max

puts m1 * m2
