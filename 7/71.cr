class Node
    def initialize( name : String,
                    parent : ( Node | Nil ) = nil )
        @name = name
        @files = Hash( String, Int32 ).new
        @dirs = Hash( String, Node ).new
        @parent = parent
    end

    def newDir( name : String )
        node = Node.new( "#{@name}/#{name}", self )
        @dirs[ name ] = node
    end

    def newFile( name : String, size : Int32 )
        @files[ "#{@name}/#{name}" ] = size
    end

    def parent
        @parent.not_nil!
    end

    def dirs
        @dirs
    end

    def intoDir( name : String )
        @dirs[ name ]
    end

    def shallowSize
        @files.each_value.sum
    end

    def deepSize : Int32
        self.shallowSize + @dirs.each_value.map { |node| node.deepSize }.sum
    end
end


root = Node.new ""
curr = root

File.open( "input" ).each_line do | line |
    if line == "$ ls"
        next # there isn't actually anything to process here
    elsif line[ 0..3 ] == "$ cd"
        dst = line[ 5.. ]
        if dst == ".."
            curr = curr.parent
        else
            curr = curr.intoDir( dst )
        end
    else # any other possible line structure is just ls output
        if dirMatch = /dir (\w+)/.match( line )
            dirName = dirMatch.not_nil!.captures[ 0 ]
            curr.newDir( dirName.not_nil! )
        end
        if fileMatch = /(\d+) (.+)/.match( line )
            fileSize, fileName = fileMatch.not_nil!.captures
            curr.newFile( fileName.not_nil!, fileSize.not_nil!.to_i )
        end
    end
end

def traverse( root : Node )
    nodes = Array( Node ).new
    queue = Array( Node ).new
    queue << root
    while queue.size != 0
        node = queue.shift
        nodes << node
        node.dirs.each_value { | n | queue << n }
    end

    return nodes
end

nodes = traverse( root )

puts nodes.map { | node | node.deepSize }.select { | size | size <= 100000 }.sum
