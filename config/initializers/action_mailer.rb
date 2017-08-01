Rails.application.config.action_mailer.delivery_method = :smtp

smtp_config = Rails.application.config_for("smtp")
smtp_user = smtp_config["user_name"]
smtp_pw = smtp_config["password"]
smtp_address = smtp_config["address"]
smtp_domain = smtp_config["domain"]
smtp_port = smtp_config["port"]
smtp_authentication = smtp_config["authentication"].to_s

Rails.application.config.action_mailer.smtp_settings = {
  :user_name => smtp_user,
  :password => smtp_pw,
  :address => smtp_address,
  :domain => smtp_domain,
  :port => smtp_port,
  :authentication => smtp_authentication
}
