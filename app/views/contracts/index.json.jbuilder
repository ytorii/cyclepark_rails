json.array!(@contracts) do |contract|
  json.extract! contract, :id, :leaf_id, :contract_date, :start_month, :term1, :money1, :term2, :money2, :new_flag, :skip_flag, :staff_nickname
  json.url contract_url(contract, format: :json)
end
