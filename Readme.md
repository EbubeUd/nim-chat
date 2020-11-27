
## Description
nim-chat is a small chat application that embodies three modules: `client`, `server` and `protocol`. It allows multiple `client`s to chat with eachother through the `server`. The chat application transfers `Message`s  between clients in the form of  `JSON` objects; the `protocol` module takes care of creating and parsing `Message`s.


## How to build and run
The code is written in nim, so you need to have nim installed.

Run the server module by the following command. It compiles and executes a server on `localhost` on port `7687`. 

` nim c -r "src/server.nim"`

Then, you can run multiple instaces of a client to communicate and chat through the server. Here is the command, feel free to use your own username instead of `Alice`.

`nim c -r "src/client.nim" localhost Alice`

**Hint**: Make sure the server is running before attempting the client application.