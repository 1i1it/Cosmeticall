

post '/search_ajax' do
	#search by regex
	# sleep(0.3) if !$prod
	criteria = {}
	criteria[:name] = {"$regex" => Regexp.new(params[:name], Regexp::IGNORECASE) } if params[:name].present?
	criteria[:city] = params[:city] if params[:city].present?
	# criteria[:treatments]  = params[:treatments] if params[:treatments][0].present?
	bp
	criteria[:treatments]  = { '$in': params[:treatments] } if params[:treatments][0].present?
	criteria[:home_visits] = 'true' if (params[:home_visits].to_s == 'true')
	
	users       = $users.get_many(criteria).sample(50).sort_by {|u| u[:create_at]}
    users = users.each  { |user| 
      user['treatments']  = user["treatments"] || []
      user['treatments']  = user["treatments"].map! {|treatment| t(treatment) }
    	user["treatments"]  = user["treatments"].split(",").join(", ") 
      user['profession']  = t(user['profession'])
    	user["home_visits"] = t("performs_home_visits") if user["home_visits"]
    	users
    }

  {users:users}


end

get '/search' do
  erb :"search/search", default_layout 
end 
