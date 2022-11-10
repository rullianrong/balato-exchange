IEX::Api.configure do |config|
    config.publishable_token = 'pk_52521856dee54a2d8d998028f0ace4e0' # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
    config.secret_token = 'sk_6ce8a46036b0455b97a811239d50c7ad'
    config.endpoint = 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
end