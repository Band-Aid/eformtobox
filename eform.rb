require 'sinatra'
require 'boxr'
require 'redis'

post '/file-upload' do
    @field2 = params[:field2]
    @field4 = params[:field4]
    @comments = params[:comments]
    @file = params[:file][:tempfile]
    @filename = params[:file][:filename]
    folderName = @field4
    atoken = env['accesstoken']
    

    client = Boxr::Client.new(atoken)
    filename = File.basename(@file)
    filePath = File.open("./tmp/#{filename}",'wb') 
    filePath.write(@file.read)
    #tmp_file.write(file.read)
    #tmp_file.close
    #open(filePath, 'wb') 
    begin 
    cfolder = client.create_folder("送り状＃" + folderName,0).id
    ufile = client.upload_file(filePath,cfolder,name: @filename )
    comment = client.add_comment_to_file(ufile.id,message: @comments)
    sharedURL = client.create_shared_link_for_folder(cfolder)
    File.delete(filePath)
    rescue Exception => e
        return e.message + @filename
    end
    
    redirect sharedURL.shared_link.url
end

get '/' do
    return erb :initwf
    
end
