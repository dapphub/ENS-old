import 'interface.sol';
import 'user.sol';

contract ENS_Controller_CuratedNamereg is ENSControllerInterface
                                        , ENSUser
{
    address public curator;

    mapping( bytes32 => bytes32 ) values;

    function ens_controller_init( ENS app, address _curator ) returns (uint) {
        init_usermock( app );
        curator = _curator;
        return ens.new_node();
    }
    function ens_set( uint node, address caller, bytes32 key, bytes32 value )
             ens_only()
             returns (bool)
    {
        if( caller == curator ) {
            values[key] = value;
            return true;
        }
        return false;
    }
    function ens_freeze( uint node, address caller, bytes32 key )
             ens_only()
             returns (bool)
    {
        if( caller == curator ) {
            return true;
        }
        return false;
    }
    function ens_get( uint node, address caller, bytes32 key) returns (bytes32 value, bool ok) {
        //logs("in controller get");
        return (values[key], true);
    }
}
