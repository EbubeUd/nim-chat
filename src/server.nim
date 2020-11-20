import 
  asyncdispatch,
  asyncnet

type
  Client = ref object 
    socket: AsyncSocket
    netAddr: string
    id: int
    connected: bool
  Server = ref object 
    socket: AsyncSocket
    clients: seq[Client]

proc newServer(): Server =
  Server(socket: newAsyncSocket(), clients: @[])

proc `$` (client: Client): string = 
  # creates the string representation of the client object
  $client.id & $ ": (" & client.netAddr & ")"


proc processMessages(server: Server, client: Client) {.async.} = 
  ## keeps listening to the client and sends its messages to other clients that are connected to the server
  while true:
    # wait for the client input
    let line = await client.socket.recvLine()
    # if the connection get disrupted then the client socket gets closed by sending an empty string
    if line.len == 0:
      client.socket.close()
      client.connected = false
      echo "Connection closed!"
      return
    # display the message on the server stdout
    echo (client, " sent: ", line)
    # send the message to all the other connected clients
    for c in server.clients:
      if c.id != client.id and c.connected:
        await c.socket.send(line & "\c\l")
    
    
proc loop(server: Server, port= 7687) {.async.} =
  ## sets up a server socket on the localhost on the given port number
  ## listens to the incoming requests on that socket
  ## each new connection is added as a client to the list of clients mainatined by the server
  ## and server listens to each connection incoming message
  server.socket.bindAddr(Port(7687))
  server.socket.listen()
  while true:
    let (netAddr, clientSocket) = await server.socket.acceptAddr()
    echo "Accepted Connection from: ", netAddr
    let client = Client(
      socket: clientSocket,
      netAddr: netAddr,
      id: server.clients.len,
      connected: true
    )
    # adds the new connection to the list of clients
    server.clients.add(client)
    echo server.clients.len
    # listens to the messages sent by the client and processes them
    asyncCheck processMessages(server, client)

var server = newServer()
waitFor server.loop()

