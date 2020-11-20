##  client component of the chat application
import os, system,  asyncdispatch, asyncnet, protocol

proc connect(socket: AsyncSocket, serverAddr: string ) {.async.} = 
  echo("connecting to ", serverAddr)
  await socket.connect(serverAddr, 7687.Port)
  echo("Connected!")

  while true:
    let line = await socket.recvLine()
    let parsed = parseMessage(line)
    echo(parsed.username, " said ", parsed.message)


if paramCount()==0:
  quit ("Please specify the server address, e.g. ./client localhost")

let serverAddr=paramStr(1) # read the server address from command line input
var socket = newAsyncSocket() # create a socket to connect to the server

asyncCheck connect(socket, serverAddr) # connect to the server and start listening

let message = spawn await stdi.readLine() # use spawn to create a new thread
while true:
  echo ("sending \"", ^message , "\"") # message is of Future[T] type and can be accessed by ^ operator


