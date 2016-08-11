get '/texts' do 
	redirect '/'
end


TREATMENTS = {
  manicure: ['manicure_sub_option_1', 'manicure_sub_option_2', 'manicure_sub_option_3', 'manicure_sub_option_4'],
  pedicure: ['pedicure_sub_option_1', 'pedicure_sub_option_2', 'pedicure_sub_option_3', 'pedicure_sub_option_4'],
  hair_treatment: ['hair_treatment_sub_option_1', 'hair_treatment_sub_option_2', 'hair_treatment_sub_option_3', 'hair_treatment_sub_option_4']
}

PROFESSIONS = ['Beautician','Cosmetician','Doctor', 'Hairdresser']
CITIES = ["tel_aviv", "haifa", "ashdod", "beer_sheva"]

TEXTS = {
	# search page
	treatment_type: {
		he: 'הצעת מחיר',
		en: 'Treatment Type'
	},

	treatment: {
		he: 'xxxx',
		en: 'Treatment'
	},

	
	area: {
		he: 'xxxx',
		en: 'Area'
	},

	home_visits: {
		he: 'xxxx',
		en: 'Home visits'
	},

	tel_aviv: {
		he: 'xxxx',
		en: 'Tel Aviv'
	},

	haifa: {
		he: 'xxxx',
		en: 'Haifa'
	},

	ashdod: {
		he: 'xxxx',
		en: 'Ashdod'
	},

	beer_sheva: {
		he: 'xxxx',
		en: 'Beer Sheva'
	},

#buttons
	# 		search: {
# 		he: 'xxxx',
# 		en: 'Search'
# 	},
# stuff

	found_users: {
		he: 'xxxx',
		en: 'Found users'
	},

	send_sms: {
		he: 'xxxx',
		en: 'Send sms'
	},

	
	#get_quote page
	get_quote: {
		he: 'הצעת מחיר',
		en: 'Get Quote'
	},


	my_phone_number: {
		he: 'xxxx',
		en: 'My Phone Number'
	},

	month: {
		he: 'xxxx',
		en: 'Month'
	},

	day: {
		he: 'xxxx',
		en: 'Day'
	},

	time_from: {
		he: 'xxxx',
		en: 'Time from'
	},

	time_to: {
		he: 'xxxx',
		en: 'Time to'
	},

		address: {
		he: 'xxxx',
		en: ''
	},

	treatment_at_home: {
		he: 'xxxx',
		en: 'Treatment at home'
	},

	any_treatment: {
		he: 'xxxx',
		en: 'Any treatment'
	},

	address: {
		he: 'xxxx',
		en: 'Address'
	},

#

# : {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 		: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},
# : {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 		: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},
# : {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 		: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},

# 	: {
# 		he: 'xxxx',
# 		en: ''
# 	},



	title: {
		he: 'תמצא קוסמטיקאית',
		en: 'Cosmeticall - Find The Best Cosmetician'
	},
	
	manicure: {
		he: 'xxxx',
		en: 'Manicure'
	},
	manicure_sub_option_1: {
		he: 'xxxx',
		en: 'mini-manicure'
	},
	manicure_sub_option_2: {
		he: 'xxxx',
		en: 'full manicure'
	},
	manicure_sub_option_3: {
		he: 'xxxx',
		en: 'polish'
	},
	manicure_sub_option_4: {
		he: 'xxxx',
		en: 'super full manicure'
	},
	pedicure: {
		he: 'xxxx',
		en: 'Pedicure'
	},
	pedicure_sub_option_1: {
		he: 'xxxx',
		en: 'mini-pedicure'
	},
	pedicure_sub_option_2: {
		he: 'xxxx',
		en: 'full pedicure'
	},
	pedicure_sub_option_3: {
		he: 'xxxx',
		en: 'polish'
	},
	pedicure_sub_option_4: {
		he: 'xxxx',
		en: 'super full pedicure'
	},
	hair_treatment: {
		he: 'xxxx',
		en: 'Hair Treatment'
	},
	hair_treatment_sub_option_1: {
		he: 'xxxx',
		en: 'haircut'
	},
	hair_treatment_sub_option_2: {
		he: 'xxxx',
		en: 'hair color'
	},
	hair_treatment_sub_option_3: {
		he: 'xxxx',
		en: 'blow dry'
	},
	hair_treatment_sub_option_4: {
		he: 'xxxx',
		en: 'super full hair treatment'
	},
}.hwia

DEFAULT_LANG = 'en'

def t(term, lang = DEFAULT_LANG)
	TEXTS[term][lang] rescue "missing definition for #{term}"
end


