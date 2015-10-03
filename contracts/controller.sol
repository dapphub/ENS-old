// 
contract ENSNodeControllerInterface {
    function node() returns (ENSNode node);
    function can_set( address caller, bytes32 name, bytes32 value ) returns (bool);
    function can_set_dir( address caller, bytes32 key, ENSNodeControllerInterface controller ) returns (bool);
    function can_freeze( address caller, bytes32 name ) returns (bool);
}


contract ENSNodeControllerBase is ENSNodeControllerInterface {
    ENSNodeInterface _node;
    function ENSNodeController( ENSNodeInterface node ) {
        _node = node;
    }
    function() returns (bool) {
        return true;
    }
}
