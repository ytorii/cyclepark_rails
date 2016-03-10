json.array!(@seals) do |seal|
  json.extract! seal, :id, :contract_id, :month, :sealed_flag, :sealed_date, :staff_nickname
  json.url seal_url(seal, format: :json)
end
