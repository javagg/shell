# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_shell_session',
  :secret      => '2c7192d889106a499ba4e29cc86730ba61e3485398cdc408833e27467d99d12a4425d1ebbb6ee5a0a047043e713ec1e963906ba96990ebd9d06f19711f942450'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
