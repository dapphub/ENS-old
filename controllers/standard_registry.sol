// Controller for first-come first-serve registries with normal transfer rules.
// A good example of how to use one controller for many namespaces.
import 'interface.sol';
import 'user.sol';

contract StandardRegistryController is ENSController
                                     , ENSUser
{
    function StandardRegistryController( ENS ens ) {
        init_usermock( ens );
    }
    struct RegistryEntry {
        bytes32 value;
	bool    link;
        address owner;
        bool    claimed;
    }
    mapping( uint => mapping( bytes32 => RegistryEntry ) ) entries;

    function new_registry() returns ( uint node ) {
        return ens.new_node();
    }
    function set( uint node, bytes32 key, bytes32 value ) returns (bool) {
	var entry = entries[node][key];
	if( entry.owner == msg.sender || !entry.claimed) {
		entry.value = value;
		entries[node][key] = entry;
		return true;
	}
	return false;
    }
    function get( uint node, bytes32 key ) returns (bytes32 value, bool ok) {
	var entry = entries[node][key];
	if( entry.claimed ) {
		return (entry.value, true);
	} else {
		return (0x0, false);
	}
    }
    function transfer( uint node, bytes32 key, address new_owner ) returns (bool success) {
        var entry = entries[node][key];
	if( entry.owner == msg.sender ) {
		entry.owner = new_owner;
		entries[node][key] = entry;
		return true;
	}
	return false;
    }
    function ens_set( uint node, address caller, bytes32 key, bytes32 value, bool is_link )
             returns (bool ok)
    {
	var entry = entries[node][key];
	var sender = msg.sender;
	if (msg.sender == address(ens)) {
		sender = caller;
	}
	if( sender == entry.owner || !entry.claimed ) {
		entry.claimed = true;
		entry.value = value;
		entry.link = is_link;
		entry.owner = sender;
		return true;
	}
	return false;
    }
    function ens_get( uint node, address caller, bytes32 key )
             returns (bytes32 value, bool is_link, bool ok)
    {
	var entry = entries[node][key];
	return (entry.value, entry.link, true);
    }
}
