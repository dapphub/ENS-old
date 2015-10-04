import 'dapple/core/test.sol';
import 'ens.sol';

contract ENSTest is Test {
    ENS ens;
    ENS_Controller_CuratedNamereg c;
    function setUp() {
        c = new ENS_Controller_CuratedNamereg();
        ens = new ENS( ENSNodeControllerInterface( c ) );
        c.ens_controller_init(0);
        c.init_usermock(ens);
        ens.set(0, "key", "value");
    }
    function testRootNodeConfigured() {
        assertEq( c, address(ens.get_controller(0)), "wrong root controller");
        assertEq( me, c.owner(), "wrong root controller owner" );
    }
    function testCuratedNameRegController() {
        assertEq32("value", c.ens_get("key"), "controller gets wrong key");
        assertEq32("value", ens.get(0, "key"), "app gets wrong key");

        assertTrue( ens.set(0, "key", "value2") );
        assertEq32( "value2", ens.get(0, "key"), "wrong value after set" );
        assertTrue( ens.freeze( 0, "key" ) );
        assertFalse( ens.set(0, "key", "other_value" ) );
        assertEq32( "value2", ens.get(0, "key"), "wrong value after set attempt" );
    }
    function testResolve() {
        bytes32 ret = ens.get( "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf" );
        log_bytes32(ret);
    }
    function testCuratedNameregGet()
             logs_gas()
    {
        ens.get(0, "key");
    }
    function testCuratedNameregSet()
             logs_gas()
    {
        ens.set(0, "key", "value");
    }
}
