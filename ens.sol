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
        // TODO there is no reason for this to live here.
        // It should go in ExtendedImpl.
        std = new StandardRegistryController( this );
    }

    // new_node is the old name, TODO remove it and fix tests
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
             returns (uint node, bytes32 key, bytes32 value, bool is_link, bool ok)
    {
	uint current_node = 1;
	uint path_position = 0;
	while( true ) {
		bytes32 partial_key = 0x0;	
		uint shift = uint(256)**31;
		bool escaped = false;
		if( is_separator( query[path_position] ) ) {
			path_position++;
		}
		while( path_position < query.length ) {
			byte character = query[path_position];
			path_position++;
			if( is_separator(character) ) {
				break;
			}
			if( is_escape(character) ) {
				path_position++;
				continue;
			}
			partial_key = partial_key | bytes32((uint(character) * shift));
			shift /= 256;
			log_bytes32(partial_key);
		}
		var controller = _controllers[current_node];
		(value, is_link, ok) = controller.ens_get( current_node, msg.sender, partial_key );
		return;
	}
		// parse key
		// get from node
		// if not ok:
		// 	fail
		// if not link:
		//     return node, key, value, false, true
		// else:
		//    node = value
		//    recurse
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
