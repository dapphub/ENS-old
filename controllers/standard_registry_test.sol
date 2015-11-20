import 'dapple/test.sol';

contract StdRegUser {
	StandardRegistryController std;

	function StdRegUser( StandardRegistryController _std ) {
		std = _std;
	}

	function do_set( uint node, bytes32 key, bytes32 value) returns (bool ok) {
		return std.set( node, key, value );
	}

    function do_new_registry() returns ( uint node ) {
        return std.new_registry();
    }
}

contract StdRegTest is Test {
	StandardRegistryController std;
	StdRegUser u1;
	uint reg1;

	function setUp() {
		std = new StandardRegistryController();
		u1 = new StdRegUser( std );
		reg1 = u1.do_new_registry();
	}

	function testBasicRegistry() {
		u1.do_set( reg1, "key", "value");
		var (val, ok) = std.get( reg1, "key" );
		assertTrue(ok);
		assertEq32( val, "value" );
	}
}
