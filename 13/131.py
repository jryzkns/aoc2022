import itertools

pair, pairs = [], []
with open( 'input', 'r' ) as f__:
    for line in f__.read().split( '\n' ):
        if line != '':
            pair += eval( line ),
        else:
            pairs += pair,
            pair = []

def cmpPackets( l, r, prefix=4 ):
    # convenience fn to indent recursive prints
    pprint = lambda s : print( prefix * ' ' + s )
    pprint( f'INPUT: {l} vs {r}' )
    match = True
    for lv, rv in itertools.zip_longest( l, r ):
        pprint( f'VALS: {lv} vs {rv}' )
        if lv is None or rv is None:
            match = lv is None
            break
        if isinstance( lv, int ) and isinstance( rv, int ):
            if lv != rv:
                match = lv < rv
                break
            continue
        if isinstance( lv, int ) and isinstance( rv, list ):
            lv = [ lv ]
        if isinstance( lv, list ) and isinstance( rv, int ):
            rv = [ rv ]
        match = cmpPackets( lv, rv, prefix = prefix + 4 )
        if not match:
            break
    pprint( f'MATCH: {match}' )
    return match

ttl = 0
for idx, ( left, right ) in enumerate( pairs, 1 ):
    print( f'PAIR {idx}' )
    if cmpPackets( left, right ):
        ttl += idx
print( ttl )
