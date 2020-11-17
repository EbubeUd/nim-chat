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
  $client.id & $ "(" & client.netAddr & ")"


proc processMessages(server: Server, client: Client) {.async.} = 
  while true:
    let line = await client.socket.recvLine()
    if line.len == 0:
      client.socket.close()
      client.connected = false
      echo "Connection closed!"
      return
    echo (client, " sent: ", line)
    
    
proc loop(server: Server, port= 7687) {.async.} =
  server.socket.bindAddr(Port(7687))
  server.socket.listen()
  # there should be a while true in here, removed out of curiousity 
  while true:
    let (netAddr, clientSocket) = await server.socket.acceptAddr()
    echo "Accepted Connection from: ", netAddr
    let client = Client(
      socket: clientSocket,
      netAddr: netAddr,
      id: server.clients.len,
      connected: true
    )
    server.clients.add(client)
    echo server.clients.len
    asyncCheck processMessages(server, client)

var server = newServer()
waitFor server.loop()

