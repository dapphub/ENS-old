import 'interface.sol';
import 'core/debug.sol';
//import 'resolver.sol';

contract ENS is ENSInterface
/*              , Resolver */
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
    function resolve(bytes query)
             constant
             returns (bytes value) {
        return resolve_relative(root, query);
    }
*/


    function register() returns (uint) {
        var ret = next_id;
        _controllers[next_id] = ENSControllerInterface(msg.sender);
        next_id++;
        return ret;
    }

    function query( bytes query_string ) returns ( bytes32 value, bool ok ) {
        return (bytes32(0x0), false);
    }

    function set( uint node, bytes key, bytes32 value ) returns (bool ok) {
        var entry = _frozen_entries[node][key];
        if( entry.is_frozen ) {
            return false;
        }
        var controller = _controllers[node];
        ok = controller.ens_set( node, msg.sender, key, value );
        return ok;
    }
    function get( uint node, bytes key ) returns (bytes32 value, bool ok) {
        var entry = _frozen_entries[node][key];
        if( entry.is_frozen ) {
            return (entry.value, true);
        } else {
            var controller = _controllers[node];
            (value, ok) = controller.ens_get( node, msg.sender, key );
            return (value, ok);
        }
    }
    function freeze( uint node, bytes key ) returns (bool ok) {
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
}
