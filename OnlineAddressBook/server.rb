##
# This is a simple Web server, mainly for serving static content with some JavaScript
# in order to get started building a Web site.
#
# gpollice
##
#add the lib folder to the path
$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'sinatra'
require 'pgdb'
enable :sessions

set :public_folder, File.dirname(__FILE__) + '/public'
get '/' do
  session["cookie"] ||= nil
  erb :index
end

get '/register' do
  erb :register
end

 post '/signup' do
  username = params[:usernamesignup]
  password = params[:passwordsignup]
  password_confirm = params[:passwordsignup_confirm]
  usage = 0;
  conn = connectToDB(ENV['DATABASE_URL'])
  password_indb = "SELECT password FROM users_table WHERE username = '#{username}'"
  results = conn.exec(password_indb)
  if password_confirm == password
    if results.ntuples() !=0
      @message = "&nbsp;&nbsp;Username already exists!"
      erb :register
    else
      pass = "INSERT INTO users_table VALUES('#{params[:firstnamesignup]}','#{params[:lastnamesignup]}','#{username}','#{password}','#{params[:emailsignup]}','#{params[:year]}','#{params[:month]}','#{params[:day]}','#{params[:Gender]}','#{usage}')"
      result = conn.exec(pass)
      session["cookie"] = username
      time = Time.now.hour
      if time >=12 && time < 18
        @greeting="Good afternoon,"
      elsif time >=6 && time <12
        @greeting="Good morning,"
      else
        @greeting="It's sleep time,"
      end
      gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
      gender_result = conn.exec(gender)
      if gender_result.getvalue(0,0).eql? "male"
        @call = "Mr.&nbsp;"
      else
        @call = "Mrs.&nbsp;"
      end
      lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
      lname_result = conn.exec(lname)
      if lname_result.getvalue(0,0).eql? ""
        @name = "Foo"
      else
        @name = lname_result.getvalue(0,0)
      end
      usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
    phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
    email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
    msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
    gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
    name_array_result= conn.exec(name_array)
    phone_array_result= conn.exec(phone_array)
    email_array_result= conn.exec(email_array)
    msn_array_result= conn.exec(msn_array)
    gender_array_result= conn.exec(gender_array)
    $i = 0;
    @contactCode=""
    while $i < usg_value.to_i do
      @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
      $i += 1
    end
    end
      erb :home
    end
  else
    @message = "&nbsp;&nbsp;Try again. Two passwords are not the same."
    erb :register
  end
end

post '/login' do
  username = params[:username]
  password = params[:password]
  conn = connectToDB(ENV['DATABASE_URL'])
  password_indb = "SELECT password FROM users_table WHERE username = '#{username}'"
  results = conn.exec(password_indb)
  if results.ntuples() == 0
    @message = "Try again. User doesn't exist!"
    erb :index
  elsif results.getvalue(0,0) == password
    session["cookie"] = username
    time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
    name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
    phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
    email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
    msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
    gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
    name_array_result= conn.exec(name_array)
    phone_array_result= conn.exec(phone_array)
    email_array_result= conn.exec(email_array)
    msn_array_result= conn.exec(msn_array)
    gender_array_result= conn.exec(gender_array)
    $i = 0;
    @contactCode=""
    while $i < usg_value.to_i do
      @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
      $i += 1
    end
    end
    erb :home
  else
    @message = "Try again. Password incorrest"
    erb :index
  end

end

