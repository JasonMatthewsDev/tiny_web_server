require 'socket'
require 'json'

server = TCPServer.open(2000)

loop do
  client = server.accept
  request = client.read_nonblock(256)

  req_header, req_body = request.split("\r\n\r\n", 2)
  file = req_header.split[1][1..-1]
  verb = req_header.split[0]

  if File.exist?(file)
    body = File.read(file)
    client.puts "HTTP/1.1 200 OK\r\nContent-type:text/html\r\n\r\n"
    if verb == 'GET'
      client.puts body
    elsif verb == 'POST'
      post = JSON.parse(req_body)
      client.puts body.gsub('<%= yield %>', "<li>name: #{post['viking']['name']}</li><li>e-mail: #{post['viking']['email']}</li>")
    end
  else
    client.puts "HTTP/1.1 404 Not Found\r\n\r\n404 Error, You did it wrong."
  end
  client.close
end
