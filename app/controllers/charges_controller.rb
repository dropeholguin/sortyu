class ChargesController < ApplicationController
	before_filter :authenticate_user!

	def new
		@photo = Photo.find(params[:photo_id])
	end

	def create
	  # Amount in cents
	  @amount = 500

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
		
	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to new_charge_path
	end
end
