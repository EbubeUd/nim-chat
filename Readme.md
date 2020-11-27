
## Description
nim-chat is a small chat application that embodies three modules: client, server and protocol.

Run the server module by the following command. It compiles and executes a server on `localhost` on port `7687`. 

` nim c -r "src/server.nim"`

Then, you can run multiple instaces of a client to communicate and chat through the server. Here is the command, feel free to use your own username instead of `Alice`.

`nim c -r "src/client.nim" localhost Alice`

**Hint**: Make sure the server is running before attempting the client application.