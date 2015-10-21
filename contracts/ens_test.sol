import 'core/test.sol';
import 'ens.sol';
import 'user.sol';

contract ENSTester is ENSUser {
    function ENSTester(ENS app)
    {
        init_usermock(app);
    }
    function do_set( uint node, bytes key, bytes32 value ) returns (bool ok) {
        return ens.node_set( node, key, value );
    }
    function do_get( uint node, bytes key ) returns (bytes32 value, bool ok) {
        return ens.node_get( node, key );
    }
    function do_freeze( uint node, bytes key ) returns (bool ok) {
        return ens.node_freeze(node, key);
    }
}

contract ENSTest is Test {
    ENS ens;
    ENS_Controller_CuratedNamereg root;
    uint root_id;
    ENSTester A;
    function setUp() {
        root = new ENS_Controller_CuratedNamereg();
        ens = new ENS( root );
        A = new ENSTester( ens );
        root_id = root.ens_controller_init( ens, A );
        root.init_usermock(ens);
        A.do_set(root_id, "key", "value");
    }
    function testRootNodeConfigured() {
        assertEq( root, address(ens.root()), "wrong root controller");
        assertEq( A, root.curator(), "wrong root controller owner" );
    }
    function testRootNodeController() {
        var (val, ok) = root.ens_get(root_id, me, "key");
        assertEq32("value", val, "controller gets wrong key");
        (val, ok) = ens.node_get(root_id, "key");
        assertEq32("value", val, "app gets wrong key");

        assertTrue( A.do_set(root_id, "key", "value2"), "can't re-set key" );
        (val, ok) = ens.node_get(root_id, "key");
        assertEq32( "value2", val, "wrong value after set" );
        assertTrue( A.do_freeze( root_id, "key" ), "can't freeze key" );
        (val, ok) = ens.node_get(root_id, "key");
        assertEq32( "value2", val, "wrong value after set attempt" );
    }
    function testResolve() {
        var (ret, ok) = ens.node_get( root_id, "axsdfasdfasdfasdsdfasdf");
        assertEq32( ret, 0x0 );
    }
    function testCuratedNameregGet()
             logs_gas()
    {
        ens.node_get(root_id, "key");
    }
    function testCuratedNameregSet()
             logs_gas()
    {
        ens.node_set(root_id, "key", "value");
    }
}
