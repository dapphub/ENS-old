contract ENSControllerInterface {
    function ens_set( uint node, address caller, bytes key, bytes32 value ) returns (bool ok);
    function ens_get( uint node, address caller, bytes key ) returns (bytes32 value, bool ok);
    function ens_freeze( uint node, address caller, bytes key ) returns (bool ok);
}


contract ENSInterface {
//    function node_id( bytes query_string ) returns (uint id, bool ok);
    function query( bytes query_string ) returns ( bytes32 value, bool ok );
    function freeze( uint node, bytes key ) returns (bool ok);
    function register() returns (uint node);

    function set( uint node, bytes key, bytes32 value ) returns (bool ok);
//    function set_as_controller( uint node, bytes key, uint subnode ) returns (bool ok);

}
