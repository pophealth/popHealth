class Condition < ActiveRecord::Base

  strip_attributes!

  belongs_to :problem_type

  include PatientChild
  include Commentable

  def requirements
    {
      :start_event => :hitsp_r2_optional,
      :end_event => :hitsp_r2_optional,
      :problem_type_id => :hitsp_r2_required,
      :snowmed_problem => :required,
    }
  end

  def to_c32(xml)
    xml.entry do
      xml.act("classCode" => "ACT", "moodCode" => "EVN") do
        xml.templateId("root" => "2.16.840.1.113883.10.20.1.27", "assigningAuthorityName" => "CCD")
        xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.7", "assigningAuthorityName" => "HITSP/C32")
        xml.id
        xml.code("nullFlavor"=>"NA")
        xml.entryRelationship("typeCode" => "SUBJ") do
          xml.observation("classCode" => "OBS", "moodCode" => "EVN") do
            xml.templateId("root" => "2.16.840.1.113883.10.20.1.28", "assigningAuthorityName" => "CCD")
            if problem_type
              xml.code("code" => problem_type.code, 
                       "displayName" => problem_type.name, 
                       "codeSystem" => "2.16.840.1.113883.6.96", 
                       "codeSystemName" => "SNOMED CT")
            end 
            xml.text do
              xml.reference("value" => "#problem-"+id.to_s)
            end
            xml.statusCode("code" => "completed")
            if start_event.present? || end_event.present?
              xml.effectiveTime do
                if start_event.present?
                  xml.low("value" => start_event.to_s(:brief))
                end
                if end_event.present?
                  xml.high("value" => end_event.to_s(:brief))
                else
                  xml.high("nullFlavor" => "UNK")
                end
              end
            end
            # only write out the coded value if the name of the condition is in the SNOMED list
            if free_text_name
              snowmed_problem = SnowmedProblem.find(:first, :conditions => {:name => free_text_name})
              if snowmed_problem
                xml.value("xsi:type" => "CD", 
                        "code" => snowmed_problem.code, 
                        "displayName" => free_text_name,
                        "codeSystem" => "2.16.840.1.113883.6.96",
                        "codeSystemName" => 'SNOMED CT')
              end
            end
          end
        end
      end
    end
  end

  def randomize(gender, birth_date, condition)
    
    self.start_event = DateTime.new(rand_range(birth_date.year, DateTime.now.year), rand(12) + 1, rand(28) +1)
    
    case condition
    when :diabetes
      condition_code = "73211009"
      has_condition = Condition.make_has_condition({ [0, 18]  => {:M => 0.0039, :F => 0.0057}, 
                                                     [18, 36] => {:M => 0.0214, :F => 0.0153},
                                                     [36, 54] => {:M => 0.0854, :F => 0.0610},
                                                     [54, 72] => {:M => 0.1998, :F => 0.1672},
                                                     [72, 150] => {:M => 0.2239, :F => 0.1837} })
    when :hypertension
      condition_code = "59621000"
      has_condition = Condition.make_has_condition({ [0, 18]  => {:M => 0.0003, :F => 0.0005}, 
                                                     [18, 36] => {:M => 0.0186, :F => 0.0098},
                                                     [36, 54] => {:M => 0.0836, :F => 0.0570},
                                                     [54, 72] => {:M => 0.1516, :F => 0.1392},
                                                     [72, 150] => {:M => 0.1766, :F => 0.2005} })
    when :ischemia
      condition_code = "52674009"
      has_condition = Condition.make_has_condition({ [0, 18]  => {:M => 0.0039, :F => 0.0057}, 
                                                     [18, 36] => {:M => 0.0214, :F => 0.0153},
                                                     [36, 54] => {:M => 0.0854, :F => 0.0610},
                                                     [54, 72] => {:M => 0.1998, :F => 0.1672},
                                                     [72, 150] => {:M => 0.2239, :F => 0.1837} })
    when :lipoid
      condition_code = "3744001"
      has_condition = Condition.make_has_condition({ [0, 18]  => {:M => 0.0039, :F => 0.0057}, 
                                                     [18, 36] => {:M => 0.0214, :F => 0.0153},
                                                     [36, 54] => {:M => 0.0854, :F => 0.0610},
                                                     [54, 72] => {:M => 0.1998, :F => 0.1672},
                                                     [72, 150] => {:M => 0.2239, :F => 0.1837} })
    when :smoking
      condition_code = "77176002"
      has_condition = Condition.make_has_condition({ [19, 25]  => {:M => 0.295, :F => 0.193}, 
                                                     [25, 45] => {:M => 0.26, :F => 0.21},
                                                     [45, 65] => {:M => 0.245, :F => 0.193},
                                                     [65, 100] => {:M => 0.126, :F => 0.083} })    
    when :mammogram
      #129788004 (Mammographic breast mass finding)
      #168750009 (Mammography abnormal finding)
      #397143007 (Probably benign finding short interval follow up finding)
      #168749009 (Mammography normal finding)
      mammogram_findings = ["129788004", "168750009", "397143007", "168749009"]
      condition_code = mammogram_findings[rand(mammogram_findings.length)]
      has_condition = Condition.make_has_condition({ [10, 20]  => {:M => 0.0, :F => 0.044}, 
                                                     [20, 30]  => {:M => 0.0, :F => 0.201}, 
                                                     [30, 40]  => {:M => 0.0, :F => 0.322}, 
                                                     [40, 50]  => {:M => 0.0, :F => 0.635}, 
                                                     [50, 60]  => {:M => 0.0, :F => 0.718},
                                                     [60, 70]  => {:M => 0.0, :F => 0.638},
                                                     [70, 80]  => {:M => 0.0, :F => 0.621},
                                                     [80, 90]  => {:M => 0.0, :F => 0.540},
                                                     [90, 100] => {:M => 0.0, :F => 0.476} })
    else #if no condition is specified, chance of random condition
      condition_code = SnowmedProblem.find(:random).code
      has_condition = Condition.make_has_condition({[0, 150] => {:M => 0.4, :F => 0.35}})
    end

    if has_condition.call(rand, DateTime.now.year - birth_date.year, gender.code.intern)
      self.problem_type = ProblemType.find_by_name("Condition")
      self.free_text_name = SnowmedProblem.find_by_code(condition_code).try(:name)
      return true
    else
      return false
    end
  end
  
  # creates a proc has_condition_x
  # age_buckets is a hash of the form {[age_min, age_max] => {:M => prob_male, :F => prob_female], ...}
  def Condition.make_has_condition (age_buckets)
    return lambda { |p_condition, age, gender|
      age_buckets.each {|bucket, prob|
        return true if age >= bucket[0] && age < bucket[1] && p_condition <= prob[gender]
      }
      return false
    }
  end

  def self.c32_component(conditions, xml)
    if conditions.size > 0
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.11",
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "11450-4",
                   "displayName" => "Problems",
                   "codeSystem" => "2.16.840.1.113883.6.1",
                   "codeSystemName" => "LOINC")
          xml.title "Conditions or Problems"
          xml.text do
            xml.table("border" => "1", "width" => "100%") do
              xml.thead do
                xml.tr do
                  xml.th "Problem Name"
                  xml.th "Problem Type"
                  xml.th "Problem Date"
                end
              end
              xml.tbody do
               conditions.try(:each) do |condition|
                  xml.tr do
                    if condition.free_text_name != nil
                      xml.td do
                        xml.content(condition.free_text_name, 
                                     "ID" => "problem-"+condition.id.to_s)
                      end
                    else
                      xml.td
                    end 
                    if condition.problem_type != nil
                      xml.td condition.problem_type.name
                    else
                      xml.td
                    end  
                    if condition.start_event != nil
                      xml.td condition.start_event.to_s(:brief)
                    else
                      xml.td
                    end
                  end
                end
              end
            end
          end

          # XML content inspection
          yield

        end
      end
    end
  end
end
