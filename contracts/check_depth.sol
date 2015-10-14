contract DepthChecker {
    modifier requires_depth( uint16 depth ) {
        if( check_depth(depth) ) {
            _
        }
    }
    function check_depth(uint16 depth) external returns (bool) {
        if( depth == 1 || depth == 0 ) {
            return true;
        }
        return check_depth(depth-1);
    }
}
