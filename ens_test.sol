import 'dapple/test.sol';
import 'ens.sol';
import 'controllers/curated_root.sol';
import 'controllers/standard_registry.sol';

contract ENSTester is ENSUser {
    function ENSTester( ENS app )
    {
        init_usermock(app);
    }
    function do_set( uint node, bytes32 key, bytes32 value ) returns (bool ok) {
        return ens.node_set( node, key, value );
    }
    function do_get( uint node, bytes32 key ) returns (bytes32 value, bool is_node, bool ok) {
        return ens.node_get( node, key );
    }
}

contract ENSTest is Test {
    ENS ens;
    ENS_Controller_CuratedNamereg root;
    StandardRegistryController[10] _conts;
    uint root_id;
    ENSTester A;
    function setUp() {
        root = new ENS_Controller_CuratedNamereg();
        ens = new ENS( root );
        for( var i = 0; i < _conts.length; i++ ) {
            _conts[i] = new StandardRegistryController( ens );
        }
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
        var (val, _,  ok) = root.ens_get(root_id, me, "key");
        assertEq32("value", val, "controller gets wrong key");
        (val, _, ok) = ens.node_get(root_id, "key");
        assertEq32("value", val, "app gets wrong key");

        assertTrue( A.do_set(root_id, "key", "value2"), "can't re-set key" );
        (val, _, ok) = ens.node_get(root_id, "key");
        assertEq32( "value2", val, "wrong value after set" );
    }
    function testResolve() {
        var (ret, _, ok) = ens.node_get( root_id, "axsdfasdfasdfasdsdfasdf");
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
