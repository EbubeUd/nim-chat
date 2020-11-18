##  client component of the chat application
import os, system, threadpool, asyncdispatch, asyncnet

if paramCount()==0:
  quit ("Please specify the server address, e.g. ./client localhost")

let serverAddr=paramStr(1)
echo "connecting to ", serverAddr

while true:
  let message = spawn stdin.readLine() 
  echo "Sending Message \"", ^ message, "\""
echo "hello"