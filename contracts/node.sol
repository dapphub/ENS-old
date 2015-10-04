contract ENSNode
{
    bytes32[2**256-1] _storage;
    function get(bytes32 key) constant
             returns (bytes32 value)
    {
        return _storage[uint(key)];
    }
    function set(bytes32 key, bytes32 value)
             returns (bool)
    {
        var ok = ( msg.sender == ENSApp( CONSTANT:"ens_app" ) );
        if( ok ) {
            _storage[uint(key)] = value;
        }
        return ok;
    }
}
