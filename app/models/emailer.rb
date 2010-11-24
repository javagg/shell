class Emailer < ActionMailer::Base

  def signup_notification recipient
    #body['host'] = self.default_url_options[:host]
    recipients recipient.email
    bcc        []
    from       AppConfig['app_email']
    subject    "signup notification"
    body       :account => recipient
    send_on    Time.now
  end

  def welcome recipient
    #    body['host'] = self.default_url_options[:host]
    recipients recipient.email
    bcc        []
    from       AppConfig['app_email']
    subject    "Welcome"
    body       :account => recipient
    send_on    Time.now
  end

  def activation_instructions recipient
    #    body['host'] = self.default_url_options[:host]
    subject       "Activation Instructions"
    from          AppConfig['app_email']
    recipients    recipient.email
    sent_on       Time.now
    body          :account_activation_url => activate_url(recipient.perishable_token)
  end

  def welcome user
    #    body['host'] = self.default_url_options[:host]
    subject       "Welcome to the site!"
    from          AppConfig['app_email']
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end

  def password_reset_instructions recipient
    #    body['host'] = self.default_url_options[:host]
    recipients   recipient.email
    subject      "Password Reset"
    from         AppConfig['app_email']
    content_type "text/html"
    sent_on      Time.now
    body         :edit_password_reset_url => edit_password_reset_url(recipient.perishable_token)
  end

  def license_expiration_reminding license, remindee
    recipients   remindee.email
    subject      "license expiration"
    content_type "text/html"
    from         AppConfig['app_email']
    sent_on      Time.now
    body         :license => license
  end

  def contract_payment_reminding contract, remindee
    recipients   remindee.email
    subject      "contract payment"
    content_type "text/html"
    from         AppConfig['app_email']
    sent_on      Time.now
    body         :contract => contract
  end

  def email_testing to_address
    recipients   to_address
    subject      "System Test for Email Function"
    content_type "text/html"
    from         AppConfig['app_email']
    sent_on      Time.now
    body         :message => "Email function is ok!"
  end
end
