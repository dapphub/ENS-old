import 'interface.sol';
import 'core/debug.sol';

contract ENS is ENSInterface
                , Debug
{
    struct frozen_entry {
        bytes32 value;
        bool is_frozen;
    }

    uint next_id;
    ENSControllerInterface public root;
    mapping( uint => mapping( bytes => frozen_entry ) ) _frozen_entries;
    mapping( uint => ENSControllerInterface ) _controllers;


    function ENS( ENSControllerInterface root_controller )  {
        next_id = 1;
        root = root_controller;
    }


/*
    function resolve(bytes32 query)
             constant
             returns (bytes32 value) {
        return resolve_relative(root, query);
    }
*/


    function new_node() returns (uint) {
        var ret = next_id;
        _controllers[next_id] = ENSControllerInterface(msg.sender);
        next_id++;
        return ret;
    }
    function path_info( bytes path ) returns (uint node_id, bytes last_key, bool ok) {
        bytes memory ret;
        return (0, ret, false);
    }
    function transfer_node( uint node, ENSControllerInterface new_controller) returns (bool ok) {
        if( msg.sender == address(_controllers[node]) ) {
            _controllers[node] = new_controller;
        }
        return false;
    }

    function get( bytes path ) returns ( bytes32 value, bool ok ) {
        return (bytes32(0x0), false);
    }
    function set( bytes path, bytes32 value ) returns ( bool ok ) {
        return false;
    }
    function freeze(bytes path) returns (bool ok) {
        return false;
    }

    function node_get( uint node, bytes key ) returns (bytes32 value, bool ok) {
        var entry = _frozen_entries[node][key];
        if( entry.is_frozen ) {
            return (entry.value, true);
        } else {
            var controller = _controllers[node];
            (value, ok) = controller.ens_get( node, msg.sender, key );
            return (value, ok);
        }
    }
    function node_set( uint node, bytes key, bytes32 value ) returns (bool ok) {
        var entry = _frozen_entries[node][key];
        if( entry.is_frozen ) {
            return false;
        }
        var controller = _controllers[node];
        ok = controller.ens_set( node, msg.sender, key, value );
        return ok;
    }
    function node_freeze( uint node, bytes key ) returns (bool ok) {
        var controller = _controllers[node];
        ok = controller.ens_freeze( node, msg.sender, key );
        if( ok ) {
            bytes32 value;
            (value, ok) = controller.ens_get( node, msg.sender, key );
            if( !ok ) {
                return false;
            }
            var entry = _frozen_entries[node][key];
            entry.is_frozen = true;
            entry.value = value;
            return true;
        } else {
            return false;
        }
    }








    // resolver implementation
    bytes partial;
    function is_node( bytes32 value ) constant internal returns (bool, uint id) {
        return (false, 0);
    }
    function resolve_relative(ENSControllerInterface root, bytes query)
             constant
             returns (bytes value)
    {
        uint node = 1; // root node ID
        uint offset = 0;
        bool ok = false;
        uint i;
        while(true) {
            partial.length = 0;
            for( i = 0; i < query.length; i++ ) {
                byte c = query[offset + i];
                if( is_separator(c) ) {
                    if( i == 0 ) {
                        continue;
                    }
                    (value, ok) = node.ens_get(node, msg.sender, partial);
                    if( is_node(address(value)) ) {
                        node = ENSControllerInterface(value);
                        offset = offset+i+1;
                        break;
                    }
                } else {
                    partial.push(query[offset + i]);
                }
            }
            return 0x0;
        }
    }
    function is_separator(byte c) internal returns (bool) {
        return c == byte("/");
    }
    function is_escape(byte c) internal returns (bool) {
        return c == byte("\\");
    }



}
