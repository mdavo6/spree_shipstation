
require_dependency 'spree/basic_ssl_authentication'

module Spree

  class ShipstationController < Spree::BaseController

    include Spree::BasicSslAuthentication
    include Spree::DateParamHelper

    protect_from_forgery with: :null_session, only: [:shipnotify]

    def export
      @shipments = Spree::Shipment.exportable
                                  .between(date_param(:start_date),
                                           date_param(:end_date))
                                  .page(params[:page])
                                  .per(50)

      respond_to do |format|
        format.xml { render 'spree/shipstation/export', layout: false }
      end
    end

    
    def shipnotify
      notice = Spree::ShipmentNotice.new(params)
     
       respond_to do |format|
         format.xml { render :status => :ok, layout: false }
       end
    end

  end

end
