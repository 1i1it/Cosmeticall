$quotes = $mongo.collection('quotes')

LOCATION_CHANGE_LEVEL_ONE   = 0.01
LOCATION_CHANGE_LEVEL_TWO   = 0.1
LOCATION_CHANGE_LEVEL_THREE = 1

get '/quotes/all' do
 quotes = $quotes.all
 {quotes:quotes}
end 

post '/create_quote_modal' do

		# find users around according to lat and long, + treatments + home visits
 		treatments = params['treatments'][0].present? ? params['treatments'].map! {|treatment| t(treatment) } : ["Any treatment"]
 		
 		buyer_phone = params['phone'] ? clean_params_phone : cu['phone'] 
 		day = params['day'].length < 1 ? Time.now.day.to_s : params['day']
 		month =  params['month'].length < 1 ? Time.now.month.to_s : params['month']
 		buyer_name =  $users.get(phone:buyer_phone) ? $users.get(phone:buyer_phone)["name"] : "Client"
 		sellers_sent_to = params[:sellers_sent_to]

 		# latitude =  params['latitude'].present? ? params['latitude'] : cu['latitude'].to_s
 		# longitude =  params['longitude'].present? ? params['longitude'] : cu['longitude'].to_s

 		quote  = $quotes.add({
		buyer_name:buyer_name, 
		buyer_phone: buyer_phone,
		sellers_sent_to: sellers_sent_to,
		month:month,
 		day:day,
 		time_around:params['time_around'],
		at_home:params['at_home'],
		# latitude:latitude.to_f,
		# longitude:longitude.to_f,
		area:params['area'],
		treatments:treatments,
		address: params['address'],
		answered_sellers:[]})

 		#address = params[:area]
		address = params[:address]

		general_text = create_text(buyer_name, 
					day, 
					month, 
					params[:time_around], 
					params[:at_home], 
					params[:treatments], 
					address)

		link = $root_url + "/answer_quote?_id=" + quote["_id"]
		text = "Hello! " + general_text + ". To answer, follow link " + link
		sellers_sent_to.each {|user| send_sms(user, text, "send_quote", buyer_phone)} 
		{quote:quote} 
end



post '/create_quote' do 
 		# find users around according to lat and long, + treatments + home visits
 		treatments = params['treatments'][0].present? ? params['treatments'].map! {|treatment| t(treatment) } : ["Any treatment"]
 		latitude =  params['latitude'].present? ? params['latitude'] : cu['latitude'].to_s
 		longitude =  params['longitude'].present? ? params['longitude'] : cu['longitude'].to_s
 		sellers_sent_to = get_users_around(latitude, longitude, treatments, params[:at_home])  
 		buyer_phone = params['phone'] ? clean_params_phone : cu['phone'] 
 		day = params['day'].length < 1 ? Time.now.day.to_s : params['day']
 		month =  params['month'].length < 1 ? Time.now.month.to_s : params['month']
 		buyer_name =  $users.get(phone:buyer_phone) ? $users.get(phone:buyer_phone)["name"] : "Client"
 		quote  = $quotes.add({
		buyer_name:buyer_name, 
		buyer_phone: buyer_phone,
		sellers_sent_to: sellers_sent_to,
		month:month,
 		day:day,
 		time_around:params['time_around'],
		at_home:params['at_home'],
		latitude:latitude.to_f,
		longitude:longitude.to_f,
		treatments:treatments,
		address:params['address'],
		answered_sellers:[]})

		general_text = create_text(buyer_name, 
					day, 
					month, 
					params[:time_around], 
					params[:at_home], 
					params[:treatments], 
					params[:address])

		link = $root_url + "/answer_quote?_id=" + quote["_id"]
		text = "Hello! " + general_text + ". To answer, follow link " + link
		 
		sellers_sent_to.each {|user| send_sms(user['phone'], text, "send_quote", buyer_phone)} 
		{quote:quote} 
end


get '/answer_quote' do
	quote_id = params[:_id]
	quote = $quotes.get(_id:quote_id)
	if !quote
		full_page_card(:"other/404")  
	else
		text = create_text(quote[:buyer_name], 
						   quote[:day], 
						   quote[:month], 
							quote[:around], 
							quote[:at_home], 
							quote[:treatments], 
							quote[:address])
		full_page_card(:"answer_quote", locals: {quote_id: params['_id'], text: text })
	end
end



get '/answer_seller' do
	# when seller sends answer to a quote, buyer gets link that forwards him to this page
	# here he can answer the seller

	quote_id = params[:_id]
	quote = $quotes.get(_id:quote_id)
	if !quote
		full_page_card(:"other/404")  
	else
		text = create_text(quote[:buyer_name], 
						   quote[:day], quote[:month], 
						   quote[:time_around], 
						   quote[:at_home], 
						   quote[:treatments], 
						   quote[:address])
	end

  	full_page_card(:"answer_seller", locals: {quote_id: params['_id'], text: text })
