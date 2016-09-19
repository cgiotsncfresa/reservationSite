json.array!(@reservations) do |reservation|
  json.extract! reservation, :id, :desk_id, :description, :reservation_date, :reservation_pm, :reservation_am
  json.url reservation_url(reservation, format: :json)
end
