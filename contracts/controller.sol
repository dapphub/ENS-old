// 
contract ENSNodeControllerInterface {
    function node() returns (ENSNode node);
    function can_set( address caller, bytes32 name, bytes32 value ) returns (bool);
    function can_set_controller( address caller, ENSNodeControllerInterface controller ) returns (bool);
    function can_transfer( address caller, bytes32 name, address to) returns (bool);
    function can_freeze_name( address caller, bytes32 name ) returns (bool);
    function can_freeze_controller( address caller, bytes32 name ) returns (bool);
    function can_revoke( address caller, bytes32 name ) returns (bool);
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
