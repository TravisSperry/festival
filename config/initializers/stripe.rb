if Rails.env.production?
  Stripe.api_key = ENV['STRIPE_API_KEY']
  STRIPE_PUBLIC_KEY = ENV['STRIPE_PUB_KEY']
else
  Stripe.api_key = ENV['STRIPE_API_KEY']
  STRIPE_PUBLIC_KEY = ENV['STRIPE_PUB_KEY']
end
