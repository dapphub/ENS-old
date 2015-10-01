contract ENSAdminController is ENSNodeControllerInterface
{
    address _admin;
    ENSNodeInterface _node;
    function ENSAdminController(ENSNodeInterface node) {
        _admin = msg.sender;
        _node = node;
    }
    function can_set( address caller, bytes32 name, bytes32 value ) returns (bool) {
        return caller == _admin;
    }
    function can_set_controller( address caller, ENSNodeControllerInterface controller ) returns (bool) {
        return caller == _admin;
    }
    function can_transfer( address caller, bytes32 name, address to) returns (bool) {
        return caller == admin;
    }
    function can_toggle_subregistry( address caller, bytes32 name ) returns (bool);
        return caller == admin;
    function can_freeze_name( address caller, bytes32 name ) returns (bool);
        return caller == admin;
    function can_freeze_controller( address caller, bytes32 name ) returns (bool);
        return caller == admin;
    function can_revoke( address caller, bytes32 name ) returns (bool);
        return caller == admin;
}
