# Peer management

Using a basic sa.amos peer communication system, distributed sa.amos peers can be set up which communicate using TCP/IP. A federation of sa.amos peers is managed by a name server which is an sa.amos peer knowing addresses and names of other sa.amos peers.

Queries, AmosQL commands, and results can be shipped between peers. Once a federation is set up, multi-database facilities can be used for defining queries and views spanning several sa.amos peers [\[RJK03\]](#RJK03). Reconciliation primitives can be used for defining object-oriented multi-peer views [\[JR99a\]](#JR99a)[\[JR99b\]](#JR99b).

## Peer communication

The following AmosQL system functions are available for inter-peer communication:

`nameserver(Charstring name)->Charstring`

The function makes the current stand-alone database into a name server and registers there itself as a peer with the given `name`. If name is empty ("") the name server will become *anonymous* and not registered as a peer. It can be accessed under the peer name "NAMESERVER" though.

`listen()`

 The function starts the peer listening loop. It informs the name server that this peer is ready to receive incoming messages. The listening loop can be interrupted with CTRL-C and resumed again by calling `listen()`. The name server must be listening before any other peer can register.

`register(Charstring name)->Charstring`

The function registers in the name server the current stand-alone database as a peer with the given `name`. The system will complain if the name is already registered in the name server. The peer needs to be activated with `listen()` to be able to receive incoming requests. The name server must be running on the local host.

`register(Charstring name, Charstring host)->Charstring`

Registers the current database as a peer in the federation name server
running on the given `host`.Signals error if peer with same name already registered in federation.

```
reregister(Charstring name)->Charstring
reregister(Charstring name, Charstring host)->Charstring
```

Same as `register()` but first unregisters another registered peer having same name rather than signaling error. Good when restarting a peer registered in name server after failure so the failed peer will be unregistered.  

`this_amosid()->Charstring name`

Returns the `name` of the peer where the call is issued. Returns the string `"NIL"` if issued in a not registered standalone sa.amos system.

`other_peers()->Bag of Charstring name`

Returns the `name`s of the other peers in the federation managed by the name server.

`ship(Charstring peer, Charstring cmd)-> Bag of Vector`

 Ships the AmosQL command `cmd` for execution in the named peer. The result is shipped back to the caller as a set of tuples represented as vectors.  If an error happens at the other peer the error is also shipped back.

`call_function(Charstring peer, Charstring fn, Vector args, Integer stopafter)-> Bag of Vector`

 Calls the sa.amos function named `fn` with argument list `args` in `peer`. The result is shipped back to the caller as a set of tuples represented as vectors. The maximum number of tuples shipped back is limited by `stopafter`. If an error happens at the other peer the error is also shipped back.

`send(Charstring peer, Charstring cmd)-> Charstring peer`

Sends the AmosQL command `cmd` for asynchronous execution in the named peer without waiting for the result to be returned. Errors are handled at the other peer and not shipped back.

`send_call(Charstring peer, Charstring fn, Vector args)-> Boolean`

 Calls the sa.amos function named `fn` with argument list `args` asynchronously in the named peer without waiting for the result to be returned. Errors are handled at the other peer and not shipped back.

`broadcast(Charstring cmd)-> Bag of Charstring`

Sends the AmosQL command `cmd` for asynchronous execution in all other peers. Returns the names of the receiving peers.

`gethostname()->Charstring name`

 Returns the name of the host where the current peer is running.

`kill_peer(Charstring name)->Charstring`

Kills the named peer. If the peer is the name server it will not be killed, though. Returns the name of the killed peer.

`kill_all_peers()->Bag of Charstring`

Kills all peers. The name server and the current peer will still be alive afterwards. Returns the names of the killed peers.

`kill_the_federation()->Boolean`

Kills all the peers in the federation, including the name server and the peer calling kill_the_federation.

`is_running(Charstring peer)->Boolean`

Returns true if peer is listening.

`wait_for_peer(Charstring peer)->Charstring`

Waits until the peer is running and then returns the peer name.

`amos_servers()->Bag of Amos`

Returns all peers managed by the name server on this computer. You need not be member of federation to run the function.

## Peer queries and views

Once you have established connections to sa.amos peers you can define views of data from your peers. You first have to import the meta-data about selected types and functions from the peers. This is done by defining *proxy types* and *proxy functions* [\[RJK03\]](#RJK03) using the system function `import_types`:

`import_types(Vector of Charstring typenames,  Charstring p)-> Bag of Type pt`

Defines proxy types `pt` for types named `typenames` in peer `p`. Proxy functions are defined for the functions in `p` having the imported types as only argument. Inheritance among defined proxy types  is imported according to the corresponding  inheritance relationships between imported types in the peer `p`.

Once the proxy types and functions are defined they can transparently be queried. Proxy types can be references using `@` notation to reference types in other peers. For example:

`select name(p) from Person@p1;`

Selects the `name` property of objects of type Person in peer `p1`.

`import_types` only imports those functions having one of `typenames` as its single arguments. You can import other functions using system function `import_func`:

`import_func(Charstring fn, Charstring p)->Function pf`

imports a function named `fn` from peer `p` returning proxy function `pf`.

On top of the imported types object-oriented multi-peer views can be defined, as described in [\[RJK03\]](#RJK03) consisting of derived types [\[JR99a\]](#JR99a) whose extents are derived through queries intersecting extents of other types, and IUTs [\[JR99b\]](#JR99b) whose extents reconciles unions of other type extents. Notice that the implementation of IUTs is limited. (In particular the system flag `latebinding('OR');` must be set before IUTs can be used and this may cause other problems).
