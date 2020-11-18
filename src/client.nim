##  client component of the chat application
import os, system, threadpool, asyncdispatch, asyncnet, protocol

proc connect(socket: AsyncSocket, serverAddr: string ) = 
  echo("connecting to ", serverAddr)
  await socket.connect(serverAddr, 7687.Port)
  echo("Connected!")

  while true:
    let line = socket.recvLine()
    let parsed = parseMessage(line)
    echo(parsed.username, " said ", parsed.message)

if paramCount()==0:
  quit ("Please specify the server address, e.g. ./client localhost")

let serverAddr=paramStr(1)
let socket = newAsyncSocket()


while true:
  let message = spawn stdin.readLine() 
  echo "Sending Message \"", ^ message, "\""
echo "hello"

