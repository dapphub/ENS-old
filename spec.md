ENS
===

TOC
---

App ABI
Controller ABI
App behavior
Resolving ERL
User Mixin
Deploy sequence ("default" namespaces)
Example Controller Types
Notes and Ideas


App ABI
---

    contract ENSApp {
    }

maybe:

    function long_value( bytes32 index ) returns (bytes value, bool ok);
    
    link()

aux:

    function path_info( bytes path) returns (uint node_id, bytes last_key, bool ok);
    function controller( uint node ) returns (ENSController controller);


Controller ABI
---

    contract ENSControllerInterface {
        function ens_get( uint node, address caller, bytes key ) returns (bytes32 value, bool ok);
        function ens_set( uint node, address caller, bytes key, bytes32 value ) returns (bool ok);
        function ens_link( uint node, address caller, bytes key, uint subnode ) returns (bool ok);
        function ens_freeze( uint node, address caller, bytes key ) returns (bool ok);
    }


App Behavior
-----------

ENS will attempt to interact with registered controllers to resolve queries.
ENS will act as if the controller implements the controller interface above.


* If ENS calls any controller function, then the `caller` argument is the sender to ENS (the sender's sender). If the sender is not ENS, this value is unreliable. Use the `ENSUser` mixin's `ens_sender_only(who)` modifier.
* If the controller returns `true` from a call to `ens_set` from ENS, ENS will return true (from one of the `set` variants)

* If ENS calls `ens_get`, and it returns `(val, true)`, ENS will returns `(val, true)` (from `get` or `query`).
* If ENS calls `ens_get`, and it returns `(val, false)`, ENS will returns `(0x0, false)` (from `get` or `query`).

* If ENS calls `ens_freeze`, and it returns `true`, then ENS will immediately call `ens_get`. If that returns `(val, true)`, then then that key-value pair is frozen on that controller. `val` is recorded as the frozen value. If it returns `(val, false)`, then ENS will also return false (from `freeze`);
* If a key-value pair is frozen, ENS will no longer call `ens_get` to resolve quries. Instead it will use the frozen value.

* The function of the `node` argument is that it allows a single contract to control multiple namespaces. A controller can call `new_node` as many times as it likes.


These simple interaction rules give contracts great freedom in managing namespaces, while balancing this freedom with the ability to provably lock down entire paths.

ERLs
---

An ERL is a string that resembles a file path.

ERL query pseudocode:

    def split(s):
        i = s.find("/")
        return (s[:i], s[i+1:], True)

    def query(s, n=root):
        (key, subquery, ok) = split(s)
        if not ok:
            return (0, False)
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
