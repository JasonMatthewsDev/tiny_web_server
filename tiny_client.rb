require 'socket'
require 'json'

host = 'localhost'
port = 2000


input = ''
until input == 'g' || input == 'p'
  print "Which verb do you want to send? (g)et, (p)ost?"
  input = gets.chomp
end

if input == 'p'
  post = {}
  post[:viking] = {}
  print 'Name: '
  post[:viking][:name] = gets.chomp
  print 'Email: '
  post[:viking][:email] = gets.chomp
  json_post = post.to_json

  req = "POST /thanks.html HTTP/1.0\r\nContent-Length: #{json_post.length}\r\n\r\n#{json_post}"
else
  req = "GET /index.html HTTP/1.0\r\n\r\n"
end

socket = TCPSocket.open(host, port)
socket.print(req)
response = socket.read
headers, body = response.split("\r\n\r\n", 2)
puts body
socket.close
