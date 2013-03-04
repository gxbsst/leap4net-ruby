class StaticPagesController < ApplicationController
  before_filter :authenticate_user
  def why_vpn
  end

  def howto
    if params[:resource]
      pdf_filename = File.join(Rails.root, "pdf/howto_pdf/#{params[:resource]}.pdf")
      send_file(pdf_filename, :filename => "#{params[:resource]}", :type => "application/pdf", :disposition => 'inline')
    end
  end

  def login
  end

  def index
  end

  def contactus
  end

  def faq
  end

end
