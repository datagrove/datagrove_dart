CRDTs are data structures that can be updated concurrently, without any locking or coordination, and will remain consistent.
Since a CRDT will never hold an inconsistent state, operations against a CRDT will always be correct, and will never need to be undone (e.g. through "compensating
transactions"). Because of this, CRDTs are said to provide "strong eventual consistency", meaning they exhibit not only “liveness” 
(which states “the right thing will eventually happen”) but also “safety” (which states “a bad thing will never happen”). 
By contrast, regular eventual consistency only exhibits liveness.
CRDTs can be implemented as either state-based (Cv) or operation-based (Cm) (Shapiro et al, 2011).
CmRDTs are operations serialized as objects (e.g. +7, -2, etc.). They must be commutative (can be played out-of-order to produce the same result) but there's no 
requirement to be idempotent. As such CmRDTs require your system architecture to include a message bus that ensures exactly-once delivery to all nodes 
(although ordering is not required).
CvRDTs by contrast represent evaluated state (e.g. 5 instead of +7, -2). They don't have any special requirements on the system they're used in,
and as such have become increasingly popular in decentralised system architectures.

What is a CvRDT?
A single CvRDT object represents an immutable revision of a potentially distributed mutable object. A set of CvRDT objects can be ordered into a join-semilattice 
to represent the causal order of those revisions.
For this to work, the CvRDT must be designed such that:

Updates to the CvRDT are monotonic: new values must always appear greater than the value they were based off, or always less than it, 
if different from the original at all.
Conflicting updates must produce new values which are 'siblings' to one-another (that is, both new values are 'greater than' the original value, 
but neither is greater than the other). We define 'conflicting updates' as being any two updates where we want both to have some observable effect on the final 
merged result -- i.e. we don't want one of the updates to be subsumed by the other.
An automatic resolution must always exist that allows any number of siblings to be merged into a new 'resolution' value, where that value is greater than each of those 
siblings. This is equivalent to saying that a monotonic update must exist for all siblings that can produce the same common value.

Given these 3 constraints, a CvRDT can be designed that allows uncoordinated updates to some distributed state, where the distributed pieces of that state can be 
automatically merged at any time to produce a single consistent object, without any conflicts

There are several open source CRDT libraries that can be used to build collaborative applications and replicated storage systems:
-Automerge (extended abstract) is a JavaScript CRDT implementation with a JSON data model. Network communication is handled by a separate layer, such as Hypermerge (which uses Dat) or plain TCP connections.

-GUN (GitHub) is a graph CRDT implemented in JavaScript, using WebRTC networking. It includes public-key-based user authentication and encryption.

-kappa-db is a JavaScript library for building your own CRDTs over append-only log architectures, with a reference implementation for Dat’s Hypercore data structure. Sort of a ‘build-your-own’ Automerge library.

-Replicated Object Notation (RON) is a data format for encoding CRDT operations, implemented in several languages. It supports register, list, text, set, and counter datatypes. SwarmDB is a RON-based database, implemented in JavaScript.

-Yjs (paper 1, paper 2) is a modular framework for building collaborative applications on the web. It includes several common CRDTs and modules that integrate them with different editors, communication protocols, and databases. More information in this series of blog posts about Yjs.

-Legion (GitHub, paper) provides a JavaScript implementation of counter, set, map, and list CRDTs, and a WebRTC-based networking layer.

-Yorkie (GitHub) is a synchronization solution for building collaborative applications, using MongoDB for data storage.

-The Akka actor framework includes implementations of several CRDTs.

-Schism is a Clojure implementation of several CRDTs.

-Erlang implementation of CRDTs from the Lasp system

-Carlos Baquero’s C++ implementation of state-based CRDTs with delta mutations.

-Eventuate is a toolkit for building applications using causally ordered event streams and CRDTs.

-Logux (GitHub) is a state sync system built primarily for React/Redux in a client/server architecture, but can be used p2p and/or on its own.

-Braid-HTTP (GitHub, IETF draft) is an effort to augment the HTTP protocol itself to include state synchronization as a primitive.

-m-ld synchronises decentralised replicas of JSON-LD graph data, with a query API and pluggable networking and persistence.

-SyncedStore Easy-to-use framework for building collaborative apps by making plain javascript objects sync automatically. Builds on top of Yjs, with a focus on easy integration with React / Vue / Svelte.

-Hazelcast distributed data structures includes implementations of PN Counter

-Dart CRDT complete Dart-native implementation of generic CRDTs that can easily be integrated into any Dart or Flutter application
