
This app maps *ens query strings* to bytes32 values. The app also maintains a record of which
values represent subnodes as opposed to raw values.

It is like a basic file naming scheme that distinguishes between file objects and directory objects.

The app has a central interface contract which interacts with the directory tree.

individual directories are configured with controllers.


ENSApp
---

User functions:

```
    query :: key -> value, ok
    store :: key, value -> ok

    get :: node, key -> value, ok
    set :: node, key, value -> ok
    freeze :: node, key -> ok

    register :: -> ok
```


`query( string query_string ) returns ( bytes32 value, bool ok )`
`store( string path_string, bytes32 value ) returns (bool ok)`

`set( address node, bytes32 key, bytes32 value ) returns (bool ok)`
`get( address node, bytes32 key ) returns (bytes32 value, bool ok)`
`freeze( address node, bytes32 key) returns (bool ok)`

`register() returns (bool)`

Node callbacks:


Node
---

get
set


Controller
---
