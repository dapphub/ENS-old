// TODO replace mock with proper mixin by removing init_usermock and using CONSTANT macro
contract ENSUser is Debug {
    address _ens;
    function init_usermock( ENS app ) {
        _ens = address(app);
    }
    function ens() internal returns (ENS) {
        return ENS(_ens);
    }

    modifier ens_only() {
        //logs("checking ens_only...");
        if( msg.sender == _ens ) {  
            //logs("    success");
            _
        }
    }
}

