require 'mongrel'

class SimpleHandler < Mongrel::HttpHandler
   def process(request, response)
     response.start(200) do |head,out|
       head["Content-Type"] = "text/html"
       out.write("hello!\n")
     end
   end
end

h = Mongrel::HttpServer.new("184.106.172.44", "3000")
h.register("/test", SimpleHandler.new)
h.register("/files", Mongrel::DirHandler.new("."))
h.run.join