module CarrierWave
  module Storage
    module ActiverecordStoreInModel
      class ActiveRecordFile < ::ActiveRecord::Base

        alias_method    :delete, :destroy
        alias_attribute :read, :data

        attr_accessible :identifier,
                        :original_filename,
                        :content_type,
                        :size,
                        :data

        def self.new (table_name, attributes)
          self.table_name = table_name
          super attributes
        end

     end # ActiveRecordFile
    end # ActiveRecord
  end # Storage
end # CarrierWave
