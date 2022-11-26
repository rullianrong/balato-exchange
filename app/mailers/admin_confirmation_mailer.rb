class AdminConfirmationMailer < ApplicationMailer
    def confirmed(user)
        @user = user
        mail(to: user.email, subject: 'Signup Confirmation Status')
    end

    def signed_up(user)
        @user = user
        mail(to: user.email, subject: 'New Account Created')
    end
end
