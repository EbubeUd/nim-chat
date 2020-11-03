type
  Message* = object 
    username* : string
    messsage* : string

proc parseMessage(data: string): Message =
  discard