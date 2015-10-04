ENS
===


universal name system.

the app maps strings to bytes32 values. The app also maintains a record of which
values represent subnodes as opposed to raw values.

It is like a basic file naming scheme that distinguishes between file objects and directory objects.

The app has a central interface contract which interacts with the directory tree.

individual directories are configured with controllers.


ENSApp
---

User functions:

get :: string -> bytes32, byte
set :: string -> bytes32 -> ens_type_id

`resolve( string query ) returns ( bytes32 value, bool success )`

`set( string path, bytes32 value)`
`set_dir( string path, ENSNode dir)`
`set( ENSNode node, bytes32 key, bytes32 value )`
`set_dir( ENSNode node, bytes32 key, ENSNode dir )`
`set_controller( ENSNode node, ENSNodeController controller )`

`get( ENSNode node, bytes32 key) returns (bytes32 value, bool is_dir)`
`get_dir( string query ) returns (ENSNode node)`
`get_dir( ENSNode node, bytes32 key) returns (ENSNode subdir)`
`resolve_relative( ENSNode node, bytes32 key) returns (bytes32 value, bool is_node)`

`freeze_key( ENSNode node, bytes32 key)`
`freeze_controller( ENSNode node )`

`new_dir() returns (ENSNode dir)`

Node callbacks:


Node
---

get
set


Controller
---
