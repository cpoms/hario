module ParserUtils
  InvalidAttributeError = Class.new(RuntimeError)

  def table_name_from_association_chain(association_chain)
    end_model_from_association_chain(association_chain).table_name
  end

  def end_model_from_association_chain(association_chain)
    head = @klass

    association_chain.each do |a_name|
      head = head.reflect_on_all_associations.find{ |a| a.name.to_s == a_name }.klass
    end
    
    head
  end

  def raise_if_unlisted_attribute!(type, model_class, attribute)
    return unless model_class.respond_to?(:hario_attributes_list)
    return unless model_class.hario_attributes_list
    lists = model_class.hario_attributes_list[type]
    return unless lists
    attribute = attribute.to_sym
    if (lists[:except].present? &&  lists[:except].include?(attribute)) ||
       (lists[:only  ].present? && !lists[:only  ].include?(attribute))
      raise InvalidAttributeError, "#{attribute} is forbidden"
    end
  end
end