get '/changeprofile' do
  if session["cookie"] == nil
    erb :index
    # should be somewhere else
  else
    username = session["cookie"]
    @usr = username
    conn = connectToDB(ENV['DATABASE_URL'])
    firstname = "SELECT firstname FROM users_table WHERE username = '#{username}'"
    firstname_result = conn.exec(firstname)
    if !firstname_result.getvalue(0,0).eql? "na"
      @firstname = firstname_result.getvalue(0,0)
    end
    lastname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lastname_result = conn.exec(lastname)
    if !lastname_result.getvalue(0,0).eql? "na"
      @lastname = lastname_result.getvalue(0,0)
    end
    email = "SELECT email FROM users_table WHERE username = '#{username}'"
    email_result = conn.exec(email)
    if !email_result.getvalue(0,0).eql? "na"
      @email = email_result.getvalue(0,0)
    end
    month = "SELECT month FROM users_table WHERE username = '#{username}'"
    month_result = conn.exec(month)
    if !month_result.getvalue(0,0).eql? "na"
      monthNum = month_result.getvalue(0,0)
      if monthNum.eql? "1"
        @jan = "selected"
      elsif monthNum.eql? "2"
        @feb = "selected"
      elsif monthNum.eql? "3"
        @mar = "selected"
      elsif monthNum.eql? "4"
        @apr = "selected"
      elsif monthNum.eql? "5"
        @may = "selected"
      elsif monthNum.eql? "6"
        @jun = "selected"
      elsif monthNum.eql? "7"
        @jul = "selected"
      elsif monthNum.eql? "8"
        @aug = "selected"
      elsif monthNum.eql? "9"
        @sep = "selected"
      elsif monthNum.eql? "10"
        @oct = "selected"
      elsif monthNum.eql? "11"
        @nov = "selected"
      elsif monthNum.eql? "12"
        @dec = "selected"
      end
    end
    day = "SELECT day FROM users_table WHERE username = '#{username}'"
    day_result = conn.exec(day)
    if !day_result.getvalue(0,0).eql? "na"
      @day = day_result.getvalue(0,0)
      @dayselected = "selected"
    end
    year = "SELECT year FROM users_table WHERE username = '#{username}'"
    year_result = conn.exec(year)
    if !year_result.getvalue(0,0).eql? "na"
      @year = year_result.getvalue(0,0)
      @yearselected = "selected"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if !gender_result.getvalue(0,0).eql? "na"
      if gender_result.getvalue(0,0).eql? "male"
        @male = "selected"
      elsif gender_result.getvalue(0,0).eql? "female"
        @female = "selected"
      end
    end
    erb :update
  end
end

post '/saveprofileupdate' do
  username = session["cookie"]
  conn = connectToDB(ENV['DATABASE_URL'])
  pass = "UPDATE users_table SET firstname = '#{params[:firstnamesignup]}', lastname = '#{params[:lastnamesignup]}', email = '#{params[:emailsignup]}', year = '#{params[:year]}', month = '#{params[:month]}', day = '#{params[:day]}', gender = '#{params[:Gender]}' WHERE username = '#{username}'"
  result = conn.exec(pass)
  
  time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
    phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
    email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
    msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
    gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
    name_array_result= conn.exec(name_array)
    phone_array_result= conn.exec(phone_array)
    email_array_result= conn.exec(email_array)
    msn_array_result= conn.exec(msn_array)
    gender_array_result= conn.exec(gender_array)
    $i = 0;
    @contactCode=""
    while $i < usg_value.to_i do
      @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
      $i += 1
    end
    end
    erb :home
end

post '/changepasswordupdate' do
  username = session["cookie"]
  password = params[:oldpassword]
  newpassword = params[:passwordsignup]
  newpassword_confirm = params[:passwordsignup_confirm]
  conn = connectToDB(ENV['DATABASE_URL'])
  password_indb = "SELECT password FROM users_table WHERE username = '#{username}'"
  results = conn.exec(password_indb)
  if results.getvalue(0,0) != password
    @message = "Incorrect old password!"
    erb :update
  elsif newpassword != newpassword_confirm
    @message = "New passwords are not the same!"
    erb :update
  else 
    pass = "UPDATE users_table SET password = '#{newpassword}' WHERE username = '#{username}'"
    result = conn.exec(pass)
    time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
    phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
    email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
    msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
    gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
    name_array_result= conn.exec(name_array)
    phone_array_result= conn.exec(phone_array)
    email_array_result= conn.exec(email_array)
    msn_array_result= conn.exec(msn_array)
    gender_array_result= conn.exec(gender_array)
    $i = 0;
    @contactCode=""
    while $i < usg_value.to_i do
      @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
      $i += 1
    end
    end
    erb :home
  end
