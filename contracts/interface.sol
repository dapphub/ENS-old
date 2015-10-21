contract ENSControllerInterface {
    function ens_set( uint node, address caller, bytes32 key, bytes32 value ) returns (bool ok);
    function ens_get( uint node, address caller, bytes32 key ) returns (bytes32 value, bool ok);
    function ens_freeze( uint node, address caller, bytes32 key ) returns (bool ok);
}


contract ENSInterface {
    function new_node() returns (uint node);
    function transfer_node( uint node, ENSControllerInterface new_controller) returns (bool ok);
    function path_info( bytes32 path) returns (uint node_id, bytes32 last_key, bool ok);

    function get( bytes32 path ) returns ( bytes32 value, bool ok );
    function set( bytes32 path, bytes32 value ) returns ( bool ok );
    function freeze( bytes32 path ) returns (bool ok);

    function node_get( uint node, bytes32 key ) returns ( bytes32 value, bool ok );
    function node_set( uint node, bytes32 key, bytes32 value ) returns ( bool ok );
    function node_freeze( uint node, bytes32 key ) returns (bool ok);

}
