class FoundationFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TextHelper

  attr_accessor :output_buffer

	def label(attribute, options={})
	 	content_tag(:div, class: "row") do
	   		content_tag(:div, class: "small-10 small-push-1 medium-6 medium-push-3 large-6 text-left") do
	      		super(attribute, options)
	    	end
	  	end
	end

  	def text_field(attribute, options={})
	 	wrapper do
	      	super(attribute, options)
	  	end
	end

	def text_area(attribute,options={})
		wrapper do
			super(attribute,options)
		end
	end

	def select(attribute, options={})
		wrapper do 
			super(attribute,options)
		end
	end

	def em(attribute, options={})
		content_tag(:div, class: "row") do
			content_tag(:div, class: "small-10 small-push-1 medium-6 medium-push-3 large-6") do
				super(attribute,options)
			end
		end
	end

  	def email_field(attribute, options={})
	 	wrapper do
	      		super(attribute, options)
	  	end
	end

  	def password_field(attribute, options={})
	 	wrapper do
	      		super(attribute, options)
	    end
	end

	def submit(text, options={})
		options[:class] ||= "button"
		content_tag(:div, class: "row") do
			content_tag(:div, class: "small-10 small-push-1 medium-6 medium-push-3 large-6 text-center") do
				super(text, options)
			end
		end
	end

	def file_field(attribute, options={})
		options[:class] ||= "form-control"
		content_tag(:div, class: "row") do
			content_tag(:div, class: "small-10 small-push-1 medium-6 medium-push-3 large-6 text-center") do
				super(attribute,options)
			end
		end
	end

	def wrapper(options={}, &block)
	  	content_tag(:div, class: "row") do
	    	content_tag(:div, capture(&block), class: "small-10 small-push-1 medium-6 medium-push-3 large-6 text-center")
 		end
	end
end