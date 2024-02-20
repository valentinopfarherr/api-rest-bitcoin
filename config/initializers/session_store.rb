# frozen_string_literal: true

Rails.application.config.session_store :cookie_store, key: '_api_rest_bitcoin_session', expire_after: 1.hour
