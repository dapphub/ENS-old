contract ENSInterface {
    struct entry {
        bytes32 value;
        byte flags;
        bool is_frozen;
        bool is_node;
    }
    struct node {
        uint node_id;
        ENSNodeControllerInterface controller;
        mapping( bytes => entry ) frozen_entries;
    }


    function set( uint node_id, bytes key, bytes32 value, byte flags ) returns (bool);

    // @dev If the value is zero, check the flags to ensure it is not an error
    function get( uint node_id, bytes key) returns (bytes32 value);
    function freeze( uint node_id, bytes key ) returns (bool);

/*
    function set( string path, bytes32 value ) returns (bool);
    function get( string path ) returns (bytes32 value, byte flags);
    function freeze( string path ) returns (bool);
*/
}
