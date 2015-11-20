import 'dapple/test.sol';
import 'ens.sol';
import 'controllers/curated_root.sol';
import 'controllers/standard_registry.sol';

contract ENSTester {
    ENS ens;
	StandardRegistryController std;
    function ENSTester( ENS app, StandardRegistryController _std )
    {
        ens = app;
        std = _std;
    }
    function do_node_set( uint node, bytes32 key, bytes32 value ) returns (bool ok) {
        return ens.node_set( node, key, value );
    }
    function do_node_get( uint node, bytes32 key ) returns (bytes32 value, bool is_node, bool ok) {
        return ens.node_get( node, key );
    }
}

contract ENSTest is Test {
    ENS ens;
    ENS_Controller_CuratedNamereg root;
    StandardRegistryController std;
    uint root_id;
    ENSTester A;

    function setUp() {
        root = new ENS_Controller_CuratedNamereg();
        ens = new ENS( root );
        std = new StandardRegistryController();
        std.ens_controller_init( ens );
        A = new ENSTester( ens, std );
        root_id = root.ens_controller_init( ens, A );
        root.init_ens_usermock(ens);
        ens.node_set( root_id, "key", "value" );
        //A.do_node_set(root_id, "key", "value");
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

        assertTrue( A.do_node_set(root_id, "key", "value2"), "can't re-set key" );
        (val, _, ok) = ens.node_get(root_id, "key");
        assertEq32( "value2", val, "wrong value after set" );
    }

    function testResolve() {
        var (ret, is_link, ok) = ens.get("key");
        assertTrue(ok);
        assertEq32( ret, "value" );
        (ret, is_link, ok) = ens.get("/key");
    	assertTrue(ok);
        assertEq32( ret, "value" );
    }
/*
    function testNestedResolve() {
        var (ret, is_link, ok) = ens.get("key/subkey");
	assertTrue(ok);
        assertEq32( ret, "value" );
    }
*/
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
	
	// test delimiter as first string char
}
