class NotificationsController < ApplicationController

    def index
        if user_signed_in?
            @notifications = Notification.where(:receiver_id => current_user.id, :status => "Pending")
        end
        #@notifications = Notification.all
    end

    def show
    end

    def new
        @notification = Notification.new
        #@notification = current_user.notifications.build
    end

    def create
        @notification = notifications.build(notification_params)
        if @todo_list.save
            format.html { redirect_to todo_list_path, notice: 'Notification was successfully created.' }
        end
    end

    def destroy
        @notification.destroy
        redirect_to root_url, notice: 'Notification was successfully destroyed.'
    end

    def accepted
        @notification = Notification.find(params[:id])
        @notification.update_attribute(:status, "Attended")
        Sharedlist.create(id_list: @notification.todo_list, id_user: @notification.receiver_id)
        redirect_to notifications_path, notice: "List accepted."
    end

    def rejected
        @notification = Notification.find(params[:id])
        @notification.update_attribute(:status, "Attended")
        redirect_to notifications_path, notice: "List rejected."
    end

    private

    def notification_params
        params[:notification].permit(:status, :sender_id, :receiver_id, :todo_list)
    end
end
