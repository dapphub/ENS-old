import 'dapple/core/test.sol';
import 'ens.sol';

contract ENSTest is Test {
    ENS ens;
    ENS_Controller_CuratedNamereg c;
    function setUp() {
        c = new ENS_Controller_CuratedNamereg();
        ens = new ENS( address( c ) );
        c.ens_controller_init();
        c.init_usermock(ens);
        ens.set(c, "key", "value");
    }
    function testRootNodeConfigured() {
        assertEq( c, address(ens.root()), "wrong root controller");
        assertEq( me, c.owner(), "wrong root controller owner" );
    }
    function testCuratedNameRegController() {
        assertEq32("value", c.ens_get("key"), "controller gets wrong key");
        assertEq32("value", ens.get(c, "key"), "app gets wrong key");

        assertTrue( ens.set(c, "key", "value2"), "can't re-set key" );
        assertEq32( "value2", ens.get(c, "key"), "wrong value after set" );
        assertTrue( ens.freeze( c, "key" ), "can't freeze key" );
        assertFalse( ens.set(c, "key", "other_value" ) );
        assertEq32( "value2", ens.get(c, "key"), "wrong value after set attempt" );
    }
    function testResolve() {
        bytes32 ret = ens.get( c, "axsdfasdfasdfasdsdfasdf");
        log_bytes32(ret);
    }
    function testCuratedNameregGet()
             logs_gas()
    {
        ens.get(c, "key");
    }
    function testCuratedNameregSet()
             logs_gas()
    {
        ens.set(c, "key", "value");
    }
}
