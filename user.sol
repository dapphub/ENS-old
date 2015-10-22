import 'core/debug.sol';

// TODO replace mock with proper mixin by removing init_usermock and using CONSTANT macro
contract ENSUser is Debug {
    ENS ens;
    address _ens;
    function init_usermock( ENS app ) {
        ens = app;
        _ens = address(app);
    }
    modifier ens_only() {
        //logs("checking ens_only...");
        if( msg.sender == _ens ) {  
            //logs("    success");
            _
        }
    }
}

