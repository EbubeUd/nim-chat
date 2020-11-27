##  client component of the chat application
import os, system,  threadpool, asyncdispatch, asyncnet, protocol

proc connect(socket: AsyncSocket, serverAddr: string ) {.async.} = 
  echo("connecting to ", serverAddr)
  await socket.connect(serverAddr, 7687.Port) # connects to the server
  echo("Connected!")

  while true:
    let line = await socket.recvLine() # wait for the incoming messages
    let parsed = parseMessage(line) # converts the message string to a Message object
    echo(parsed.username, " said ", parsed.message)
   


if paramCount()!=2:
  quit ("Please specify the server address and the username, e.g. ./client localhost Alice")

let serverAddr = paramStr(1) # read the server address from command line input
let name = paramStr(2)#  get the username for the chat application

var socket = newAsyncSocket() # create a socket to connect to the server
asyncCheck connect(socket, serverAddr) # connect to the server and start listening


var messageFlowVar = spawn stdin.readLine() # use spawn to create a new thread, message is of type FlowVar[string] holding the string returned by readLine
while true:
  if messageFlowVar.isReady(): # once user types a message
    let message = CreateMessage(name, ^messageFlowVar) # creates the string representation of the message
    echo ("sending \"", message , "\"") # message is of FlowVar[T] type and can be accessed by ^ operator
    asyncCheck socket.send(message)
    messageFlowVar = spawn stdin.readLine() # keep waiting for the next user input
  asyncdispatch.poll()


