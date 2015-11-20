import 'interface.sol';

contract ENSControllerDBImpl is ENSControllerDB, Debug{
    ENSController[] public controllers;
    function ENSControllerDBImpl() {
        controllers.push(ENSController(0x0));
    }
    // A null value always means error because nodes start at 1
    function claim_node() returns (uint node_id) {
        return controllers.push(ENSController(msg.sender))-1;
    }
    // A null value always means error because 0x0 can't call claim_node()
    function get_controller( uint node ) returns (ENSController controller) {
        if( node >= controllers.length ) {
            return ENSController(address(0x0));
        }
        return controllers[node];
    }
}


