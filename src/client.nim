##  client component of the chat application
import os, system,  threadpool, asyncdispatch, asyncnet, protocol

proc connect(socket: AsyncSocket, serverAddr: string ) {.async.} = 
  echo("connecting to ", serverAddr)
  await socket.connect(serverAddr, 7687.Port)
  echo("Connected!")

  while true:
    let line = await socket.recvLine()
    let parsed = parseMessage(line)
    echo(parsed.username, " said ", parsed.message)


if paramCount()!=2:
  quit ("Please specify the server address, e.g. ./client localhost followed by your chat name")

let serverAddr = paramStr(1) # read the server address from command line input
let name = paramStr(2)#  get the user name for the chat application

var socket = newAsyncSocket() # create a socket to connect to the server
asyncCheck connect(socket, serverAddr) # connect to the server and start listening



var messageFlowVar = spawn stdin.readLine() # use spawn to create a new thread, message is of type Future holding the string returned by readLine
while true:
  if messageFlowVar.isReady():
    let message = CreateMessage(name, ^messageFlowVar)
    # echo ("sending \"", message , "\"") # message is of Future[T] type and can be accessed by ^ operator
    asyncCheck socket.send(message)
    messageFlowVar = spawn stdin.readLine()
  asyncdispatch.poll()


