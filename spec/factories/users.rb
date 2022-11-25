FactoryBot.define do
  factory :user do
    email {'test@gmail.com'}
    password { 'password123' }
    confirmed_at { 1.day.ago }
    
    trait :admin do
      admin { true }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end 

  factory :admin_user, traits: [:admin]
  factory :unconfirmed_user, traits: [:unconfirmed]
end
