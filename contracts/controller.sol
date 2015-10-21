import 'interface.sol';
import 'user.sol';

contract ENS_Controller_CuratedNamereg is ENSControllerInterface
                                        , ENSUser
{
    address public owner;

    mapping( bytes => bytes32 ) values;

    function ens_controller_init( ENSInterface ens, address _owner ) returns (uint) {
        owner = _owner;
        return ens.register();
    }
    function ens_set( uint node, address caller, bytes key, bytes32 value )
             ens_only()
             returns (bool)
    {
        if( caller == owner ) {
            values[key] = value;
            return true;
        }
        return false;
    }
    function ens_freeze( uint node, address caller, bytes key )
             ens_only()
             returns (bool)
    {
        if( caller == owner ) {
            return true;
        }
        return false;
    }
    function ens_get( uint node, address caller, bytes key) returns (bytes32 value, bool ok) {
        //logs("in controller get");
        return (values[key], true);
    }
}
