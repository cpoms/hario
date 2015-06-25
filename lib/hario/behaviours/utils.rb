module ParserUtils
  def table_name_from_association_chain(association_chain)
    head = @klass

    association_chain.each do |a_name|
      head = head.reflect_on_all_associations.find{ |a| a.name.to_s == a_name }.klass
    end
    
    head.table_name
  end
end