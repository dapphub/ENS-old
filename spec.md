ENS specification v0.1
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


* If ENS calls a controller function, then the `caller` argument is the sender to ENS (the sender's sender). If the sender is not ENS, this value is unreliable. 
* If ENS calls a controller function, then the `node` argument is the node ID for which the controller should resolve the value. This is either given directly through `node_*` or by resolving the ERL path up to the final key and returning the node ID that path points to. If the sender is not ENS, this value is unreliable.
* The function of the `node` argument is that it allows a single contract to control multiple namespaces. A controller can call `claim_node` as many times as it likes.
* If the controller returns `true` from a call to `ens_set` from ENS, ENS will return true.
* If ENS calls `ens_get`, and it returns `(val, link, true)`, ENS will returns `(val, link, true)` (from `get`).
* If ENS calls `ens_get`, and it returns `(val, link, false)`, ENS will returns `(0x0, false, false)` (from `get`).



ERLs
---

An ERL is a `bytes` string that resembles a file path. It is a string of 32-byte (or shorter) words separated by `/`, with `\\` used as an escape character.
The following code snippet shows how to turn a path into a value. Notice that every value up to the last value must be specified as a link, much like everything up to the file in a normal filesystem path must be specified a directory by the user.


User Mixin
--------------
The `ENSUser` mixin is a helper contract that you inherit to get access to helpful internal functions and modifiers. It does not add any overhead in excess of what you actually use.

Example controller types
------------------

* `/` curators - ENS system owners who define "TLDs".
* `/f/` FCFS, normal transfer, squatter paradise
* `/d/` "Dapps", a proposed namespace with an auction-like mechanism to combat squatting

Deploy Sequence
---

1) Deploy curator controller
2) Deploy ENS base contract, giving curator as root controller
3) Assign /f/ the FCFS controller.
4) Assign ownership of curated controller to ENS stake-vote


Notes and Ideas
---

* Note: The `path` argument is a `bytes` ASCII-like string, not the native `string` type. You could use Unicode or whatever else, but you must take care to properly escape the encoded version.
* Assign /nr/ to EF namereg to help them raise money.


