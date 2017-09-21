require './config/environment'

class ApplicationController < Sinatra::Base
	use Rack::Flash
	configure do
		set :public_folder, 'public'
		set :views, 'app/views'
		enable :sessions
		set :session_secret, "auction_call"
	end

	helpers do
		def current_user
	      @current_user ||= User.find_by(id: session[:id])
	    end

	    def logged_in?
	      !!current_user
	    end

	    def user_exists?(params)
	    	User.exists?(email: params["email"])
	    end

	    def authorize_user(params)
	    	User.find_by(:username => params[:username]).try(:authenticate, params[:password])
	    end

	    # Escapes HTML Code if embedded in content submitted.
	    def h(string)
  			Rack::Utils.escape_html(string)
		end

		def get_error_msgs(params)
			error_msgs = []
			auction = Auction.new(params["auction"])
			auctioneer = Auctioneer.new(params["auctioneer"])	
			if auction.invalid? || (auctioneer.invalid? && !params["auctioneer"]["name"].empty?)
				error_msgs << auction.errors.full_messages	if auction.invalid?
				error_msgs << auctioneer.errors.full_messages if auctioneer.invalid? 				
			end	

			error_msgs
		end

		def get_auctioneer_error_msgs(params)
			error_msgs = []
			a = Auctioneer.new(params["auctioneer"])
			unless a.valid?
				error_msgs = a.errors.full_messages
			end
			error_msgs
		end

	end
end