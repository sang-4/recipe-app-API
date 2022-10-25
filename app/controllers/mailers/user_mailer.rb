class UserMailer < ActionMailer::Base
    default :from => "myrecipe@gmail.com"

 def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.username} <#{user.email}>", :subject => "Registration Confirmation")
 end