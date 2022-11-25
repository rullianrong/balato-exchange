class AdminConfirmationMailer < ApplicationMailer
    def confirmed(user)
        @user = user
        mail(to: user.email, subject: 'Signup Confirmation Status')
    end
end
