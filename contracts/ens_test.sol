import 'dappsys/test/test.sol';


contract ENSTest is Test {
    
    ENSApp ens;
    function setUp() {
        ens = new ENSApp();
        var free_node = app.new_node();
        ens.set("/free", free_node);

        var dir = ens.dir("/free/nikolai");
        
    }

}
