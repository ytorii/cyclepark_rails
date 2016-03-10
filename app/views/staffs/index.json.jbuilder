json.array!(@staffs) do |staff|
  json.extract! staff, :id, :nickname, :password, :admin_flag
  json.url staff_url(staff, format: :json)
end
