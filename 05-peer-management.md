## 5 Peer management

Using a basic Amos II peer communication system, distributed Amos II
peers can be set up which communicate using TCP/IP. A federation of Amos
II peers is managed by a <span style="font-style: italic;">name
server</span> which is an Amos II peer knowing addresses and names of
other Amos II peers. Queries, AmosQL commands, and results can be
shipped between peers. Once a federation is set up, multi-database
facilities can be used for defining queries and views spanning several
Amos II peers [\[RJK03\]](#RJK03). Reconciliation primitives can be used
for defining object-oriented multi-peer views
[\[JR99a\]](#JR99a)[\[JR99b\]](#JR99b).\

5.1 Peer communication
----------------------

The following AmosQL system functions are available for inter-peer
communication:\

`   nameserver(Charstring name)->Charstring`\
 The function makes the current stand-alone database into a name server
and registers there itself as a peer with the given `name`. If name is
empty ("") the name server will become *anonymous* and not registered as
a peer. It can be accessed under the peer name "NAMESERVER" though.\

`   listen()`\
 The function starts the peer listening loop. It informs the name server
that this peer is ready to receive incoming messages. The listening loop
can be interrupted with CTRL-C and resumed again by calling <span
style="font-style: italic;">listen()</span>. The name server must be
listening before any other peer can register.

`   register(Charstring name)->Charstring`\
 The function registers in the name server the current stand-alone
database as a peer with the given <span
style="font-style: italic;">name</span> `. ` The system will complain if
the name is already registered in the name server. The peer needs to be
activated with <span style="font-style: italic;">listen()</span> to be
able to receive incoming requests. The name server must be running on
the local host.\

`   register(Charstring name, Charstring host)->Charstring         `\
 Registers the current database as a peer in the federation name server
running on the given <span style="font-style: italic;">host</span>.
Signals error if peer with same name already registered in federation.\

`   reregister(Charstring name)->Charstring               reregister(Charstring name, Charstring host)->Charstring         `\
 as <span style="font-style: italic;">register()</span> but first
unregisters another registered peer having same name rather than
signaling error. Good when restarting peer registered in name server
after crash so the crashed peer will be unregistered.  

`   this_amosid()->Charstring name`\
 Returns the `name` of the peer where the call is issued. Returns the
string `"NIL"` if issued in a not registered standalone Amos II system.

`   other_peers()->Bag of Charstring name`\
 Returns the `name`s of the other peers in the federation managed by the
name server.

`   ship(Charstring peer, Charstring cmd)-> Bag of Vector`\
 Ships the AmosQL command <span style="font-style: italic;">cmd</span>
for execution in the named peer. The result is shipped back to the
caller as a set of tuples represented as vectors.  If an error happens
at the other peer the error is also shipped back.\

<span style="font-family: Times New Roman;">
`   call_function(Charstring peer, Charstring fn, Vector args, Integer stopafter)-> Bag of Vector`\
 Calls the Amos II function named <span style="font-style:
            italic;">fn</span> with argument list <span
style="font-style: italic;">args</span> in <span
style="font-style: italic;">peer</span>. The result is shipped back to
the caller as a set of tuples represented as vectors. The maximum number
of tuples shipped back is limited by <span
style="font-style: italic;">stopafter</span>. If an error happens at the
other peer the error is also shipped back.\
\
 </span> `   send(Charstring peer, Charstring cmd)-> Charstring peer`\
 Sends the AmosQL command <span style="font-style: italic;">cmd</span>
for asynchronous execution in the named peer without waiting for the
result to be returned. Errors are handled at the other peer and <span
style="font-style: italic;">not </span>shipped back.\

<span style="font-family: Times New Roman;">
`   send_call(Charstring peer, Charstring fn, Vector args)-> Boolean           `\
 Calls the Amos II function named <span style="font-style:
            italic;">fn</span> with argument list <span
style="font-style: italic;">args</span> asynchronously in the named
<span style="font-style: italic;">peer</span> without waiting for the
result to be returned. Errors are handled at the other peer and <span
style="font-style:
            italic;">not </span>shipped back.</span>

`   broadcast(Charstring cmd)-> Bag of Charstring         `\
 Sends the AmosQL command <span style="font-style: italic;">cmd</span>
for asynchronous execution in all other peers. Returns the names of the
receiving peers.\

`   gethostname()->Charstring name`\
 Returns the name of the host where the current peer is running.\

`   kill_peer(Charstring name)->Charstring`\
 Kills the named peer. If the peer is the name server it will not be
killed, though. Returns the name of the killed peer.\

<span style="font-family: monospace;">   kill\_all\_peers()-&gt;Bag of
Charstring</span>\
 Kills all peers. The name server and the current peer will still be
alive afterwards. Returns the names of the killed peers.\

<span style="font-family: monospace;">  
kill\_the\_federation()-&gt;Boolean </span>\
 Kills all the peers in the federation, including the name server and
the peer calling <span
style="font-style: italic;">kill\_the\_federation</span>.\

<span style="font-family: monospace;">   is\_running(Charstring 
peer)-&gt;Boolean</span>\
 Returns <span style="font-style: italic;">true</span> if peer is
listening.\

<span style="font-family: monospace;">   wait\_for\_peer(Charstring
peer)-&gt;Charstring</span>\
 Waits until the peer is running and then returns the peer name.

<span style="font-family: monospace;">   amos\_servers()-&gt;Bag of
Amos</span>\
 Returns all peers managed by the name server on this computer. You need
not be member of federation to run the function.

5.2 Peer queries and views\
---------------------------

Once you have established connections to Amos II peers you can define
views of data from your peers. You first have to import the meta-data
about selected types and functions from the peers. This is done by
defining *proxy types* and *proxy functions* [\[RJK03\]](#RJK03) using
the system function `import_types`:\

<span style="font-family: monospace;">   import\_types(Vector of
Charstring typenames,  Charstring p)-&gt; Bag of Type pt</span>\
 defines proxy types <span style="font-family: monospace;">pt</span> for
types named <span style="font-family: monospace;">typenames</span> in
peer <span style="font-family: monospace;">p</span>. Proxy functions are
defined for the functions in <span
style="font-family: monospace;">p</span> having the imported types as
only argument. Inheritance among defined proxy types  is imported
according to the corresponding  inheritance relationships between
imported types in the peer <span
style="font-family: monospace;">p</span>.\

Once the proxy types and functions are defined they can transparently be
queried. Proxy types can be references using <span
style="font-family: monospace;">@</span> notation to reference types in
other peers.\
 For example,\
 <span style="font-family: monospace;">   select name(p) from
Person@p1;</span>\
 selects the <span style="font-family: monospace;">name</span> property
of objects of type <span style="font-family:
          monospace;">Person</span> in peer <span style="font-family:
          monospace;">p1</span>.\

<span style="font-family: monospace;">import\_types</span> imports only
those functions having one of `typenames` as its single arguments. You
can import other functions using system function `import_func`:\

<span style="font-family: monospace;">   import\_func(Charstring fn,
Charstring p)-&gt;Function pf</span>\
 imports a function named <span
style="font-family: monospace;">fn</span> from peer <span
style="font-family: monospace;">p</span> returning proxy function <span
style="font-family: monospace;">pf</span>.\

On top of the imported types object-oriented multi-peer views can be
defined, as described in [\[RJK03\]](#RJK03) consisting of <span
style="font-style: italic;">derived types</span> [\[JR99a\]](#JR99a)
whose extents are derived through queries intersecting extents of other
types, and <span style="font-style: italic;">IUTs</span>
[\[JR99b\]](#JR99b) whose extents reconciles unions of other type
extents. Notice that the implementation of IUTs is limited. (In
particular the system flag <span
style="font-family: monospace;">latebinding('OR');</span> must be set
before IUTs can be used and this may cause other problems).\
