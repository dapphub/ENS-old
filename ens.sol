import 'interface.sol';
import 'core/debug.sol';


contract ENS is ENSApp
              , Debug
{
    struct frozen_entry {
        bytes32 value;
        bool is_frozen;
    }

    uint next_id;
    ENSController public root;
    mapping( uint => mapping( bytes => frozen_entry ) ) _frozen_entries;
    mapping( uint => ENSController ) _controllers;

    function ENS( ENSController root_controller )  {
        next_id = 1;
        root = root_controller;
    }


    function new_node() returns (uint) {
        var ret = next_id;
        _controllers[next_id] = ENSController(msg.sender);
        next_id++;
        return ret;
    }
    function get( bytes path ) returns ( bytes32 value, bool ok ) {
        return resolve_relative( root, path );
    }
    function set( bytes path, bytes32 value, bool is_link ) returns ( bool ok ) {
        return false;
    }

    function node_get( uint node, bytes key ) returns (bytes32 value, bool is_link, bool ok) {
        var entry = _frozen_entries[node][key];
        if( entry.is_frozen ) {
            return (entry.value, false, true);
        } else {
            var controller = _controllers[node];
            (value, is_link, ok) = controller.ens_get( node, msg.sender, key );
            return (value, is_link, ok);
        }
    }
    function node_set( uint node, bytes key, bytes32 value ) returns (bool ok) {
        var entry = _frozen_entries[node][key];
        if( entry.is_frozen ) {
            return false;
        }
        var controller = _controllers[node];
        ok = controller.ens_set( node, msg.sender, key, value, false );
        return ok;
    }


    // resolver implementation
    bytes partial;
    function get_node( bytes32 value ) constant internal returns (uint id, bool is_node) {
        return (0, false);
    }
    function resolve_relative(ENSController root, bytes query)
             constant
             returns (bytes32 value, bool ok)
    {
        uint node = 1; // root node ID
        uint offset = 0;
        uint i;
        bool is_link;
        while(true) {
            partial.length = 0;
            for( i = 0; offset+i < query.length; i++ ) {
                bool is_node = false;
                byte c = query[offset + i];
                if( is_separator(c) ) {
                    if( i == 0 ) {
                        continue;
                    }
                    var controller = _controllers[node];
                    (value, is_link, ok) = controller.ens_get(node, msg.sender, partial);
                    if( !ok ) {
                        return (0x0, false);
                    }
                    (node, is_node) = get_node(value);
                    if( is_node ) {
                        offset = offset+i+1;
                        break;
                    } else {
                        return (value, true);
                    }
                } else {
                    partial.push(query[offset + i]);
                }
            }
            if( i == query.length-1 ) {
                return (value, true);
            }
        }
    }
    function is_separator(byte c) internal returns (bool) {
        return c == byte("/");
    }
    function is_escape(byte c) internal returns (bool) {
        return c == byte("\\");
    }



}

contract ENSExtendedImpl is ENS {
    function path_info( bytes path ) returns (uint node_id, bytes last_key, bool ok) {
        bytes memory ret;
        return (0, ret, false);
    }
    function transfer_node( uint node, ENSController new_controller) returns (bool ok) {
        if( msg.sender == address(_controllers[node]) ) {
            _controllers[node] = new_controller;
        }
        return false;
    }

}
