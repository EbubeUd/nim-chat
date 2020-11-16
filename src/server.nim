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

proc loop(server: Server, port= 7687) {.async.} =
  server.socket.bindAddr(Port(7687))
  server.socket.listen()
  # there should be a while true in here, removed out of curiousity 
  let (netAddr, clientSocket) = await server.socket.acceptAddr()
  echo "Accepted Connection from: ", netAddr
  let client = Client(
    socket: clientSocket,
    netAddr: netAddr,
    id: server.clients.len,
    connected: true
  )
  server.clients.add(client)

var server = newServer()
waitFor server.loop()

