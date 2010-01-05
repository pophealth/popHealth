module QueryBuilder 

  def generate_population_query(request)
    population_query = "select count(distinct patients.id) from patients"
    #loop thru from tables and add them to pop_query
    #population_query = population_query + generate_from_sql(request)
    #loop thru some hash of numerator+denominator params and add them to pop_query string
    #population_query = population_query + generate_where_sql(request)
    where_tables = Array.new
    population_query
  end

  def generate_from(from_tables)

  end

  def generate_where_sql(table_name, column_name, code, bin)
    where_sql = "" #part of above loop
    if request.size > 0 #part of above loop
      where_sql = where_sql + " where "
    else
      return ""
    end
    # take "and" into account later

    #join on patient id column in table if not already joined
    if(!where_tables.include?(table_name))
      where_tables.push(table_name)
      where_sql = where_sql + table_name + ".patient_id = patients.id " + "and ("
    end


    case bin
    when(bin.include? "-")
      bin.split('-')
      where_sql = where_sql + "(now()::DATE - " + table_name + "." + column_name + "::DATE >= (365*" + bin[0] + ") "
      where_sql = where_sql + "and now()::DATE - "+ table_name + "." + column_name + "::DATE < (365*" + bin[1] + ")) "
    when (bin.include? "<")
      bin.delete "<"
      where_sql = where_sql + "(now()::DATE - " + table_name + "." + column_name + "::DATE < (365*" + bin + ")) "
    when(bin.include? "+")
      bin.delete "+"
      where_sql = where_sql + "(now()::DATE - " + table_name + "." + column_name + "::DATE >= (365*" + bin + ")) "
    when(bin.include? "Yes")
      where_sql = where_sql + "(" + table_name + "." + column_name + "= '" + code + "')"
    when(bin.include? "No")
      where_sql = where_sql + "patients.id not in (select " + table_name + ".patient_id from " + table_name + " where " + table_name + "." + column_name + " = '" + code + "') "
    else
      where_sql = where_sql + "(" + table_name + "." + column_name + "= " + bin.id.to_s + ") " # need to change this for static content- male, female, tobacco
    end

    where_sql = where_sql + ")"         
  end

end
