class DatesBeFutureOnesValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        if value.present?
          record.errors.add(attribute, "Cannot be date in past.") unless value.future?
        end
      end
end