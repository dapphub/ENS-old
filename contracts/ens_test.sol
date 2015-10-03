import 'dappsys/test/test.sol';


contract ENSTest is Test {
    
    ENSApp ens;
    FreeForAllControllaer f;
    function setUp() {
        ens = new ENSApp();
        ens.set("/f", f);
        ens.fix("/f");
        var dir = ens.dir("/free/nikolai");
        
    }

}
