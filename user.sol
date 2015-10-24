import 'core/debug.sol';

// TODO replace mock with proper mixin by removing init_usermock and using CONSTANT macro
contract ENSUser is Debug {
    ENS ens;
    function init_usermock( ENS app ) {
        ens = app;
    }
    modifier ens_caller( address who ) {
        if( msg.sender == address(ens) || msg.sender == who ) {
            _
        }
    }
    modifier ens_only() {
        if( msg.sender == address(ens) ) {  
            _
        }
    }
}

