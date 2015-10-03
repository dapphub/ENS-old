// ENS single-contract implementation
import 'ens/controller.sol';

contract ENSAppSingle {
    struct entry {
        bytes32 value;
        bool is_dir;
        bool frozen;
    }
    struct ens_node {
        bool initialized;
        ENSNodeControllerInterface controller;
    }
    mapping( address => mapping( bytes32 => entry ) ) _entries;
    mapping( address => ens_node ) _nodes;

    function new_node() returns (address) {
        address node = address(0x0);
        _nodes[node].initialized = true;
        return node;
    }

    function set_dir( address node, bytes32 key, address controller ) returns (bool) {
        var entry = _entries[node][key];
        if( !entry.frozen && _node[node].initialized ) {
            var node_controller = _nodes[node].controller;
            if( node_controller.can_set_dir( msg.sender, key, bytes32(controller) ) ) {
                entry.value = bytes32(controller);
                entry.is_dir = true;
                _entries[node][key] = entry;
                return true;
            }
        }
        return false;
    }
    function set(address node, bytes32 key, bytes32 value) returns (bool) {
        var entry = _entries[node][key];
        if( !entry.frozen ) {
            var node_controller = _nodes[node].controller;
            if( node_controller.can_set( msg.sender, key, value ) ) {
                entry.value = value;
                entry.is_dir = false;
                _entries[node][key] = entry;
                // write_out
                return true;
            }
        }
        return false;
    }
    function freeze(address node, bytes32 key, bytes32 value) returns (bool) {
        var node_controller = _nodes[node].controller;
        if( node_controller.can_freeze( msg.sender, key, value ) ) {
            var entry = _entries[node][key];
            entry.frozen = true;
            _entries[node][key] = entry;
            return true;
        }
        return false;
    }
    function get(address node, bytes32 key) constant returns (bytes32 value) {
        return _entries[node][key];
    }
}
