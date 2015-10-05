import 'interface.sol';
import 'user.sol';

contract ENS_Controller_CuratedNamereg is ENSControllerInterface
                                        , ENSUser
{
    address public owner;

    bool _last_ok;
    function last_ok() returns (bool) {
        return _last_ok;
    }

    mapping( bytes32 => bytes32 ) values;

    function ens_controller_init( address _owner ) returns (bool) {
        owner = _owner;
        ens.register();
    }
    function ens_set( address caller, bytes32 key, bytes32 value )
             ens_only()
             returns (bool)
    {
        //logs("in controller set");
        if( caller == owner ) {
            values[key] = value;
            return true;
        }
        return false;
    }
    function ens_can_freeze( address caller, bytes32 key )
             ens_only()
             returns (bool)
    {
        if( caller == owner ) {
            return true;
        }
        return false;
    }
    function ens_get(bytes32 key) returns (bytes32 value, bool ok) {
        //logs("in controller get");
        value = values[key];
        ok = true;
        _last_ok = true;
    }
}
