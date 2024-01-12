class DatesBeFutureOnesValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        if value.present?
          record.errors.add(attribute, "cannot be in past") unless value.future?
        end
      end
end