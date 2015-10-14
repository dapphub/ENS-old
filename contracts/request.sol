contract ENSGetRequestManager {
    uint current_request_id;
    struct get_request {
        bool closed;
        bool filled;
        bytes32 value;
    }
    mapping( uint => get_request ) requests;
    function start_request() internal returns (uint) {
        close_request(current_request_id);
        return current_request_id++;
    }
    function resolve_request( bytes32 value ) internal {
        requests[current_request_id].value = value;
        requests[current_request_id].filled = true;
    }
    function close_request( uint request_id ) internal returns (bool) {
        requests[request_id].closed = true;
        return requests[request_id].filled;
    }
    function request_result( uint request_id ) internal returns (bytes32) {
        return requests[request_id].value;
    }
}
