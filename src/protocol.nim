import json
type
 Message* = object
  username*: string
  message*: string

proc parseMessage(data: string): Message =
 let dataJson = parseJson(data) #returns a JsonNode
 result.username = dataJson["username"].getStr()
 result.message = dataJson["message"].getStr()

proc CreateMessage(username, message: string): string =
  let temp = %{"username": %username, "message": %message}
  result = $temp

when isMainModule:
  block:
    let data = """{ "username": "Dominik", "message":"What did you do for the weekend?" } """
    let msg = parseMessage(data)
    assert msg.message == "What did you do for the weekend?"
    doAssert msg.username == "Dominik"
  block:
    let data = "invalid json"
    try:
      let msg = parseMessage(data)
      doAssert false
    except JsonParsingError:
      doAssert true
    except:
      doAssert false
  
    
    