end

 post '/addcontact' do
  username = session["cookie"]
  name = params[:name]
  phonenum = params[:phonenum]
  email = params[:email]
  msn = params[:msn]
  gender = params[:Gender]
  conn = connectToDB(ENV['DATABASE_URL'])
  check_name ="SELECT phonenum FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
  check_result = conn.exec(check_name)
  if check_result.ntuples() !=0
    time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
      phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
      email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
      msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
      gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
      name_array_result= conn.exec(name_array)
      phone_array_result= conn.exec(phone_array)
      email_array_result= conn.exec(email_array)
      msn_array_result= conn.exec(msn_array)
      gender_array_result= conn.exec(gender_array)
      $i = 0;
      @contactCode=""
      while $i < usg_value.to_i do
        @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
        $i += 1
      end
    end
    @createResult = "Name already exists!"
    erb :home
  else
    usage = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usage_result = conn.exec(usage)
    newusg = usage_result.getvalue(0,0).to_i + 1
    updateusg = "UPDATE users_table SET usage = '#{newusg}' WHERE username = '#{username}'"
    result = conn.exec(updateusg)

    create = "INSERT INTO contacts_table VALUES('#{username}','#{name}','#{phonenum}','#{email}','#{msn}','#{gender}')"
    result = conn.exec(create)

    time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
      phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
      email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
      msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
      gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
      name_array_result= conn.exec(name_array)
      phone_array_result= conn.exec(phone_array)
      email_array_result= conn.exec(email_array)
      msn_array_result= conn.exec(msn_array)
      gender_array_result= conn.exec(gender_array)
      $i = 0;
      @contactCode=""
      while $i < usg_value.to_i do
        @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
        $i += 1
      end
    end
    erb :home
  end
end

post '/searchcontact' do
  username = session["cookie"]
  name = params[:contactname]
  conn = connectToDB(ENV['DATABASE_URL'])
  check_name ="SELECT phonenum FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
  check_result = conn.exec(check_name)
  if check_result.ntuples() == 0
    time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
      phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
      email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
      msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
      gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
      name_array_result= conn.exec(name_array)
      phone_array_result= conn.exec(phone_array)
      email_array_result= conn.exec(email_array)
      msn_array_result= conn.exec(msn_array)
      gender_array_result= conn.exec(gender_array)
      $i = 0;
      @contactCode=""
      while $i < usg_value.to_i do
        @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
        $i += 1
      end
    end
    @searchResult = "Name does not exist!"
    erb :home
  else  
    time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
      email_array = "SELECT email FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
      msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
      gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
      phone_array_result= conn.exec(phone_array)
      email_array_result= conn.exec(email_array)
      msn_array_result= conn.exec(msn_array)
      gender_array_result= conn.exec(gender_array)
      @contactCode=""
        @contactCode += "<tr class='solid'><td class='solid'>" + name + "</td>"
        @contactCode += "<td class='solid'>" + gender_array_result.getvalue(0,0) + "</td>"
        @contactCode += "<td class='solid'>" + phone_array_result.getvalue(0,0) + "</td>"
        @contactCode += "<td class='solid'>" + email_array_result.getvalue(0,0) + "</td>"
        @contactCode += "<td class='solid'>" + msn_array_result.getvalue(0,0) + "</td></tr>"
    end
    @buttonCode = "
      <form action='return' method='get'>
        <span style='float: right;'><button type='submit'>Return to all contacts</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          </span>
      </form>"
    erb :home
  end
end

get '/return' do
  username = session["cookie"]
  conn = connectToDB(ENV['DATABASE_URL'])
  time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
      phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
      email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
      msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
      gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
      name_array_result= conn.exec(name_array)
      phone_array_result= conn.exec(phone_array)
      email_array_result= conn.exec(email_array)
      msn_array_result= conn.exec(msn_array)
      gender_array_result= conn.exec(gender_array)
      $i = 0;
      @contactCode=""
      while $i < usg_value.to_i do
        @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
        $i += 1
      end
    end
    erb :home
end

