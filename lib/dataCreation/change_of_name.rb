def create_marriage_data(country, full_name, title_number)
  marriage_data = {}
  marriage_data['confirm'] = true
  marriage_data['proprietor_full_name'] = full_name
  marriage_data['proprietor_new_full_name'] = fullName()
  marriage_data['partner_name'] = fullName()
  marriage_data['application_type'] = 'change-name-marriage'
  marriage_data['marriage_country'] = country
  marriage_data['marriage_place'] = townName()
  marriage_data['title_number'] = title_number
  marriage_data['proprietor_full_name'] = full_name
  marriage_data['marriage_certificate_number'] = certificateNumber()
  marriage_data['marriage_date'] = dateInThePast().strftime("%d-%m-%Y")

  if ($PERFROMANCETEST.nil?) then
    $function_call_name << 'create_marriage_data'
    $function_call_data << marriage_data
    $function_call_arguments << {}
    method(__method__).parameters.each do |key, value| $function_call_arguments[$function_call_arguments.count - 1][value.to_s] = decode_value(eval(value.to_s)) end
  end

  return marriage_data

end

def create_change_of_name_marriage_request(regData, marriage_data)

  marriage_data['marriage_date']  = Date.strptime(marriage_data['marriage_date'], "%d-%m-%Y").strftime("%s").to_i

  data = marriage_data
  data['confirm'] = true
  data['title'] = regData

  change_of_name = {}
  change_of_name["application_type"] = "change-name-marriage"
  change_of_name["title_number"]  = regData['title_number']
  change_of_name["submitted_by"] = regData['proprietors'][0]['full_name']
  change_of_name["request_details"] = {}
  change_of_name["request_details"]["action"] = "change-name-marriage"
  change_of_name["request_details"]["data"] = data.to_json
  change_of_name["request_details"]["context"] = {}
  change_of_name["request_details"]["context"]["session-id"] = "123456"
  change_of_name["request_details"]["context"]["transaction-id"] = "ABCDEFG"

  uri = URI.parse($CASES_URL)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new('/cases',  initheader = {'Content-Type' =>'application/json'})
  request.basic_auth $http_auth_name, $http_auth_password
  request.body = change_of_name.to_json
  response = http.request(request)

  change_of_name['case_id'] = JSON.parse(response.body)['id']

  if ($PERFROMANCETEST.nil?) then
    $function_call_name << 'create_change_of_name_marriage_request'
    $function_call_data << change_of_name
    $function_call_arguments << {}
    method(__method__).parameters.each do |key, value| $function_call_arguments[$function_call_arguments.count - 1][value.to_s] = decode_value(eval(value.to_s)) end
  end

  return change_of_name

end

def complete_case(case_id)

  uri = URI.parse($CASES_URL)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Put.new('/cases/complete/' + case_id)
  request.basic_auth $http_auth_name, $http_auth_password
  response = http.request(request)

  if (response.body != 'OK') then
    raise 'Error: ' + response.body
  end


  if ($PERFROMANCETEST.nil?) then
    $function_call_name << 'complete_case'
    $function_call_data << nil
    $function_call_arguments << {}
    method(__method__).parameters.each do |key, value| $function_call_arguments[$function_call_arguments.count - 1][value.to_s] = decode_value(eval(value.to_s)) end
  end
end