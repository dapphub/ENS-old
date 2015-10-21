contract ENSControllerInterface {
    function ens_set( uint node, address caller, bytes key, bytes32 value ) returns (bool ok);
    function ens_get( uint node, address caller, bytes key ) returns (bytes32 value, bool ok);
    function ens_freeze( uint node, address caller, bytes key ) returns (bool ok);
}


contract ENSInterface {
    function new_node() returns (uint node);
    function transfer_node( uint node, ENSControllerInterface new_controller) returns (bool ok);
    function path_info( bytes path) returns (uint node_id, bytes last_key, bool ok);

    function get( bytes path ) returns ( bytes32 value, bool ok );
    function set( bytes path, bytes32 value ) returns ( bool ok );
    function freeze( bytes path ) returns (bool ok);

    function node_get( uint node, bytes key ) returns ( bytes32 value, bool ok );
    function node_set( uint node, bytes key, bytes32 value ) returns ( bool ok );
    function node_freeze( uint node, bytes key ) returns (bool ok);

}
