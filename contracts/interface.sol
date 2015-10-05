
contract ENSControllerInterface {
    // TODO temporary
    function last_ok() returns (bool ok);

    function ens_set( address caller, bytes32 key, bytes32 value ) returns (bool ok);
    function ens_get( bytes32 key ) returns (bytes32 value, bool ok);
    function ens_freeze( address caller, bytes32 key ) returns (bool ok);
}


contract ENSInterface {
    // TODO temporary
    function last_ok() returns (bool ok);
    function query( string query_string ) returns ( bytes32 value, bool ok );
    function store( string path_string, bytes32 value ) returns (bool ok);

    function set( address node, bytes32 key, bytes32 value ) returns (bool ok);
    function get( address node, bytes32 key ) returns (bytes32 value, bool ok);
    function freeze( address node, bytes32 key ) returns (bool ok);

    function register() returns (bool);
}
