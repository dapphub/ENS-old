import 'interface.sol';


// TODO remove last_ok everywhere !!
contract ENS is ENSInterface
{
    bool _last_ok; //TODO remove
    function last_ok() returns (bool) {
        return _last_ok;
    }
    struct frozen_entry {
        bytes32 value;
        bool is_frozen;
    }
    address public root;
    function ENS( address root_controller )  {
        _traversable[root] = true;
        root = root_controller;
    }

    mapping( address => mapping( bytes32 => frozen_entry ) ) _frozen_entries;
    mapping( address => bool ) _traversable;


    function register() returns (bool) {
        _traversable[msg.sender] = true;
    }
        // mark as traversable

    function query( string query_string ) returns ( bytes32 value, bool ok ) {
        _last_ok = false;
        value = 0x0;
        ok = false;
    }
    function store( string path_string, bytes32 value ) returns (bool ok) {
        _last_ok = false;
        ok = false;
    }
    function set( address node, bytes32 key, bytes32 value ) returns (bool ok) {
        _last_ok = false;
        var entry = _frozen_entries[node][key];
        if( entry.is_frozen ) {
            return entry.value == value; // TODO this could just be "return false" - decide!
        }
        var controller = ENSControllerInterface(node);
        ok = controller.ens_set( msg.sender, key, value );
        _last_ok = ok;
        return ok;
    }
    function get( address node, bytes32 key ) returns (bytes32 value, bool ok) {
        _last_ok = false;
        var entry = _frozen_entries[node][key];
        if( entry.is_frozen ) {
            value = entry.value;
            ok = true;
        } else {
            var controller = ENSControllerInterface(node);
            value = controller.ens_get( key );
            ok = controller.last_ok();
        }
        _last_ok = ok;
    }
    function freeze( address node, bytes32 key ) returns (bool ok) {
        _last_ok = false;
        var controller = ENSControllerInterface(node);
        ok = controller.ens_can_freeze( msg.sender, key );
        if( ok ) {
            var value = controller.ens_get( key );
            var controller_ok = controller.last_ok();
            if( !controller_ok ) {
                _last_ok = false;
                return false;
            }
            var entry = _frozen_entries[node][key];
            entry.is_frozen = true;
            entry.value = value;
        }
        _last_ok = ok;
        return ok;
    }
}
