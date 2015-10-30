import 'interface.sol';
import 'user.sol';

contract ENS_Controller_CuratedNamereg is ENSController
                                        , ENSUser
{
    address public curator;
    struct ENSEntry {
        bytes32 value;
        bool is_link;
    }

    mapping( bytes32 => bytes32 ) values;

    function ens_controller_init( ENS app, address _curator ) returns (uint) {
        init_usermock( app );
        curator = _curator;
        return ens.new_node();
    }
    function ens_set( uint node, address caller, bytes32 key, bytes32 value, bool is_link)
             ens_only()
             returns (bool)
    {
        if( caller == curator ) {
            values[key] = value;
            return true;
        }
        return false;
    }
    function ens_get( uint node, address caller, bytes32 key) returns (bytes32 value, bool is_link, bool ok) {
        return (values[key], false, true);
    }
}