post '/editcontact' do
  username = session["cookie"]
  name = params[:contactname]
  conn = connectToDB(ENV['DATABASE_URL'])
  check_name ="SELECT phonenum FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
  check_result = conn.exec(check_name)
  if check_result.ntuples() == 0
    time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
      phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
      email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
      msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
      gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
      name_array_result= conn.exec(name_array)
      phone_array_result= conn.exec(phone_array)
      email_array_result= conn.exec(email_array)
      msn_array_result= conn.exec(msn_array)
      gender_array_result= conn.exec(gender_array)
      $i = 0;
      @contactCode=""
      while $i < usg_value.to_i do
        @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
        $i += 1
      end
    end
    @editResult = "Name does not exist!"
    erb :home
  else  
    time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
      email_array = "SELECT email FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
      msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
      gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
      phone_array_result= conn.exec(phone_array)
      email_array_result= conn.exec(email_array)
      msn_array_result= conn.exec(msn_array)
      gender_array_result= conn.exec(gender_array)
      @contactCode=""
        @contactCode += "<tr class='solid'><td class='solid'>" + name + "</td>"
        @contactCode += "<td class='solid'>" + gender_array_result.getvalue(0,0) + "</td>"
        @contactCode += "<td class='solid'>" + phone_array_result.getvalue(0,0) + "</td>"
        @contactCode += "<td class='solid'>" + email_array_result.getvalue(0,0) + "</td>"
        @contactCode += "<td class='solid'>" + msn_array_result.getvalue(0,0) + "</td></tr>"
    end
    phone = phone_array_result.getvalue(0,0)
    email = email_array_result.getvalue(0,0)
    msn = msn_array_result.getvalue(0,0)
    if gender_array_result.getvalue(0,0).eql? "male"
      maleselected = "selected"
      femaleselected = ""
    else
      femaleselected = "selected"
      maleselected = ""
    end
    @buttonCode = "
      <form action='saveeditchange' method='post'>
        <center><p>
          <label for='lname' data-icon='u'><span class='red'>*</span>Name:&nbsp;&nbsp;&nbsp;</label>
          <input size='20' maxlength='10' id='lname' name='lname'type='text' required='required' placeholder='Name' readonly value ='"+name+"' />
                </p>
                <p>
          <label for='phonenum' data-icon='u'><span class='red'>*</span>Cal:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;</label>
          <input size='20' maxlength='10' id='phonenum' name='phonenum'type='text' required='required' placeholder='Phone number' value ='" + phone +"'/>
                </p>
                <p>
          <label for='email' data-icon='u'>&nbsp;&nbsp;Email:&nbsp;&nbsp;&nbsp;</label>
          <input size='20' maxlength='20'id='email' name='email'type='email' placeholder='sample@domin.com' value ='"+email+"'/>
                </p>
                <p>
          <label for='msn' data-icon='u'>&nbsp;&nbsp;MSN:&nbsp;&nbsp;&nbsp;&nbsp;</label>
          <input size='20' maxlength='10' id='msn' name='msn' placeholder='MSN' value ='"+msn+"'/>
                </p>
                <p>
          <label for='gender'>&nbsp;&nbsp;Gender:</label>
          <select name='Gender'>
                    <option value='male' "+maleselected+">Male</option>
                    <option value='female' "+femaleselected+">Female</option>
                    </select>
                </p></center>
        <span style='float: right;'><button type='submit'>Save change</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;</span>
      </form>
      <br /><br />
      <form action='deletecontact' method='get'>
        <span style='float: right;'><button type='submit'  style='color: #FF1919;'>Delete this contact</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;</span>
      </form>
      <br /><br />
      <form action='return' method='get'>
        <span style='float: right;'><button type='submit'>Return to all contacts</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;</span>
      </form>
      "
      session["name"] = params[:contactname]
    erb :home
  end
