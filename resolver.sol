
contract Resolver {
    // override this
    function is_node( address a ) constant internal returns (bool) {
        return false;
    }
    function resolve(bytes query)
             constant
             returns (bytes32 value) {
        return resolve_relative(_root, query);
    }
    function resolve_relative(ENSNode root, bytes query)
             constant
             returns (bytes32 value)
    {
        var node = root;
        uint position = 0;
        while(true) {
            bytes32 partial = 0x0;
            var i = position;
            var j = 0;
            for( ; i < query.length; i++ ) {
                byte c = query[i];
                if( is_valid_character(c) ) {
                    partial[j] = query[i];
                } else if (is_separator(c)) {
                    var value = node.get(partial);
                    if( _is_node[address(value)] ) {
                        node = ENSNode(value);
                        position = i+1;
                        break;
                    }
                }
                j++;
            }
            return values[partial];
        }
    }
}

