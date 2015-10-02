Ether Name System
===


ENS is the ultimate namereg contract.

The system consists of nodes which contain a key-value store. Nodes are built using a 
factory contract built into the system and all have the same structure. Users traverse
the system using a contract which knows how to interpret values as subregistrars and
when it is correct to do so.

The rules for name registration are determined by a node controller contract which can
be unique per node. A node can also specify a "filter", which is a rule that all sub-registries
have to follow. This allows different namespaces to have different name registration rules.

The registrar contract and individual names on each node can be "frozen". This allows fully autonomous registries (for example, to create provably immutable maps) even as subsystems of user-controlled namespaces.


Getting started:

Examples
----

The `/f/` namespace is controlled by a simple *f*ree, *f*irst-come-*f*irst-serve, *f*rozen, *f*ree-for-all registrar.



var free_for_all = e.get('/free');  // free first-come first-serve registrar
free_for_all.register('nikolai');
// OR
e.register( 





e://free/nikolai/



bytes32 ipfs_homepage = ENS( '/free/nikolai/ipfs' );






extra
---

ens nodes are direct key-value maps. This means they are 
