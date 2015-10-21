// Controller for first-come first-serve registries with normal transfer rules.
// A good example of how to use one controller for many namespaces.
import 'interface.sol';
import 'user.sol';

contract StandardRegistryController is ENSControllerInterface
                                     , ENSUser
{
    function StandardRegistryController( ENS ens ) {
        init_usermock( ens );
    }
    struct RegistryEntry {
        bytes32 value;
        address owner;
        bool    claimed;
    }
    mapping( uint => mapping( bytes32 => RegistryEntry ) ) public entries;


    function _set( uint node, address caller, bytes32 key
                 , bytes32 new_value, address new_owner, bool new_claimed )
             internal
             returns (bool ok)
    {
        var entry = entries[node][key];
        if( entry.claimed && entry.owner != caller) {
            return false;
        }
        entry.claimed = new_claimed;
        entry.value = new_value;
        entry.owner = new_owner;
        return true;
    }
    function _get( uint node, bytes32 key )
             internal
             returns (bytes32 value, bool ok )
    {
        return (entries[node][key].value, true);
    }
    function _freeze( uint node, address caller, bytes32 key )
             internal
             returns (bool ok)
    {
    }

    function new_registry() returns ( uint node ) {
        return ens.new_node();
    }
    function set( uint node, bytes32 key, bytes32 value ) {
        _set( node, msg.sender, key, value, msg.sender, true );
    }
    function transfer( uint node, bytes32 key, address new_owner ) {
        var entry = entries[node][key];
        _set( node, msg.sender, key, entry.value, new_owner, true );
    }
    function unregister( uint node, bytes32 key ) {
        _set( node, msg.sender, key, bytes32(0), address(0), false );
    }
    function ens_set( uint node, address caller, bytes32 key, bytes32 value )
             ens_only()
             returns (bool ok)
    {
        _set(node, caller, key, value, caller, true );
    }
    function ens_get( uint node, address caller, bytes32 key )
             returns (bytes32 value, bool ok)
    {
        return _get( node, key );
    }
    function ens_freeze( uint node, address caller, bytes32 key )
             returns (bool ok)
    {
        return false;
    }

}
