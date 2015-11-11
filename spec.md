ENS
===

TOC
---

1) App ABI
2) Controller ABI
3) App behavior
4) Resolving ERLs
5) User Mixin
6) Deploy sequence ("default" namespaces)
7) Example Controller Types
8) Notes and Ideas


App ABI
---

    contract ENSApp {
        function get( bytes path ) returns (bytes32 value, bool is_link, bool ok);
        function set( bytes path, bytes32 value, bool is_link ) returns (bool ok);
        
        function node_set( uint node, bytes32 key, bytes32 value, bool link ) returns (bool ok);
        function node_get( uint node, bytes32 key ) returns (bytes32 value, bool link, bool ok);

        function claim_node() returns (uint node);
        function get_controller( uint node ) returns (ENSController controller, bool ok);
    }

Controller ABI
---

    contract ENSControllerInterface {
        function ens_get( uint node, address caller, bytes32 key ) returns (bytes32 value, bool is_link, bool ok);
        function ens_set( uint node, address caller, bytes32 key, bytes32 value, bool is_link ) returns (bool ok);
    }


App Behavior
-----------

ENS will attempt to interact with registered controllers to resolve queries.
ENS will act as if the controller implements the controller interface above.


* If ENS calls any controller function, then the `caller` argument is the sender to ENS (the sender's sender). If the sender is not ENS, this value is unreliable. Use the `ENSUser` mixin's `ens_sender_only(who)` modifier.
* If ENS calls any controller function, then the `node` argument is the node ID for which the controller should resolve the value. If the sender is not ENS, this value is unreliable. Use the `ENSUser` mixin's `ens_sender_only(who)` modifier.
* The function of the `node` argument is that it allows a single contract to control multiple namespaces. A controller can call `claim_node` as many times as it likes.
* If the controller returns `true` from a call to `ens_set` from ENS, ENS will return true (from one of the `set` variants).

* If ENS calls `ens_get`, and it returns `(val, link, true)`, ENS will returns `(val, link, true)` (from `get`).
* If ENS calls `ens_get`, and it returns `(val, link, false)`, ENS will returns `(0x0, false, false)` (from `get`).



ERLs
---

An ERL is a string that resembles a file path.

ERL query pseudocode:

    def split(s):
        i = s.find("/")
        return (s[:i], s[i+1:], True)

    def get(path):
        (key, subquery, ok) = split(s)
        if not ok:
            return (0, false, false)
        (val, ok) = n.get(key)
        if not ok:
            return (0, False)
        if len(subquery) == 0:
            return val
        if not is_controller(val):
            return (0, False)
        return query(subquery, val)




Start at the beginning of the query string. If there is a leading "/", drop it.
Get the root node from the app contract. Set this as the initial query node.
in a loop:
Scan ahead in the query string until the next unescaped "/". This is your key.
Resolve the key using the query node. This is your value.
If it`s a directory, interpret the value as an address, set it as the query node, and repeat loop.
otherwise, return the address.


User Mixin
--------------

Example controller types
------------------

/ curators
/f/ FCFS

Deploy Sequence
---

Assign /f/ the FCFS controller.
Assign / to a curated single-set controller
Assign ownership of curated controller to ENS stake-vote


Notes and Ideas
---

Assign /nr/ to EF namereg to help them raise money
