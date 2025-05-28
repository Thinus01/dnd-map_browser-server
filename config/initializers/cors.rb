Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'   # or 'http://localhost:3001' to lock it down
    resource '/api/*',
      headers: :any,
      methods: %i[get post put patch delete options]
  end
end
