##### Join us on SLACK
------
[![Slack Status](http://slack.makerdao.com/badge.svg)](https://slack.makerdao.com)

ENS
===

ENS is a contract system and set of conventions for unifying all simple (word-sized keys/values) registries into a single hierarchal namespace. It resembles a filesystem of `bytes32` values, with user-specified permissions/behavior at each directory.

For example, `/f/` is a simple first-come first-serve proof of concept namespace. You might register `/f/yourname`, and assign it to a "owned" controller you control. Now you have private namespace within the global ENS system, and anyone could look up `/f/yourname/email`, `/f/yourname/openID`, and so on.

The root registry `/` is controlled by "curators", a token-based voting scheme which allows the token holders to permanently set a value in the root registry. They are incenvitized to create good name registry mechanisms and assign TLD's wisely, because they could collect fees for popular namespaces they create and set as TLD's.


**The proposed specification is in `spec.md`.**

## Documentation

```
sudo pip install mkdocs
mkdocs serve
```
