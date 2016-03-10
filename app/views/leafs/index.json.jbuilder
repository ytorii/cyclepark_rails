json.array!(@leafs) do |leaf|
  json.extract! leaf, :id, :number, :type, :student_flag, :largebike_flag, :valid_flag, :start_date, :last_date
  json.url leaf_url(leaf, format: :json)
end
