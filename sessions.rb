class SessionsController < BankingSystemController
    def new
    end

    def create
        user = User.find_by_username(params[:username])
        if user.save
            session[:user_id] = user.id
            flash[:success] = "Welcome"
            redirect_to root
        else
            render 'new'
        end
    end
    
    def destroy
        session[:user_id] = nil
        redirect_to root
        notice "Logged out!"
    end
end

