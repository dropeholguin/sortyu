class ChargesController < ApplicationController
	before_filter :authenticate_user!

	def new
		if params[:photo_id].present?
			@photo = Photo.find(params[:photo_id])
			@price = Price.last.value_cents
		elsif cookies[:pay_photos].present?
			@photos = []
			photo_ids_array = cookies[:pay_photos].split("-")
			photo_ids_array.each do | id_photo|
				@photos << Photo.find(id_photo.to_i)
			end
			@count = @photos.count
			@price = Price.last.value_cents * @count
		end
	end

	def create
		# Amount in cents
		if params[:photo_id].present? && Photo.find(params[:photo_id]).state == "free"
			@amount =  Price.last.value_cents
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
			@photo = Photo.find(params[:photo_id])
			@photo.pay!
			
		elsif cookies[:pay_photos].present?
			@count = cookies[:pay_photos].split("-").count
			@amount =  Price.last.value_cents * @count
			
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

			photo_ids_array = cookies[:pay_photos].split("-")
			photo_ids_array.each do | id_photo|
				Photo.find(id_photo.to_i).pay!
			end
		end
		
		rescue Stripe::CardError => e
		  flash[:error] = e.message
		  redirect_to new_charge_path
		
	end
end