end

 post '/saveeditchange' do
  username = session["cookie"]
  name = params[:lname]
  phonenum = params[:phonenum]
  email = params[:email]
  msn = params[:msn]
  gender = params[:Gender]
  conn = connectToDB(ENV['DATABASE_URL'])
  update = "UPDATE contacts_table SET phonenum = '#{phonenum}', email = '#{email}', msn = '#{msn}', gender = '#{gender}' WHERE username = '#{username}' AND name = '#{name}'"
  update_result = conn.exec(update)

  time = Time.now.hour
  if time >=12 && time < 18
    @greeting="Good afternoon,"
  elsif time >=6 && time <12
    @greeting="Good morning,"
  else
    @greeting="It's sleep time,"
  end
  gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
  gender_result = conn.exec(gender)
  if gender_result.getvalue(0,0).eql? "male"
    @call = "Mr.&nbsp;"
  else
    @call = "Mrs.&nbsp;"
  end
  lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
  lname_result = conn.exec(lname)
  if lname_result.getvalue(0,0).eql? ""
    @name = "Foo"
  else
    @name = lname_result.getvalue(0,0)
  end
  usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
  usg_result = conn.exec(usg)
  usg_value = usg_result.getvalue(0,0)
  if usg_value.eql? "1" or usg_value.eql? "0"
    @usageMsg = usg_value + " contact"
  else
    @usageMsg = usg_value + " contacts"
  end
  if !usg_value.eql? "0"
    name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
    phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
    email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
    msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
    gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
    name_array_result= conn.exec(name_array)
    phone_array_result= conn.exec(phone_array)
    email_array_result= conn.exec(email_array)
    msn_array_result= conn.exec(msn_array)
    gender_array_result= conn.exec(gender_array)
    $i = 0;
    @contactCode=""
    while $i < usg_value.to_i do
      @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
      @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
      $i += 1
    end
  end
  erb :home
end

get '/deletecontact' do
  name = session["name"]
  username = session["cookie"]
  conn = connectToDB(ENV['DATABASE_URL'])
  update = "DELETE FROM contacts_table WHERE username = '#{username}' AND name = '#{name}'"
  update_result = conn.exec(update)
  usage = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usage_result = conn.exec(usage)
    newusg = usage_result.getvalue(0,0).to_i - 1
    updateusg = "UPDATE users_table SET usage = '#{newusg}' WHERE username = '#{username}'"
    result = conn.exec(updateusg)

    time = Time.now.hour
    if time >=12 && time < 18
      @greeting="Good afternoon,"
    elsif time >=6 && time <12
      @greeting="Good morning,"
    else
      @greeting="It's sleep time,"
    end
    gender = "SELECT gender FROM users_table WHERE username = '#{username}'"
    gender_result = conn.exec(gender)
    if gender_result.getvalue(0,0).eql? "male"
      @call = "Mr.&nbsp;"
    else
      @call = "Mrs.&nbsp;"
    end
    lname = "SELECT lastname FROM users_table WHERE username = '#{username}'"
    lname_result = conn.exec(lname)
    if lname_result.getvalue(0,0).eql? ""
      @name = "Foo"
    else
      @name = lname_result.getvalue(0,0)
    end
    usg = "SELECT usage FROM users_table WHERE username = '#{username}'"
    usg_result = conn.exec(usg)
    usg_value = usg_result.getvalue(0,0)
    if usg_value.eql? "1" or usg_value.eql? "0"
      @usageMsg = usg_value + " contact"
    else
      @usageMsg = usg_value + " contacts"
    end
    if !usg_value.eql? "0"
      name_array = "SELECT name FROM contacts_table WHERE username = '#{username}'"
      phone_array = "SELECT phonenum FROM contacts_table WHERE username = '#{username}'"
      email_array = "SELECT email FROM contacts_table WHERE username = '#{username}'"
      msn_array = "SELECT msn FROM contacts_table WHERE username = '#{username}'"
      gender_array = "SELECT gender FROM contacts_table WHERE username = '#{username}'"
      name_array_result= conn.exec(name_array)
      phone_array_result= conn.exec(phone_array)
      email_array_result= conn.exec(email_array)
      msn_array_result= conn.exec(msn_array)
      gender_array_result= conn.exec(gender_array)
      $i = 0;
      @contactCode=""
      while $i < usg_value.to_i do
        @contactCode += "<tr class='solid'><td class='solid'>" + name_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + gender_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + phone_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + email_array_result.getvalue($i,0) + "</td>"
        @contactCode += "<td class='solid'>" + msn_array_result.getvalue($i,0) + "</td></tr>"
        $i += 1
      end
    end
    erb :home
end

get '/exit' do
  session["cookie"] = nil
  erb :index
end

# this route tests the database connection
get '/test_db' do
  testDBConnection(ENV['DATABASE_URL'])
end
# this route displays the SQL input form
get '/db_manager' do
  runDBShell(ENV['DATABASE_URL'])
end
# this route receives input from the SQL input form
post '/db_manager' do
  runDBShell(ENV['DATABASE_URL'], params)
end

get '/env' do
   ENV
end

get '*' do
  "Path: " + request.fullpath()
end
