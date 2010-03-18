module QueryBuilder 

  def self.generate_population_query(request)
    population_query = "select count(distinct patients.id) from patients"
    #loop thru from tables and add them to pop_query
    #population_query = population_query + generate_from_sql(request)
    #loop thru some hash of numerator+denominator params and add them to pop_query string
    #population_query = population_query + generate_where_sql(request)
    where_tables = Array.new
    population_query
  end

  private

  def generate_from(from_tables)

  end

  def generate_where_sql(table_name, column_name, codes, bin)
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
      if(column_name.eql? value_scalar)
        where_sql = where_sql + "("+ table_name + "." + column_name + "value_scalar::varchar::text::int > " + bin[0] +
        where_sql = where_sql + "and "+ table_name + "." + column_name + "value_scalar::varchar::text::int <= " + bin[1] + ") "
      else
        where_sql = where_sql + "(now()::DATE - " + table_name + "." + column_name + "::DATE >= (365*" + bin[0] + ") "
        where_sql = where_sql + "and now()::DATE - "+ table_name + "." + column_name + "::DATE < (365*" + bin[1] + ")) "
      end
    when (bin.include? "<")
      bin.delete "<"
      where_sql = where_sql + "(now()::DATE - " + table_name + "." + column_name + "::DATE < (365*" + bin + ")) "
    when(bin.include? "+")
      bin.delete "+"
      where_sql = where_sql + "(now()::DATE - " + table_name + "." + column_name + "::DATE >= (365*" + bin + ")) "
    when (bin.include? "/")
      bin.split('/')
      start_range = bin[1] - 5;
      end_range = bin[1] + 4;
      where_sql = where_sql + "(" + table_name + "." + column_name + "::varchar::text::int >=" + start_range + " and"
      + table_name + "." + column_name + "::varchar::text::int" +"<=" + end_range + ")"
    when(bin.include? "Yes")
      i=0
      codes.each do |code|
        i += 1
        if i>1
          where_sql = where_sql + " or "
        end
        if column_name == "free_text_name"
          where_sql = where_sql + "(" + table_name + "." + column_name + "like '%" + code + "%')"
        else
          where_sql = where_sql + "(" + table_name + "." + column_name + "='" + code + "')"
        end
      end
    when(bin.include? "No")
      i=0
      codes.each do |code|
        i += 1
        if i>1
          where_sql = where_sql + " or "
        end
        if column_name == "free_text_name"
          where_sql = where_sql + "patients.id not in (select " + table_name + ".patient_id from " + table_name + " where " + table_name + "." + column_name + " like '%" + code + "%') "
        else
          where_sql = where_sql + "patients.id not in (select " + table_name + ".patient_id from " + table_name + " where " + table_name + "." + column_name + "='" + code + "') "
        end
      end
    else
      where_sql = where_sql + "(" + table_name + "." + column_name + "= " + bin.id.to_s + ") " # need to change this for static content- male, female, tobacco
    end

    where_sql = where_sql + ")"         
  end

end
