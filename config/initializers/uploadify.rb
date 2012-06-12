Rails.application.config.middleware.insert_before(
  Rails.application.config.session_store,
  FlashSessionCookieMiddleware
)
