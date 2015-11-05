# Peer communication

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
