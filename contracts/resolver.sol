import 'interface.sol';

contract Resolver {
    // override this
    function is_node( address a ) constant internal returns (bool) {
        return false;
    }
    function resolve_relative(ENSControllerInterface root, bytes query)
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
                    value = node.get(partial);
                    if( is_node(address(value)) ) {
                        node = ENSControllerInterface(value);
                        position = i+1;
                        break;
                    }
                }
                j++;
            }
            return 0x0;
        }
    }
    function is_valid_character(byte c) internal returns (bool) {
        return true;
    }
    function is_separator(byte c) internal returns (bool) {
        return true;
    }


}

