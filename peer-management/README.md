# Peer management

Using a basic sa.amos peer communication system, distributed sa.amos
peers can be set up which communicate using TCP/IP. A federation of
sa.amos peers is managed by a name server which is an sa.amos peer
knowing addresses and names of other sa.amos peers.

Queries, AmosQL commands, and results can be shipped between
peers. Once a federation is set up, multi-database facilities can be
used for defining queries and views spanning several sa.amos
peers. Reconciliation primitives can be used for defining
object-oriented multi-peer views.
