ENS
===
excellent namespace solution

This is the dapple package repo. ENS docs live in docs/ens.

ENS is the ultimate namereg contract.

The system consists of a tree of nodes which each contain a key-value store. Users traverse
the system using a contract which knows how to interpret values as subregistrars and
when it is correct to do so.

The individual values on each node can be "frozen". This allows fully autonomous registries (for example, to create provably immutable maps) even as subsystems of user-controlled namespaces.


How to resolve an ens query:

Start at the beginning of the query string. If there is a leading "/", drop it.
Get the root node from the app contract. Set this as the initial query node.
in a loop:
Scan ahead in the query string until the next unescaped "/". This is your key.
Resolve the key using the query node. This is your value.
If it's a directory, interpret the value as an address, set it as the query node, and repeat loop.
otherwise, return the value.


Examples
----

/feed/provider/type/
/dapp/maker/asset/MKR
/f/test


The `/` namespace has a controller which allows the "curator" to add frozen entries **and nothing else**. It is initially controlled by a multisig of members of Nexus Development, who will configure the `/f/` namespace, but control will be transferred to a stake-vote system with its own asset.

The `/f/` namespace is controlled by a simple *f*ree, *f*irst-come-*f*irst-serve, *f*rozen, *f*ree-for-all registrar.
