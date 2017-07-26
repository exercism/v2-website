Rails.application.config.action_mailer.delivery_method = :smtp

smtp_config = Rails.application.config_for("smtp")
smtp_user = smtp_config["user_name"]
smtp_pw = smtp_config["password"]
smtp_address = smtp_config["address"]
smtp_domain = smtp_config["domain"]
smtp_port = smtp_config["port"]

Rails.application.config.action_mailer.smtp_settings = {
  :user_name => '3213fc4e9a3f2d38',
  :password => '18efa7fa812f69',
  :address => 'smtp.mailtrap.io',
  :domain => 'smtp.mailtrap.io',
  :port => '2525',
  :authentication => :cram_md5
}
