class StaticPagesController < ApplicationController
  before_filter :authenticate_user
  def why_vpn
  end

  def howto
    if params[:resource]
      name = if I18n.locale == :en
               "#{params[:resource]}_en"
             else
               params[:resource]
             end
      pdf_filename = File.join(Rails.root, "pdf/howto_pdf/#{name}.pdf")
      if params[:a] == 'd'
        send_file(pdf_filename, :filename => "#{name}.pdf", :type => "application/pdf")
      else
        send_file(pdf_filename, :filename => "#{name}.pdf", :type => "application/pdf", :disposition => 'inline')
      end

    end
  end

  def login
  end

  def index
    @root_path = true
  end

  def contactus
  end

  def faq
  end

end
