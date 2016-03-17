module ParserUtils
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
end