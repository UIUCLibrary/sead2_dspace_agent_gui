json.array!(@deposits) do |deposit|
  json.extract! deposit, :id, :email, :title, :author, :creation_date, :project_url, :status, :state
  json.url deposit_url(deposit, format: :json)
end
