class Api::V1::SubscriptionsController < ApplicationController

    def subscription_params
        params.require(:subscription).permit(:email, :token, :sessionId)
    end

    def create
        
        subscription = Subscription.new(subscription_params)

        if subscription.save
            render json: {
                status: 'success',
                message: 'user subscription was successfully',
                data: subscription
            }, status: :ok
        else
            render json: {
                status: 'failed',
                message: 'user subscription fails',
                data: subscription.errors
            }, status: :unprocessable_entity
        end
    end

    def sendPush

        require 'fcm'
        fcm = FCM.new("AAAASJSS5qI:APA91bENMoQWeJchpLxULGYztQBGh4B1y5ilJH2HXp7VJzxG2OzKQsDQddbxRHBM6pVK6O_oX7FbRpZFBpDi8VBJzhU0F5t6fln64E6G-zJdPolBxxYFxr5S7L0ePIves1q8wCBp4ie0")
        registration_ids = []

        Subscription.where(email: params[:emails]).each do |subscription|
            registration_ids.push(subscription[:token])
        end

        options = { 
            priority: 'high',
            data: { 
                message: params[:message], 
                icon: 'image.png' 
            }, 
            notification: { 
                body: params[:message],
                title: params[:title],
                sound: 'default',
                icon: 'image.png'
            }
        }

        response = fcm.send(registration_ids, options)

        if response[:status_code] === 200
            render json: {
                status: 'success',
                message: 'user notification was send successfully',
                data: response
            }, status: :ok
        else
            render json: {
                status: 'failed',
                message: 'user notification was not sent',
                data: response
            }, status: :unprocessable_entity
        end

    end

end
