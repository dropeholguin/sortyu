class PagesController < ApplicationController
  def privacy
  end

  def terms_and_conditions
  end

  def about_us
  	
  end

  def contact_us
  	
  end

  def api_terms
    
  end

  def community_guidelines
    
  end

  def brand
    
  end

  def send_message
    ModelMailer.send_message(params[:email],params[:subject],params[:message]).deliver
    redirect_to root_path
    flash[:notice] = "Message delivered successfully."
  end
end
