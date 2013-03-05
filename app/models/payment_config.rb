module PaymentConfig

  class Paypal

    attr_accessor :username, :password, :signature, :return_url, :cancel_url, :redirect_url, :env

    def initialize
      @config = YAML.load_file(Rails.root.join('config', "paypal.yml"))[Rails.env]
      self.username = @config["username"]
      self.password = @config["password"]
      self.signature = @config["signature"]
      self.return_url = @config["return_url"]
      self.cancel_url = @config["cancel_url"]
      self.redirect_url = @config["redirect_url"]
      self.env = @config["env"].to_sym
    end
  end

  class Alipay

    attr_accessor :subject,
                  :url,
                  :service,
                  :encoding,
                  :payment_type,
                  :seller_email,
                  :partner,
                  :key,
                  :notify_url,
                  :return_url

    def initialize
      @config = YAML.load_file(Rails.root.join('config', "alipay.yml"))[Rails.env]
      self.subject = @config["subject"]
      self.url = @config["url"]
      self.service = @config["service"]
      self.encoding = @config["encoding"]
      self.payment_type = @config["payment_type"]
      self.seller_email = @config["seller_email"]
      self.partner = @config["partner"]
      self.key = @config["key"]
      self.notify_url = @config["notify_url"]
      self.return_url = @config["return_url"]
    end

  end


end