import 'interface.sol';

contract Resolver {
    bytes partial;
    function is_node( address a ) constant internal returns (bool) {
        return false;
    }
    function resolve_relative(ENSControllerInterface root, bytes query)
             constant
             returns (bytes value)
    {
        ENSControllerInterface node;
        node = root;
        uint position = 0;
        bool ok = false;
        while(true) {
            partial.length = 0;
            var i = position;
            var j = 0;
            for( ; i < query.length; i++ ) {
                byte c = query[i];
                if( is_valid_character(c) ) {
                    partial.push(query[i]);
                } else if (is_separator(c)) {
                    (value, ok) = node.ens_get(partial);
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

