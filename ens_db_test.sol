import 'dapple/test.sol';
import 'ens_db.sol';

contract ENSControllerDBTest is Test {
    ENSControllerDBImpl target;
    function setUp() {
        target = new ENSControllerDBImpl();
    }
    function testEverything() {
        assertEq( 1, target.claim_node() );
        assertEq( 2, target.claim_node() );
        assertEq( 3, target.claim_node() );
        assertEq( address(this), target.get_controller(3) );
        assertEq( address(0x0), target.get_controller(4) );
        assertEq( address(0x0), target.get_controller(0) );
    }
}
