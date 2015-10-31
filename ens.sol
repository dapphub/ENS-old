import 'interface.sol';
import 'dapple/debug.sol';
import 'controllers/standard_registry.sol';


contract ENS is ENSApp
              , Debug
{
    uint next_id;
    ENSController public root;
    mapping( uint => ENSController ) _controllers;

    StandardRegistryController public std;

    function ENS( ENSController root_controller )  {
        next_id = 1;
        root = root_controller;
        std = new StandardRegistryController( this );
    }

    function new_node() returns (uint) { return claim_node(); }
    function claim_node() returns (uint) {
        var ret = next_id;
        _controllers[next_id] = ENSController(msg.sender);
        next_id++;
        return ret;
    }
    function get_controller( uint node ) returns (ENSController controller, bool ok) {
        return (_controllers[node], true);
    }
    function get( bytes path ) returns ( bytes32 value, bool is_link, bool ok ) {
        (, , value, is_link, ok) = resolve_path( path );
        if( ok ) {
            return (value, is_link, ok);
        } else {
            return (0x0, false, false);
        }
    }
    function set( bytes path, bytes32 value, bool is_link ) returns ( bool ok ) {
        var (node, key, , , path_ok) = resolve_path( path );
        if( path_ok ) {
            var controller = _controllers[node];
            return controller.ens_set( node, msg.sender, key, value, is_link );
        } else {
            return false;
        }
    }

    function node_get( uint node, bytes32 key ) returns (bytes32 value, bool is_link, bool ok) {
        var controller = _controllers[node];
        return controller.ens_get( node, msg.sender, key );
    }
    function node_set( uint node, bytes32 key, bytes32 value ) returns (bool ok) {
        var controller = _controllers[node];
        return controller.ens_set( node, msg.sender, key, value, false );
    }


    function resolve_path( bytes query ) 
             constant
             internal
             returns (uint ret_node, bytes32 key, bytes32 value, bool is_link, bool ok)
    {
        return (1, 0x0, 0x0, false, false);
/*
        uint node = 1; // root node ID
        uint offset = 0;
        uint i;
        bool is_link;
        while(true) {
            bytes32 partial;
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
                    if( is_link ) {
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
*/
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
