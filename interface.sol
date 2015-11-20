contract ENSControllerDB {
    function claim_node() returns ( uint node );
    function get_controller( uint node ) returns ( ENSController controller );
}

contract ENSController {
    function ens_set( uint node, address caller, bytes32 key, bytes32 value, bool is_link ) returns (bool ok);
    function ens_get( uint node, address caller, bytes32 key ) returns (bytes32 value, bool is_link, bool ok);
}

contract ENSApp is ENSControllerDB {
    function get( bytes path ) returns ( bytes32 value, bool is_link, bool ok );
    function set( bytes path, bytes32 value, bool is_link ) returns ( bool ok );

    function node_get( uint node, bytes32 key ) returns ( bytes32 value, bool is_link, bool ok );
    function node_set( uint node, bytes32 key, bytes32 value ) returns ( bool ok );
}
