import 'dappsys/data/direct_map.sol';

contract ENSNode is DSDirectMap
{
    function get(bytes32 key) constant
             returns (bytes32 value)
    {
        return _ds_get( key );
    }
    function set(bytes32 key, bytes32 value)
             returns (bool)
    {
        var ok = ( msg.sender == ENSApp(@CONSTANT("ens_app")) );
        if( ok ) {
            _ds_set( key, value );
        }
        return ok;
    }
}
