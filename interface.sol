contract ENSController {
    function ens_set( uint node, address caller, bytes key, bytes32 value, bool is_link ) returns (bool ok);
    function ens_get( uint node, address caller, bytes key ) returns (bytes32 value, bool is_link, bool ok);
}


contract ENSApp {
    function new_node() returns (uint node);

    function get( bytes path ) returns ( bytes32 value, bool ok );
    function set( bytes path, bytes32 value, bool is_link ) returns ( bool ok );

    function node_get( uint node, bytes key ) returns ( bytes32 value, bool is_link, bool ok );
    function node_set( uint node, bytes key, bytes32 value ) returns ( bool ok );
}

