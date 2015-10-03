Ether Name System
===


ENS is the ultimate namereg contract.

The system consists of a tree of nodes which each contain a key-value store. Nodes are built using a 
factory contract built into the system and all have the same structure. Users traverse
the system using a contract which knows how to interpret values as subregistrars and
when it is correct to do so.

The rules for name registration are determined by a node controller contract which can
be unique per node. A node can also specify a "filter", which is a rule that all sub-registries
have to follow. This allows different namespaces to have different name registration rules.

The registrar contract and individual names on each node can be "frozen". This allows fully autonomous registries (for example, to create provably immutable maps) even as subsystems of user-controlled namespaces.


How to resolve an ens query:

Start at the beginning of the query string. If there is a leading "/", drop it.
Get the root node from the app contract. Set this as the initial query node.
in a loop:
Scan ahead in the query string until the next unescaped "/". This is your key.
Resolve the key using the query node. This is your value.
If it's a directory, interpret the value as an address, set it as the query node, and repeat loop.
otherwise, return the address.


Examples
----

/dns/query/com/google/

/feed/provider/type/

/dapp/maker/asset/MKR

/f/user

/u/



The `/f/` namespace is controlled by a simple *f*ree, *f*irst-come-*f*irst-serve, *f*rozen, *f*ree-for-all registrar.

    contract f_registrar is ENSAppUser {
        mapping( bytes32 => address ) owner;
        mapping( bytes32 => bool ) is_registered;
        function can_set( address sender, bytes32 key, bytes32 value ) returns (bool) {
            
        }
    }

var f = e.get('/f');  // free first-come first-serve registrar


e://f/nikolai/

bytes32 ipfs_homepage = ENS( '/f/nikolai/ipfs' );






extra
---

ens nodes are direct key-value maps.
