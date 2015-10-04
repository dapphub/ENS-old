import 'interface.sol';

contract ENSNodeControllerInterface {
    // @dev Called once by the ENS core contract.
    function ens_controller_init( uint node_id ) returns (bool);
    function ens_set( address caller, bytes key, bytes32 value ) returns (bool);
    function ens_get_request( bytes key );
    function ens_can_freeze( address caller, bytes key ) returns (bool);
}

// TODO replace mock with proper mixin by removing init_usermock and using CONSTANT macro
contract ENSAppUserMock is Debug {
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
contract ENS_Controller_CuratedNamereg is ENSNodeControllerInterface
                                        , ENSAppUserMock
{
    uint node;
    address public owner;
    // TODO remove app from constructor
    function ENS_Controller_CuratedNamereg()
             ENSAppUserMock()
    {
        owner = msg.sender;
    }

    mapping( bytes => bytes32 ) values;

    // controller implementation
    function ens_controller_init( uint node_id ) returns (bool) {
        node = node_id;
        return true;
    }
    function ens_set( address caller, bytes key, bytes32 value )
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
    function ens_can_freeze( address caller, bytes key )
             ens_only()
             returns (bool)
    {
        if( caller == owner ) {
            return true;
        }
        return false;
    }
    function ens_get_request(bytes key) {
        //logs("in controller get");
        ens().get_callback(values[key]);
    }
}
