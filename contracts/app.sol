contract ENSAppInterface {
    function set( address node, bytes32 key, bytes32 value );
    function set_dir( address node, bytes32 key, ENSNode subnode );
    // promote??

    function new_node() returns (address);
    function transfer( address node, bytes32 key, address new_owner );
    function set_controller( address node, ENSNodeControllerInterface controller );

    // Resolver
    function get( address node, bytes32 key) constant returns (bytes32 value);
    function resolve(bytes query) constant returns (bytes32 value);
    function resolve_relative(address root, bytes query) constant returns (bytes32 value);

    function freeze_name( address node, bytes32 name );
    function freeze_controller( address node );
    function is_fixed(bytes query) constant returns (bool);
}

contract ENSApp is ENSAppInterface
{
    struct entry {
        bool registered;
        bool is_node;
        address owner;
        ENSNodeControllerInterface controller;
        bool frozen;
    }

    mapping( address => bool ) _known_node; // can_be_node
    bool[2**128] public               _is_node; // quick lookup for resolvers
    address                           _root;

    mapping( address => mapping( bytes32 => entry ) ) entries;

    function ENSApp() {
        _root = new_node();
    }
    function new_node() returns (address) {
        var node = address(0x0);
        _known_node[node] = true;
        _is_node[node] = true;
        return node;
    }
    function is_node(address node) constant returns (bool) {
        return _is_node[node];
    }
    event name_set( address indexed node, bytes32 name );
    function notify(bytes32 name)
    {
        if( _is_node[msg.sender] )
        {
            name_set( msg.sender, name );
        }
    }
}
