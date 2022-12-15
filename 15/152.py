import re
from multiprocessing import get_context

def manhattanDistance( sx, sy, bx, by ):
    return abs( sx - bx ) + abs( sy - by )

def diamondSliceItr( x, y, d, vd ):
    start = ( x - ( d - abs( vd ) ), y + vd )
    for i in range( 2 * ( d - vd ) + 1 ):
        yield start[ 0 ] + i, start[ 1 ]

def check_row( rowNum ):
    known = set()
    for sx, sy, bx, by in params:
        if by == rowNum: known.add( bx )
        if sy == rowNum: known.add( sx )
        dist = manhattanDistance( sx, sy, bx, by )
        regionBottom = sy - dist
        regionTop = sy + dist
        if not ( regionBottom <= rowNum <= regionTop ):
            continue
        for x, _ in diamondSliceItr( sx, sy, dist, rowNum - sy ):
            if 0 <= x <= 4_000_000:
                known.add( x )

    if len( known ) != 4_000_001:
        print(f"had {len( known )} items...searching..")
        for i in range( 4_000_000 ):
            if i not in known:
                print(f"found {i} so answer is { i * 4_000_000 + rowNum }!")
                return i
    return None

params = []
with open( "input" ) as f__:
    for line in f__.read().split( '\n' ):
        params += [ int( v) for v in re.findall( r'-?\d+', line ) ],

params = params[ :-1 ]

if __name__ == "__main__":
    N_WORKERS = 20
    with get_context( "spawn" ).Pool( N_WORKERS ) as workerPool:
        workerPool.daemon = True
        for result in workerPool.map( check_row, range( 4_000_000 + 1 ) ):
            if result:
                print( result )
                break
