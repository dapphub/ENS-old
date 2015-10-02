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

`resolve( string query ) returns ( bytes32 value, bool is_node )`

`set( ENSNode node, bytes32 key, bytes32 value )`
`set_dir( ENSNode node, bytes32 key, ENSNode dir )`

`get( ENSNode node, bytes32 key) returns (bytes32 value, bool is_node)`
`resolve_relative( ENSNode node, bytes32 key) returns (bytes32 value, bool is_node)`

Node callbacks:


Node
---

get
set


Controller
---
