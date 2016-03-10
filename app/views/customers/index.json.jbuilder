json.array!(@customers) do |customer|
  json.extract! customer, :id, :first_name, :last_name, :first_read, :last_read, :sex, :address, :phone_number, :cell_number, :receipt, :comment
  json.url customer_url(customer, format: :json)
end
