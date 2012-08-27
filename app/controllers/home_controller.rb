class HomeController < ActionController::Base
  
  def index   
    #Authentication using the AppID and Secret Key 
   	session[:oauth] = Koala::Facebook::OAuth.new('301394293301048', 'e6c22252eb9852393a59c5d667ffec2d', 'http://localhost:3000' + '/home/callback')
		@auth_url =  session[:oauth].url_for_oauth_code(:permissions=>"read_stream") 	
  end

	def callback
  	if params[:code]
  		# acknowledge code and get access token from FB
		  session[:access_token] = session[:oauth].get_access_token(params[:code])
		end		
		 # auth established, now do a graph call:
		
		@graph = Koala::Facebook::API.new(session[:access_token])
		begin	
		 #get the json for all status' 
		 @graph_status_list = @graph.get_object("me/statuses")
  	rescue Exception => e
  	  puts e.message
  	end  		
	end
end

