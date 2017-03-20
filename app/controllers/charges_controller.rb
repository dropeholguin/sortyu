class ChargesController < ApplicationController
	before_filter :authenticate_user!

	def new
		@photo = Photo.find(params[:photo_id])
	end

	def create
		# Amount in cents
		@amount =  Price.last.value_cents
		@photo = Photo.find(params[:photo_id])

		customer = Stripe::Customer.create(
			email: 	params[:stripeEmail],
			source: params[:stripeToken]
		)

		charge = Stripe::Charge.create(
			customer:    	customer.id,
			amount:       @amount,
			description: 	'Rails Stripe customer',
			currency: 		'usd'
		)
	  	@photo.pay!
	  	@user = User.find(@photo.user)
	  	if !@user.affiliate.nil?
	  		@affiliate = Affiliate.find(@user.affiliate_id)
	  		@affiliate.update_attributes(balance: @amount * 0.1)
	  	end
		rescue Stripe::CardError => e
		  flash[:error] = e.message
		  redirect_to new_charge_path
		
	end
end
