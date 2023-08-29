require 'trade_license'

module LambdaFunction
  class Handler

    def initialize(license_name, registration_no)
      @license_name = license_name
      @registration_no = registration_no
    end

    def name
      "#{@license_name.camelize}".constantize
    end

    def process
      name.new(@registration_no).result
    end
  end
end
