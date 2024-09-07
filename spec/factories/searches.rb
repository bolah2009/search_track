FactoryBot.define do
  factory :search do
    query { "test query" }
    ip_address { "127.0.0.1" }
    session_id { SecureRandom.uuid }
    complete { true }
  end
end
