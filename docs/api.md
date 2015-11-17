# API

All functions return `bool ok` as their last return value. This indicates whether the function call succeeded. This is necessary because certain EVM failure modes result in all of a function's return values being `null`. Since `null` is a valid value for all the return values of most of our functions, we provide this always-true flag as a way to catch such failure modes. This flag is only explained here, as explaining it for every function would be unnecessarily repetitive.

## Interface Contracts

There are two interfaces at the core of ENS: [ENSApp](#ENSApp) and [ENSController](#ENSController). There are also a few ENSController example implementations.

### contract ENSApp

This defines an interface for contracts that get and set bytes32 values by Unix-style path.

#### function claim_node() returns (uint node)
Intended for use by ENSController contracts. Reserves a node ID and sets the controller calling the function as that node's controller contract. Node IDs must be registered using `set` to place the node at a specific path.

#### function get_controller( uint node ) returns (ENSController controller, bool ok)
Returns the controller contract for the node specified by the `uint` node ID supplied.

#### function get( bytes path ) returns ( bytes32 value, bool is_link, bool ok )
Returns the `bytes32` value stored at a given path and `bool is_link` indicating whether the value should be treated as a pointer to another node in the ENS tree.

#### function set( bytes path, bytes32 value, bool is_link ) returns ( bool ok )
Places the `bytes32 value` at the given `bytes path`. If the `bytes32 value` should be interpreted as a node ID, `bool is_link` should be set to `true`.

#### function node_get( uint node, bytes32 key ) returns ( bytes32 value, bool is_link, bool ok )
Looks up the `bytes32 value` and `bool is_link` at a specific `bytes32 key` on the node indicated by `uint node`.

#### function node_set( uint node, bytes32 key, bytes32 value, bool is_link ) returns ( bool ok )
Sets the `bytes32 value` and `bool is_link` for a specific `bytes32 key` on the node indicated by `uint node`.

### contract ENSController

This defines an interface for contracts that get and set values of keys on nodes based on the permissions level of the caller and the key requested.

#### function ens_set( uint node, address caller, bytes32 key, bytes32 value, bool is_link ) returns (bool ok)
Succeeds only if the `bool is_link` can be set and the `bytes32 key` can be set to `bytes32 value` on the `uint node` by the identity specified by `address caller`.

#### function ens_get( uint node, address caller, bytes32 key ) returns (bytes32 value, bool is_link, bool ok)
Succeeds only if the `bool is_link` and the `bytes32 value` at `bytes32 key` can be retrieved from the `uint node` by the identity specified by `address caller`.


## Implemented Contracts

### contract ENS

A minimal implementation of ENSApp.

### contract ENSExtendedImpl

Extends `contract ENS`. 

#### function

### contract StandardRegistryController

A first-come, first-serve, minimal implementation of `contract ENSController`.

### contract ENS_Controller_CuratedNameReg

An "owned" controller that only allows the identity that deployed it to set path values.

### contract ENSUser

TBD
