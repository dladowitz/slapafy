class StatDecorator < Draper::Decorator
  delegate_all
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:

    def cost_per_lead
      if object.cost_per_lead.is_a? Float
        h.number_to_currency(object.cost_per_lead)
      else
        object.cost_per_lead
      end
    end
end
