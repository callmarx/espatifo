module ControllerDataResolve
  extend ActiveSupport::Concern

  private
    def relation_decode
      @list_decoded = @list_paginated.map(&:as_json)
      @list_paginated.each_with_index do |obj, idx|
        #Rails.logger.info "###### idx = #{idx} | @list_decoded[idx] = #{@list_decoded[idx]}"
        @list_decoded[idx]['row'].transform_keys!{ |k| @data_set.decode_key(k)}
      end
    end

    def order_query
      order_field = params[:order_field]
      order_by = params[:order_by]
      if !order_field
        Arel.sql("id ASC")
      elsif order_by == 'DESC'
        Arel.sql("row->'#{order_field}' DESC")
      else
        Arel.sql("row->'#{order_field}' ASC")
      end
    end
end