end

post '/answer_quote' do
	quote_id = params[:quote_id]
	quote = $quotes.get(_id:quote_id) 

  	seller_phone =  params['phone'] ? clean_params_phone : cu['phone']
  	sellers_sent_to = quote[:sellers_sent_to].map {|user| user[:phone] }
  	if seller_phone.in?(quote[:answered_sellers])
  		flash.message = t("already_answered_quote")
  		redirect "/"
  	else

		link = $root_url + "/answer_seller?_id=" + quote_id + "&seller_phone=" + seller_phone

		buyer_phone = quote[:buyer_phone] || "972549135125"
		if seller_phone.in?(sellers_sent_to)
					
			seller_name =  $users.get(phone:seller_phone)["name"]
			text = "Hi! #{seller_name} sent you following message: #{params[:description]}, he is offering price of #{params[:price]}. To answer, follow this link #{link}, or call #{seller_name} at #{seller_phone}"
			send_sms(buyer_phone, text, "answer_quote", seller_phone)

				$quotes.find_one_and_update({_id: params[:quote_id]}, {'$push' => {answered_sellers: seller_phone}})    

				flash.message = t("message_sent")
				redirect "/"

		else	
			url = $root_url + "/contact_us"
			
			# <a href="<=% url %>">support</a>

			flash.message = t("number_not_requested") + '<a href="' + url + '">' + t("support") + '</a>'
			# flash.message = "Your phone number was not requested by this user. Please talk to our " + '<a href="' + url + '">support</a>'
			redirect back
		end
	end
end

post '/answer_seller' do
	quote_id = params[:quote_id]
	quote = $quotes.get(_id:quote_id)

	seller_phone = params[:seller_phone] 
  	buyer_phone =  params[:phone] || cu[:phone]
  	buyer_name = quote[:buyer_name]
  	

  	#text = "Hi! #{buyer_name} sent you following message: #{params[:description]}. You can call #{buyer_name} at #{buyer_phone} to schedule a meeting!"
  	
  	text = t("hi") +  buyer_name +  t("sent_you_message") + " " + params[:description] + "."  + t("you_can_call") + " " +  buyer_name + "," + buyer_phone + " " +  t("to_schedule")

  	send_sms(seller_phone, text, "answer_seller", buyer_phone)
	flash.message = t("message_sent") 
	redirect "/"
end

def get_users_around_coordinates(lat, lng, offset, additional_params, home_visits)
	# searches by users around requested address that perform requested treatments
	 additional_params ||= {}
	 if home_visits == "true"
	 $users.find({ latitude: {"$gte": lat.to_f - offset, "$lte": lat.to_f + offset},
	 	longitude: {"$gte": lng.to_f - offset, 
		"$lte": lng.to_f + offset}, 
		treatments: {:$in=>additional_params},
		home_visits: home_visits}).to_a
	else
		$users.find({ latitude: {"$gte": lat.to_f - offset, "$lte": lat.to_f + offset},
	 	longitude: {"$gte": lng.to_f - offset, 
		"$lte": lng.to_f + offset}, 
		treatments: {:$in=>additional_params}}).to_a
	end

end


def get_users_around(lat, lng, additional_params, home_visits)
	items_level1, items_level2, items_level3 = [], [], []

	items_level1 = get_users_around_coordinates(lat, lng, LOCATION_CHANGE_LEVEL_ONE, additional_params, home_visits)

	if items_level1.size < 10
		items_level2 = get_users_around_coordinates(lat, lng, LOCATION_CHANGE_LEVEL_TWO, additional_params, home_visits)
	end

	if items_level2.size < 10
		items_level3 = get_users_around_coordinates(lat, lng, LOCATION_CHANGE_LEVEL_THREE, additional_params, home_visits)
	end

	items = (items_level1 + items_level2 + items_level3).uniq
	phones = items ? items.map {|item| item[:phone] } : nil
end


def create_text(buyer_name, day, month, time_around, at_home, treatments, address)	
	if day.length>0 && month.length>0

		day_month =  "on " + day + "/" + month + "/2016"
	else
		day_month = "any day,"
	end
		
	if time_around.length>0
		time_around = "around " + time_around 
	else
		time_around = "anytime"
	end
		
	if at_home == "true"
		at_home = "at #{address}"
	else
		at_home = "at your office"
	end
	treatments_list = (treatments || []).split(",").join(", ") 

	text = "#{buyer_name} wants #{treatments_list} #{at_home} #{day_month} #{time_around}"
	
end
