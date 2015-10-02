contract ENSAppInterface {
    function set( ENSNode node, bytes32 key, bytes32 value );
    function set_dir( ENSNode node, bytes32 key, ENSNode subnode );

    function new_node() returns (ENSNode);
    function transfer( ENSNode node, bytes32 key, address new_owner );
    function set_controller( ENSNode node, ENSNodeControllerInterface controller );

    // Resolver
    function get( ENSNode node, bytes32 key) constant returns (bytes32 value);
    function resolve(bytes query) constant returns (bytes32 value);
    function resolve_relative(ENSNode root, bytes query) constant returns (bytes32 value);

    function freeze_name( ENSNode node, bytes32 name );
    function freeze_controller( ENSNode node );
    function is_fixed(bytes query) constant returns (bool);
}

contract ENSApp is ENSAppInterface
                 , Resolver
{
    struct entry {
        bool registered;
        bool is_node;
        address owner;
        ENSNodeControllerInterface controller;
        bool frozen;
    }


    bool[2**128] public               _is_node; // quick lookup for resolvers
    ENSNode                           _root;

    mapping( ENSNode => mapping( bytes32 => entry ) ) entries;
    node_config public config;

    function ENSApp() {
        _root = new_node();
    }
    function new_node() returns (ENSNode) {
        var node = new ENSNode();
        _known_node[node] = true;
        _is_node[node] = true;
        return node;
    }
    function is_node(address node) constant returns (bool) {
        return _is_node[node];
    }
    event name_set( ENSNode indexed node, bytes32 name );
    function notify(bytes32 name)
    {
        if( _is_node[msg.sender] )
        {
            name_set( msg.sender, name );
        }
    }
}
