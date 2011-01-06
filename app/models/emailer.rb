class Emailer < ActionMailer::Base

  def activation_instructions recipient
    subject       "激活"
    from          AppConfig['app_email']
    recipients    recipient.email
    sent_on       Time.now
    body          :account_activation_url => activate_url(recipient.perishable_token)
  end

  def welcome user
    subject       "欢迎使用shell文件管理系统"
    from          AppConfig['app_email']
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end

  def password_reset_instructions recipient
    recipients   recipient.email
    subject      "密码重设"
    from         AppConfig['app_email']
    content_type "text/html"
    sent_on      Time.now
    body         :edit_password_reset_url => edit_password_reset_url(recipient.perishable_token)
  end

  def expiration_reminding expirable, remindee
    recipients   remindee.email
    subject      "过期提醒"
    content_type "text/html"
    from         AppConfig['app_email']
    sent_on      Time.now
    body         :expirable => expirable
  end

  def contract_payment_reminding contract, remindee
    recipients   remindee.email
    subject      "合同支付提醒"
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
