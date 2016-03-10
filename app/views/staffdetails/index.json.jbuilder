json.array!(@staffdetails) do |staffdetail|
  json.extract! staffdetail, :id, :staff_id, :name, :read, :address, :birthday, :phone_number, :cell_number
  json.url staffdetail_url(staffdetail, format: :json)
end
