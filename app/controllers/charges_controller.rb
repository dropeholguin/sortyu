class ChargesController < ApplicationController
	before_filter :authenticate_user!

	def new
		if params[:photo_id].present?
			@photo = Photo.find(params[:photo_id])
			@price = Price.last.value
		elsif cookies[:pay_photos].present?
			@photos = []
			photo_ids_array = cookies[:pay_photos].split("-")
			photo_ids_array.each do | id_photo|
				@photos << Photo.find(id_photo.to_i)
			end
			@count = @photos.count
			@price = Price.last.value * @count
		end
	end

	def create
		@user = current_user
		# Amount in cents
		if params[:photo_id].present? && Photo.find(params[:photo_id]).state == "free"
			@amount =  Price.last.value
			customer = Stripe::Customer.create(
				email: 	params[:stripeEmail],
				source: params[:stripeToken]
			)

			charge = Stripe::Charge.create(
				customer:    	customer.id,
				amount:       Price.last.value_cents,
				description: 	'Rails Stripe customer',
				currency: 		'usd'
			)
			@photo = Photo.find(params[:photo_id])
			@photo.pay!
			
			if @user.affiliate_id.present?
				affiliate = Affiliate.find(@user.affiliate_id)
				balance = affiliate.balance
			
				affiliate.update_attributes(balance: balance + (@amount * 0.1))
			end
		elsif cookies[:pay_photos].present?
			@count = cookies[:pay_photos].split("-").count
			@amount =  Price.last.value * @count
			
			customer = Stripe::Customer.create(
				email: 	params[:stripeEmail],
				source: params[:stripeToken]
			)

			charge = Stripe::Charge.create(
				customer:    	customer.id,
				amount:       Price.last.value_cents,
				description: 	'Rails Stripe customer',
				currency: 		'usd'
			)

			photo_ids_array = cookies[:pay_photos].split("-")
			photo_ids_array.each do | id_photo|
				Photo.find(id_photo.to_i).pay!
			end

			if @user.affiliate_id.present?
				affiliate = Affiliate.find(affiliate_id)
				balance = affiliate.balance

				affiliate.update_attributes(balance: balance + (@amount * 0.1))
			end
		end
		
		rescue Stripe::CardError => e
		  flash[:error] = e.message
		  redirect_to new_charge_path
		
	end
end
