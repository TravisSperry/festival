if Rails.env.production?
  Stripe.api_key = ENV['STRIPE_API_KEY']
  STRIPE_PUBLIC_KEY = ENV['STRIPE_PUB_KEY']
else
  Stripe.api_key = "sk_test_GmlILZBDjmVQdF4ywsG6rjHG"
  STRIPE_PUBLIC_KEY = "pk_test_GaO03iFegnH0RU0MJwqdRuBe"
end
