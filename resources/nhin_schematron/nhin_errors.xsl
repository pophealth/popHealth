<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:sch="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns:cda="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                version="1.0"
                cda:dummy-for-xmlns=""
                sdtc:dummy-for-xmlns="">
   <xsl:output method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>
   <xsl:template match="*|@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:if test="count(. | ../@*) = count(../@*)">@</xsl:if>
      <xsl:value-of select="name()"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="/">
      <svrl:schematron-output title="Schematron schema for validating conformance to NHIN Core Content Specificiation for&#xA;&#x9;&#x9;Exchange of Summary Patient Record (April 2008)"
                              schemaVersion="">
         <svrl:phase id="errors">
            <svrl:active-pattern>
               <xsl:attribute name="id">PersonInformationModule</xsl:attribute>
               <xsl:attribute name="name">PersonInformationModule</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M6"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">SupportModule</xsl:attribute>
               <xsl:attribute name="name">SupportModule</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M7"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">AllergiesDrugModule</xsl:attribute>
               <xsl:attribute name="name">AllergiesDrugModule</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M8"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ConditionsModule</xsl:attribute>
               <xsl:attribute name="name">ConditionsModule</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M9"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">MedicationsModule</xsl:attribute>
               <xsl:attribute name="name">MedicationsModule</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M10"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">InformationSourceModule</xsl:attribute>
               <xsl:attribute name="name">InformationSourceModule</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M11"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">AdministrativeGender</xsl:attribute>
               <xsl:attribute name="name">AdministrativeGender</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M13"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">MaritalStatus</xsl:attribute>
               <xsl:attribute name="name">MaritalStatus</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M14"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ReligiousAffiliation</xsl:attribute>
               <xsl:attribute name="name">ReligiousAffiliation</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M15"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">RaceCode</xsl:attribute>
               <xsl:attribute name="name">RaceCode</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M16"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">EthnicityCode</xsl:attribute>
               <xsl:attribute name="name">EthnicityCode</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M17"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">HumanLanguage</xsl:attribute>
               <xsl:attribute name="name">HumanLanguage</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M18"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ContactType</xsl:attribute>
               <xsl:attribute name="name">ContactType</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M19"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ContactRelationship</xsl:attribute>
               <xsl:attribute name="name">ContactRelationship</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M20"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ProviderRole</xsl:attribute>
               <xsl:attribute name="name">ProviderRole</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M21"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ProviderType</xsl:attribute>
               <xsl:attribute name="name">ProviderType</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M22"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">CoverageRoleType</xsl:attribute>
               <xsl:attribute name="name">CoverageRoleType</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M24"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">RoleClassRelationshipFormal</xsl:attribute>
               <xsl:attribute name="name">RoleClassRelationshipFormal</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M25"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">AdverseEventType</xsl:attribute>
               <xsl:attribute name="name">AdverseEventType</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M26"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">AdverseEventProduct</xsl:attribute>
               <xsl:attribute name="name">AdverseEventProduct</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M27"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ProblemListSubset</xsl:attribute>
               <xsl:attribute name="name">ProblemListSubset</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M28"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ReactionSeverity</xsl:attribute>
               <xsl:attribute name="name">ReactionSeverity</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M29"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">AllergyStatus</xsl:attribute>
               <xsl:attribute name="name">AllergyStatus</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M30"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ProblemType</xsl:attribute>
               <xsl:attribute name="name">ProblemType</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M31"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ProblemStatus</xsl:attribute>
               <xsl:attribute name="name">ProblemStatus</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M32"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">RouteOfAdministration</xsl:attribute>
               <xsl:attribute name="name">RouteOfAdministration</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M33"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">DoseForm</xsl:attribute>
               <xsl:attribute name="name">DoseForm</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M34"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ProductName</xsl:attribute>
               <xsl:attribute name="name">ProductName</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M35"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">FillStatus</xsl:attribute>
               <xsl:attribute name="name">FillStatus</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M36"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">AdvanceDirectiveType</xsl:attribute>
               <xsl:attribute name="name">AdvanceDirectiveType</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M37"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">AdvanceDirectiveStatus</xsl:attribute>
               <xsl:attribute name="name">AdvanceDirectiveStatus</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M38"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">VaccineProduct</xsl:attribute>
               <xsl:attribute name="name">VaccineProduct</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M39"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ActNoImmunizationReason</xsl:attribute>
               <xsl:attribute name="name">ActNoImmunizationReason</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M40"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">VitalSigns</xsl:attribute>
               <xsl:attribute name="name">VitalSigns</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M41"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ResultType</xsl:attribute>
               <xsl:attribute name="name">ResultType</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M42"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ResultStatus</xsl:attribute>
               <xsl:attribute name="name">ResultStatus</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M43"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ObservationInterpretation</xsl:attribute>
               <xsl:attribute name="name">ObservationInterpretation</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M44"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ProcedureStatus</xsl:attribute>
               <xsl:attribute name="name">ProcedureStatus</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M46"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">ResultTypeCode</xsl:attribute>
               <xsl:attribute name="name">ResultTypeCode</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M47"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">EncounterLocation</xsl:attribute>
               <xsl:attribute name="name">EncounterLocation</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M48"/>
         </svrl:phase>
         <svrl:phase id="warning">
            <svrl:active-pattern>
               <xsl:attribute name="id">InformationSourceModuleWarning</xsl:attribute>
               <xsl:attribute name="name">InformationSourceModuleWarning</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M12"/>
         </svrl:phase>
         <svrl:phase id="note">
            <svrl:active-pattern>
               <xsl:attribute name="id">CoverageType</xsl:attribute>
               <xsl:attribute name="name">CoverageType</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M23"/>
            <svrl:active-pattern>
               <xsl:attribute name="id">EncounterType</xsl:attribute>
               <xsl:attribute name="name">EncounterType</xsl:attribute>
               <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates select="/" mode="M45"/>
         </svrl:phase>
      </svrl:schematron-output>
   </xsl:template>
   <svrl:phase id="errors">
      <svrl:active-pattern>
         <xsl:attribute name="id">PersonInformationModule</xsl:attribute>
         <xsl:attribute name="name">PersonInformationModule</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M6"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">SupportModule</xsl:attribute>
         <xsl:attribute name="name">SupportModule</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M7"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">AllergiesDrugModule</xsl:attribute>
         <xsl:attribute name="name">AllergiesDrugModule</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M8"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ConditionsModule</xsl:attribute>
         <xsl:attribute name="name">ConditionsModule</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M9"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">MedicationsModule</xsl:attribute>
         <xsl:attribute name="name">MedicationsModule</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M10"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">InformationSourceModule</xsl:attribute>
         <xsl:attribute name="name">InformationSourceModule</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M11"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">AdministrativeGender</xsl:attribute>
         <xsl:attribute name="name">AdministrativeGender</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M13"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">MaritalStatus</xsl:attribute>
         <xsl:attribute name="name">MaritalStatus</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M14"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ReligiousAffiliation</xsl:attribute>
         <xsl:attribute name="name">ReligiousAffiliation</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M15"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">RaceCode</xsl:attribute>
         <xsl:attribute name="name">RaceCode</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M16"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">EthnicityCode</xsl:attribute>
         <xsl:attribute name="name">EthnicityCode</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M17"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">HumanLanguage</xsl:attribute>
         <xsl:attribute name="name">HumanLanguage</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M18"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ContactType</xsl:attribute>
         <xsl:attribute name="name">ContactType</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M19"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ContactRelationship</xsl:attribute>
         <xsl:attribute name="name">ContactRelationship</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M20"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ProviderRole</xsl:attribute>
         <xsl:attribute name="name">ProviderRole</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M21"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ProviderType</xsl:attribute>
         <xsl:attribute name="name">ProviderType</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M22"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">CoverageRoleType</xsl:attribute>
         <xsl:attribute name="name">CoverageRoleType</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M24"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">RoleClassRelationshipFormal</xsl:attribute>
         <xsl:attribute name="name">RoleClassRelationshipFormal</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M25"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">AdverseEventType</xsl:attribute>
         <xsl:attribute name="name">AdverseEventType</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M26"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">AdverseEventProduct</xsl:attribute>
         <xsl:attribute name="name">AdverseEventProduct</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M27"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ProblemListSubset</xsl:attribute>
         <xsl:attribute name="name">ProblemListSubset</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M28"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ReactionSeverity</xsl:attribute>
         <xsl:attribute name="name">ReactionSeverity</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M29"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">AllergyStatus</xsl:attribute>
         <xsl:attribute name="name">AllergyStatus</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M30"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ProblemType</xsl:attribute>
         <xsl:attribute name="name">ProblemType</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M31"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ProblemStatus</xsl:attribute>
         <xsl:attribute name="name">ProblemStatus</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M32"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">RouteOfAdministration</xsl:attribute>
         <xsl:attribute name="name">RouteOfAdministration</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M33"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">DoseForm</xsl:attribute>
         <xsl:attribute name="name">DoseForm</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M34"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ProductName</xsl:attribute>
         <xsl:attribute name="name">ProductName</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M35"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">FillStatus</xsl:attribute>
         <xsl:attribute name="name">FillStatus</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M36"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">AdvanceDirectiveType</xsl:attribute>
         <xsl:attribute name="name">AdvanceDirectiveType</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M37"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">AdvanceDirectiveStatus</xsl:attribute>
         <xsl:attribute name="name">AdvanceDirectiveStatus</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M38"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">VaccineProduct</xsl:attribute>
         <xsl:attribute name="name">VaccineProduct</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M39"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ActNoImmunizationReason</xsl:attribute>
         <xsl:attribute name="name">ActNoImmunizationReason</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M40"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">VitalSigns</xsl:attribute>
         <xsl:attribute name="name">VitalSigns</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M41"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ResultType</xsl:attribute>
         <xsl:attribute name="name">ResultType</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M42"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ResultStatus</xsl:attribute>
         <xsl:attribute name="name">ResultStatus</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M43"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ObservationInterpretation</xsl:attribute>
         <xsl:attribute name="name">ObservationInterpretation</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M44"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ProcedureStatus</xsl:attribute>
         <xsl:attribute name="name">ProcedureStatus</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M46"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">ResultTypeCode</xsl:attribute>
         <xsl:attribute name="name">ResultTypeCode</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M47"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">EncounterLocation</xsl:attribute>
         <xsl:attribute name="name">EncounterLocation</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M48"/>
   </svrl:phase>
   <svrl:phase id="warning">
      <svrl:active-pattern>
         <xsl:attribute name="id">InformationSourceModuleWarning</xsl:attribute>
         <xsl:attribute name="name">InformationSourceModuleWarning</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M12"/>
   </svrl:phase>
   <svrl:phase id="note">
      <svrl:active-pattern>
         <xsl:attribute name="id">CoverageType</xsl:attribute>
         <xsl:attribute name="name">CoverageType</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M23"/>
      <svrl:active-pattern>
         <xsl:attribute name="id">EncounterType</xsl:attribute>
         <xsl:attribute name="name">EncounterType</xsl:attribute>
         <xsl:apply-templates/>
      </svrl:active-pattern>
      <xsl:apply-templates select="/" mode="M45"/>
   </svrl:phase>
   <xsl:template match="/cda:ClinicalDocument" priority="4000" mode="M6">
      <svrl:fired-rule context="/cda:ClinicalDocument"/>
      <xsl:choose>
         <xsl:when test="count(./cda:recordTarget/cda:patientRole/cda:patient)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert test="count(./cda:recordTarget/cda:patientRole/cda:patient)=1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, Personal Information Module is a required Module.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="/cda:ClinicalDocument" priority="4000" mode="M7">
      <svrl:fired-rule context="/cda:ClinicalDocument"/>
      <xsl:choose>
         <xsl:when test="cda:recordTarget/cda:patientRole/cda:patient/cda:guardian or cda:participant[@typeCode='IND']"/>
         <xsl:otherwise>
            <svrl:failed-assert test="cda:recordTarget/cda:patientRole/cda:patient/cda:guardian or cda:participant[@typeCode='IND']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, Support Module is a required Module.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="/cda:ClinicalDocument" priority="4000" mode="M8">
      <svrl:fired-rule context="/cda:ClinicalDocument"/>
      <xsl:choose>
         <xsl:when test=".//cda:templateId/@root='2.16.840.1.113883.3.88.11.32.6'"/>
         <xsl:otherwise>
            <svrl:failed-assert test=".//cda:templateId/@root='2.16.840.1.113883.3.88.11.32.6'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, Allergies and Drug Sensitivities Module is a required Module.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="/cda:ClinicalDocument" priority="4000" mode="M9">
      <svrl:fired-rule context="/cda:ClinicalDocument"/>
      <xsl:choose>
         <xsl:when test=".//cda:templateId/@root='2.16.840.1.113883.3.88.11.32.7'"/>
         <xsl:otherwise>
            <svrl:failed-assert test=".//cda:templateId/@root='2.16.840.1.113883.3.88.11.32.7'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, Conditions Module (problem list) is a required module.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="/cda:ClinicalDocument" priority="4000" mode="M10">
      <svrl:fired-rule context="/cda:ClinicalDocument"/>
      <xsl:choose>
         <xsl:when test=".//cda:templateId/@root='2.16.840.1.113883.3.88.11.32.8'"/>
         <xsl:otherwise>
            <svrl:failed-assert test=".//cda:templateId/@root='2.16.840.1.113883.3.88.11.32.8'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, Medications Module is a required Module.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="/cda:ClinicalDocument" priority="4000" mode="M11">
      <svrl:fired-rule context="/cda:ClinicalDocument"/>
      <xsl:choose>
         <xsl:when test="cda:author"/>
         <xsl:otherwise>
            <svrl:failed-assert test="cda:author">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, Information Source Module is a required Module.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M11"/>
   </xsl:template>
   <xsl:template match="/cda:ClinicalDocument/cda:author" priority="3999" mode="M11">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:author" id="AttributingSourceAuthor"/>
      <xsl:choose>
         <xsl:when test="./cda:assignedAuthor/cda:assignedPerson or                               ./cda:assignedAuthor/cda:assignedAuthoringDevice"/>
         <xsl:otherwise>
            <svrl:failed-assert test="./cda:assignedAuthor/cda:assignedPerson or ./cda:assignedAuthor/cda:assignedAuthoringDevice">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: The author element SHALL identify either an individual (assignedAuthor/assignedPerson) or a system/device (assignedAuthor/assignedAuthoringDevice). See section IV. E of the Specification for Exchange of the Summary Patient Record.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="/cda:ClinicalDocument/cda:author" priority="4000" mode="M12">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:author"/>
      <xsl:choose>
         <xsl:when test="./cda:assignedAuthor/cda:representedOrganization"/>
         <xsl:otherwise>
            <svrl:failed-assert test="./cda:assignedAuthor/cda:representedOrganization">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Warning: The author element should identify an organization with which the person or device is associated (assignedAuthor/representedOrganization). See section IV. E of the Specification for Exchange of the Summary Patient Record.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode"
                 priority="4000"
                 mode="M13">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.1&#34; and              (@code=&#34;F&#34; or @code=&#34;M&#34; or @code=&#34;UN&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.1&#34; and (@code=&#34;F&#34; or @code=&#34;M&#34; or @code=&#34;UN&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, administrativeGenderCode SHALL use codeSystem="2.16.840.1.113883.5.1" and code=[F|M|UN].</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:maritalStatusCode"
                 priority="4000"
                 mode="M14">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:maritalStatusCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.2&#34; and      (@code=&#34;A&#34; or                             @code=&#34;D&#34; or                            @code=&#34;T&#34; or                            @code=&#34;I&#34; or                            @code=&#34;L&#34; or                            @code=&#34;M&#34; or                            @code=&#34;S&#34; or                            @code=&#34;P&#34; or                            @code=&#34;W&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.2&#34; and (@code=&#34;A&#34; or @code=&#34;D&#34; or @code=&#34;T&#34; or @code=&#34;I&#34; or @code=&#34;L&#34; or @code=&#34;M&#34; or @code=&#34;S&#34; or @code=&#34;P&#34; or @code=&#34;W&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, maritalStatusCode SHALL use codeSystem="2.16.840.1.113883.5.2" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.12212). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:religiousAffiliationCode"
                 priority="4000"
                 mode="M15">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:religiousAffiliationCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.1076&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.1076&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.1076&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.1076&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, religiousAffiliationCode SHALL use codeSystem="2.16.840.1.113883.5.1076" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.19185). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:raceCode |                  /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/sdtc:raceCode "
                 priority="4000"
                 mode="M16">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:raceCode |                  /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/sdtc:raceCode "/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.238&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.238&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.238&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.238&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, raceCode SHALL use codeSystem="2.16.840.1.113883.6.238" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.14914). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode"
                 priority="4000"
                 mode="M17">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.238&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.238&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.238&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.238&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, ethnicGroupCode SHALL use codeSystem="2.16.840.1.113883.6.238" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.15836). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:languageCommunication/cda:languageCode"
                 priority="4000"
                 mode="M18">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:languageCommunication/cda:languageCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or                 (                 string-length(current()/@code) = 5                 and                 substring( current()/@code , 1, 2 ) = document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.121&#34;]/code/@value                 and                 substring( current()/@code , 3, 1 ) = &#34;-&#34;                 and                 substring( current()/@code, 4, 2) = document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.1&#34;]/code/@value                                                 )                                 or                 (                 string-length(current()/@code) = 6                 and                 substring( current()/@code , 1, 3 ) = document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.121&#34;]/code/@value                 and                 substring( current()/@code , 4, 1 ) = &#34;-&#34;                 and                 substring( current()/@code, 5, 2) = document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.1&#34;]/code/@value                                                 )                 "/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or ( string-length(current()/@code) = 5 and substring( current()/@code , 1, 2 ) = document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.121&#34;]/code/@value and substring( current()/@code , 3, 1 ) = &#34;-&#34; and substring( current()/@code, 4, 2) = document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.1&#34;]/code/@value ) or ( string-length(current()/@code) = 6 and substring( current()/@code , 1, 3 ) = document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.121&#34;]/code/@value and substring( current()/@code , 4, 1 ) = &#34;-&#34; and substring( current()/@code, 5, 2) = document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.1&#34;]/code/@value )">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, human langauge SHALL use a code from the specified list (value set OID: 2.16.840.1.113883.1.11.11526). The code consists of a two or three letter language code (ISO 639-2) followed by a hyphen, followed by a two letter country code (ISO 3166). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="/cda:ClinicalDocument/cda:participant/cda:associatedEntity |                  /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian"
                 priority="4000"
                 mode="M19">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:participant/cda:associatedEntity |                  /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian"/>
      <xsl:choose>
         <xsl:when test="@classCode=&#34;AGNT&#34; or                 @classCode=&#34;CAREGIVER&#34; or                 @classCode=&#34;ECON&#34; or                 @classCode=&#34;GUARD&#34; or                 @classCode=&#34;NOK&#34; or                 @classCode=&#34;PRS&#34;"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@classCode=&#34;AGNT&#34; or @classCode=&#34;CAREGIVER&#34; or @classCode=&#34;ECON&#34; or @classCode=&#34;GUARD&#34; or @classCode=&#34;NOK&#34; or @classCode=&#34;PRS&#34;">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, contact type SHALL use a classCode from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.3.2). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="/cda:ClinicalDocument/cda:participant/cda:associatedEntity/cda:code |             /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian/cda:code"
                 priority="4000"
                 mode="M20">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:participant/cda:associatedEntity/cda:code |             /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.111&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.111&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.111&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.111&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, contact relationship SHALL use codeSystem="2.16.840.1.113883.5.111" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.19579). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="/cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:functionCode"
                 priority="4000"
                 mode="M21">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:functionCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.12.443&#34; and             (@code=&#34;CP&#34; or       @code=&#34;PP&#34; or       @code=&#34;RP&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.12.443&#34; and (@code=&#34;CP&#34; or @code=&#34;PP&#34; or @code=&#34;RP&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, provider role SHALL use codeSystem="2.16.840.1.113883.12.443" and code=[CP|PP|RP].</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="/cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:assignedEntity/cda:code"
                 priority="4000"
                 mode="M22">
      <svrl:fired-rule context="/cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:assignedEntity/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.101&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.101&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.101&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.101&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, provider type SHALL use codeSystem="2.16.840.1.113883.6.101" and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.4.4). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.26&#34;]/cda:code"
                 priority="4000"
                 mode="M23">
      <svrl:fired-rule context="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.26&#34;]/cda:code"/>
      <xsl:if test=".">
         <svrl:successful-report test=".">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>Note: In Summary Patient Record, for coverage type the value set (OID: 2.16.840.1.113883.3.88.12.3221.5.2) is based on X12N Data Element 1336. However, the X12N 270/271 Implementation Guide contains the values for this value set and this document is not freely available. Please make certain that the code element conforms to this code system and code set.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.26&#34;]/cda:participant[@typeCode=&#34;COV&#34;]/cda:participantRole[@classCode=&#34;PAT&#34;]/cda:code"
                 priority="4000"
                 mode="M24">
      <svrl:fired-rule context="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.26&#34;]/cda:participant[@typeCode=&#34;COV&#34;]/cda:participantRole[@classCode=&#34;PAT&#34;]/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.111&#34; and                    (@code=&#34;STUD&#34; or       @code=&#34;FSTUD&#34; or                            @code=&#34;PSTUD&#34; or                            @code=&#34;FAMDEP&#34; or                            @code=&#34;HANDIC&#34; or                            @code=&#34;INJ&#34; or                            @code=&#34;SELF&#34; or                            @code=&#34;SPON&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.111&#34; and (@code=&#34;STUD&#34; or @code=&#34;FSTUD&#34; or @code=&#34;PSTUD&#34; or @code=&#34;FAMDEP&#34; or @code=&#34;HANDIC&#34; or @code=&#34;INJ&#34; or @code=&#34;SELF&#34; or @code=&#34;SPON&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, coverage role type SHALL use codeSystem="2.16.840.1.113883.5.111" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.19809). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.26&#34;]/cda:performer/cda:assignedEntity/cda:code"
                 priority="4000"
                 mode="M25">
      <svrl:fired-rule context="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.26&#34;]/cda:performer/cda:assignedEntity/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.110&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.110&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.110&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.110&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, role class relationship formal SHALL use codeSystem="2.16.840.1.113883.5.110" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.10416). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.18&#34;]/cda:code"
                 priority="4000"
                 mode="M26">
      <svrl:fired-rule context="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.18&#34;]/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and                      (@code=&#34;420134006&#34; or        @code=&#34;418038007&#34; or                                    @code=&#34;419511003&#34; or                                    @code=&#34;418471000&#34; or                                    @code=&#34;419199007&#34; or                                    @code=&#34;416098002&#34; or                                    @code=&#34;414285001&#34; or                                    @code=&#34;59037007&#34; or                                    @code=&#34;235719002&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and (@code=&#34;420134006&#34; or @code=&#34;418038007&#34; or @code=&#34;419511003&#34; or @code=&#34;418471000&#34; or @code=&#34;419199007&#34; or @code=&#34;416098002&#34; or @code=&#34;414285001&#34; or @code=&#34;59037007&#34; or @code=&#34;235719002&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, adverse event type SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.6.2). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.18&#34;]/cda:participant[@typeCode=&#34;CSM&#34;]/cda:participantRole[@classCode=&#34;MANU&#34;]/cda:playingEntity[@classCode=&#34;MMAT&#34;]/cda:code"
                 priority="4000"
                 mode="M27">
      <svrl:fired-rule context="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.18&#34;]/cda:participant[@typeCode=&#34;CSM&#34;]/cda:participantRole[@classCode=&#34;MANU&#34;]/cda:playingEntity[@classCode=&#34;MMAT&#34;]/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or                  (@codeSystem=&#34;2.16.840.1.113883.6.69&#34;) or                 (@codeSystem=&#34;2.16.840.1.113883.4.9&#34; and document(&#34;unii.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.4.9&#34;]/code[@value = current()/@code]) or                 (@codeSystem=&#34;2.16.840.1.113883.4.209&#34; and document(&#34;ndf-rt.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.4.209&#34;]/code[@value = current()/@code]) or                 (@codeSystem=&#34;2.16.840.1.113883.6.88&#34; )                                 "/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or (@codeSystem=&#34;2.16.840.1.113883.6.69&#34;) or (@codeSystem=&#34;2.16.840.1.113883.4.9&#34; and document(&#34;unii.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.4.9&#34;]/code[@value = current()/@code]) or (@codeSystem=&#34;2.16.840.1.113883.4.209&#34; and document(&#34;ndf-rt.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.4.209&#34;]/code[@value = current()/@code]) or (@codeSystem=&#34;2.16.840.1.113883.6.88&#34; )">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, adverse event product SHALL use a codeSystem and a code from the specified list (value set OID: 2.16.840.1.113883.3.18.6.1.10). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.54&#34;]/cda:value |            //cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.28&#34;]/cda:value |                      //cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34;]/cda:consumable/cda:manufacturedProduct/cda:entryRelationship[@typeCode=&#34;RSON&#34;]/ cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.28&#34;]/cda:value"
                 priority="4000"
                 mode="M28">
      <svrl:fired-rule context="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.54&#34;]/cda:value |            //cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.28&#34;]/cda:value |                      //cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34;]/cda:consumable/cda:manufacturedProduct/cda:entryRelationship[@typeCode=&#34;RSON&#34;]/ cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.28&#34;]/cda:value"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and     document(&#34;problemListSubset.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.96&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and document(&#34;problemListSubset.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.96&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, problem list subset SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.7.4). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.55&#34;]/cda:value"
                 priority="4000"
                 mode="M29">
      <svrl:fired-rule context="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.55&#34;]/cda:value"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and                    (@code=&#34;255604002&#34; or      @code=&#34;371923003&#34; or                           @code=&#34;6736007&#34; or                           @code=&#34;371924009&#34; or                           @code=&#34;24484000&#34; or                           @code=&#34;399166001&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and (@code=&#34;255604002&#34; or @code=&#34;371923003&#34; or @code=&#34;6736007&#34; or @code=&#34;371924009&#34; or @code=&#34;24484000&#34; or @code=&#34;399166001&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, reaction severity SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.6.8). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.55&#34;]/cda:entryRelationship/cda:observation[cda:code/@code=&#34;33999-4&#34;]/cda:value"
                 priority="4000"
                 mode="M30">
      <svrl:fired-rule context="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.55&#34;]/cda:entryRelationship/cda:observation[cda:code/@code=&#34;33999-4&#34;]/cda:value"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and                 (@code=&#34;55561003&#34; or                 @code=&#34;392521001&#34; or                 @code=&#34;73425007&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and (@code=&#34;55561003&#34; or @code=&#34;392521001&#34; or @code=&#34;73425007&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, allergy status SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.20.3). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.28&#34;]/cda:code"
                 priority="4000"
                 mode="M31">
      <svrl:fired-rule context="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.28&#34;]/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and            (@code=&#34;404684003&#34; or      @code=&#34;418799008&#34; or                           @code=&#34;55607006&#34; or                           @code=&#34;409586006&#34; or                           @code=&#34;64572001&#34; or                           @code=&#34;282291009&#34; or                           @code=&#34;248536006&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and (@code=&#34;404684003&#34; or @code=&#34;418799008&#34; or @code=&#34;55607006&#34; or @code=&#34;409586006&#34; or @code=&#34;64572001&#34; or @code=&#34;282291009&#34; or @code=&#34;248536006&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, problem type SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.7.2). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.28&#34;]/cda:entryRelationship/cda:observation[cda:code/@code=&#34;33999-4&#34;]/cda:value"
                 priority="4000"
                 mode="M32">
      <svrl:fired-rule context="//cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:entryRelationship[@typeCode=&#34;SUBJ&#34;]/cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.28&#34;]/cda:entryRelationship/cda:observation[cda:code/@code=&#34;33999-4&#34;]/cda:value"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or (@codeSystem=&#34;2.16.840.1.113883.6.96&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.96&#34;]/code[@value = current()/@code])"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or (@codeSystem=&#34;2.16.840.1.113883.6.96&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.96&#34;]/code[@value = current()/@code])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, problem status SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from the specified list (value set OID: 2.16.840.1.113883.3.18.6.1.10). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34;]/cda:routeCode"
                 priority="4000"
                 mode="M33">
      <svrl:fired-rule context="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34;]/cda:routeCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.3.26.1.1&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.3.26.1.1&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.3.26.1.1&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.3.26.1.1&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, route of administration SHALL use codeSystem="2.16.840.1.113883.3.26.1.1" and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.8.7). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34;]/cda:administrationUnitCode"
                 priority="4000"
                 mode="M34">
      <svrl:fired-rule context="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34;]/cda:administrationUnitCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.3.26.1.1&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.3.26.1.1&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.3.26.1.1&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.3.26.1.1&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, dose form SHALL use codeSystem="2.16.840.1.113883.3.26.1.1" and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.8.11). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.8&#34;]/cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code |                               //cda:participant/cda:participantRole[cda:code/@code = &#34;412307009&#34; and cda:code/@codeSystem=&#34;2.16.840.1.113883.6.96&#34;]/cda:playingEntity/cda:code"
                 priority="4000"
                 mode="M35">
      <svrl:fired-rule context="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.8&#34;]/cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code |                               //cda:participant/cda:participantRole[cda:code/@code = &#34;412307009&#34; and cda:code/@codeSystem=&#34;2.16.840.1.113883.6.96&#34;]/cda:playingEntity/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or                  (@codeSystem=&#34;2.16.840.1.113883.6.69&#34; and document(&#34;productName.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.69&#34;]/code[@value = current()/@code]) or                 (@codeSystem=&#34;2.16.840.1.113883.4.9&#34; and document(&#34;unii.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.4.9&#34;]/code[@value = current()/@code]) or                 (@codeSystem=&#34;2.16.840.1.113883.4.209&#34; and document(&#34;ndf-rt.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.4.209&#34;]/code[@value = current()/@code]) or                 (@codeSystem=&#34;2.16.840.1.113883.6.88&#34; )                                  "/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or (@codeSystem=&#34;2.16.840.1.113883.6.69&#34; and document(&#34;productName.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.69&#34;]/code[@value = current()/@code]) or (@codeSystem=&#34;2.16.840.1.113883.4.9&#34; and document(&#34;unii.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.4.9&#34;]/code[@value = current()/@code]) or (@codeSystem=&#34;2.16.840.1.113883.4.209&#34; and document(&#34;ndf-rt.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.4.209&#34;]/code[@value = current()/@code]) or (@codeSystem=&#34;2.16.840.1.113883.6.88&#34; )">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, product name SHALL use a codeSystem and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.8.13). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34;]/cda:entryRelationship/cda:supply[@moodCode=&#34;EVN&#34;]/cda:statusCode"
                 priority="4000"
                 mode="M36">
      <svrl:fired-rule context="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34;]/cda:entryRelationship/cda:supply[@moodCode=&#34;EVN&#34;]/cda:statusCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @code=&#34;aborted&#34; or                           @code=&#34;completed&#34;"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @code=&#34;aborted&#34; or @code=&#34;completed&#34;">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, fill status SHALL code=[aborted|completed].</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.17&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.13&#34;]/cda:code"
                 priority="4000"
                 mode="M37">
      <svrl:fired-rule context="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.17&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.13&#34;]/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and                          (@code=&#34;304251008&#34; or      @code=&#34;52765003&#34; or                           @code=&#34;225204009&#34; or                           @code=&#34;89666000&#34; or                           @code=&#34;281789004&#34; or                           @code=&#34;78823007&#34; or                           @code=&#34;61420007&#34; or                           @code=&#34;71388002&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and (@code=&#34;304251008&#34; or @code=&#34;52765003&#34; or @code=&#34;225204009&#34; or @code=&#34;89666000&#34; or @code=&#34;281789004&#34; or @code=&#34;78823007&#34; or @code=&#34;61420007&#34; or @code=&#34;71388002&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, advance directive type SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.20.2). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.17&#34;]/cda:entryRelationship/cda:observation/cda:value"
                 priority="4000"
                 mode="M38">
      <svrl:fired-rule context="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.17&#34;]/cda:entryRelationship/cda:observation/cda:value"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and                           (@code=&#34;425392003&#34; or                            @code=&#34;425394002&#34; or                            @code=&#34;425393008&#34; or                            @code=&#34;425396000&#34; or                            @code=&#34;310305009&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and (@code=&#34;425392003&#34; or @code=&#34;425394002&#34; or @code=&#34;425393008&#34; or @code=&#34;425396000&#34; or @code=&#34;310305009&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, advance directive status SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.20.1). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.14&#34;]/cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code"
                 priority="4000"
                 mode="M39">
      <svrl:fired-rule context="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.14&#34;]/cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.59&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.59&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.59&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.59&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, vaccine product SHALL use codeSystem="2.16.840.1.113883.6.59" and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.13.6). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.14&#34;]/cda:entryRelationship[@typeCode=&#34;RSON&#34;]/cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:code"
                 priority="4000"
                 mode="M40">
      <svrl:fired-rule context="//cda:substanceAdministration[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.24&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.14&#34;]/cda:entryRelationship[@typeCode=&#34;RSON&#34;]/cda:act[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.27&#34;]/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.8&#34; and                          (@code=&#34;IMMUNE&#34; or      @code=&#34;MEDPREC&#34; or                           @code=&#34;OSTOCK&#34; or                           @code=&#34;PATOBJ&#34; or                           @code=&#34;PHILISOP&#34; or                           @code=&#34;RELIG&#34; or                           @code=&#34;VACEFF&#34; or                           @code=&#34;VACSAF&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.8&#34; and (@code=&#34;IMMUNE&#34; or @code=&#34;MEDPREC&#34; or @code=&#34;OSTOCK&#34; or @code=&#34;PATOBJ&#34; or @code=&#34;PHILISOP&#34; or @code=&#34;RELIG&#34; or @code=&#34;VACEFF&#34; or @code=&#34;VACSAF&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, act no immunization reason SHALL use codeSystem="2.16.840.1.113883.5.8" and a code from the specified list (value set OID: 2.16.840.1.113883.11.19725). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.15&#34;]/cda:code"
                 priority="4000"
                 mode="M41">
      <svrl:fired-rule context="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.15&#34;]/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.1&#34; and                          (@code=&#34;9279-1&#34; or      @code=&#34;8867-4&#34; or                           @code=&#34;2710-2&#34; or                           @code=&#34;8480-6&#34; or                           @code=&#34;8462-4&#34; or                           @code=&#34;8310-5&#34; or                           @code=&#34;8302-2&#34; or                           @code=&#34;8306-3&#34; or                           @code=&#34;8287-5&#34; or                           @code=&#34;3141-9&#34;)"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.1&#34; and (@code=&#34;9279-1&#34; or @code=&#34;8867-4&#34; or @code=&#34;2710-2&#34; or @code=&#34;8480-6&#34; or @code=&#34;8462-4&#34; or @code=&#34;8310-5&#34; or @code=&#34;8302-2&#34; or @code=&#34;8306-3&#34; or @code=&#34;8287-5&#34; or @code=&#34;3141-9&#34;)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, vital sign SHALL use codeSystem="2.16.840.1.113883.6.1" and a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.15.3.103). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.16&#34;]/cda:code"
                 priority="4000"
                 mode="M42">
      <svrl:fired-rule context="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.16&#34;]/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem = &#34;2.16.840.1.113883.6.1&#34; and                 document(&#34;resultType.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.1&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem = &#34;2.16.840.1.113883.6.1&#34; and document(&#34;resultType.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.1&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, result code SHALL use codeSystem="2.16.840.1.113883.6.1" and a code from the specified list (value set OID: 2.16.840.1.113883.3.18.6.1.12). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.15&#34;]/cda:statusCode |             //cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.16&#34;]/cda:statusCode |             //cda:section[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.12&#34;]/cda:entry/cda:organizer/cda:statusCode"
                 priority="4000"
                 mode="M43">
      <svrl:fired-rule context="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.15&#34;]/cda:statusCode |             //cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.16&#34;]/cda:statusCode |             //cda:section[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.12&#34;]/cda:entry/cda:organizer/cda:statusCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @code=&#34;aborted&#34; or      @code=&#34;completed&#34; or                           @code=&#34;active&#34; or                           @code=&#34;cancelled&#34; or                           @code=&#34;held&#34; or                           @code=&#34;new&#34; or                           @code=&#34;suspended&#34;"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @code=&#34;aborted&#34; or @code=&#34;completed&#34; or @code=&#34;active&#34; or @code=&#34;cancelled&#34; or @code=&#34;held&#34; or @code=&#34;new&#34; or @code=&#34;suspended&#34;">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, result status SHALL use a code from the specified list (value set OID: 2.16.840.1.113883.1.11.15936). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.15&#34;]/cda:interpretationCode |             //cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.16&#34;]/cda:interpretationCode"
                 priority="4000"
                 mode="M44">
      <svrl:fired-rule context="//cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.15&#34;]/cda:interpretationCode |             //cda:observation[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.14&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.16&#34;]/cda:interpretationCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.83&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.83&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.83&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.83&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, result status SHALL use codeSystem="2.16.840.1.113883.5.83" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.78). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="//cda:encounter[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.21&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.17&#34;]/cda:code"
                 priority="4000"
                 mode="M45">
      <svrl:fired-rule context="//cda:encounter[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.21&#34; and cda:templateId/@root=&#34;2.16.840.1.113883.3.88.11.32.17&#34;]/cda:code"/>
      <xsl:if test=".">
         <svrl:successful-report test=".">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>Note: In Summary Patient Record, for encounter type the value set (OID: 2.16.840.1.113883.3.88.12.3221.16.2) is based on CPT-4. However, CPT-4 codes are licensed by the AMA and are not freely available. . Please make certain that the code element conforms to this code system and code set.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="//cda:section[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.12&#34;]/cda:entry/cda:procedure[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.29&#34;]/cda:statusCode"
                 priority="4000"
                 mode="M46">
      <svrl:fired-rule context="//cda:section[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.12&#34;]/cda:entry/cda:procedure[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.29&#34;]/cda:statusCode"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @code=&#34;cancelled&#34; or                 @code=&#34;held&#34; or                 @code=&#34;active&#34; or                 @code=&#34;aborted&#34; or                 @code=&#34;completed&#34;"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @code=&#34;cancelled&#34; or @code=&#34;held&#34; or @code=&#34;active&#34; or @code=&#34;aborted&#34; or @code=&#34;completed&#34;">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, procedure status SHALL use codeSystem="2.16.840.1.113883.5.14" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.20.15). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="//cda:section[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.12&#34;]/cda:entry/cda:organizer/cda:code"
                 priority="4000"
                 mode="M47">
      <svrl:fired-rule context="//cda:section[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.12&#34;]/cda:entry/cda:organizer/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.96&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.6.96&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.6.96&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, result type code SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.20.16). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="//cda:section[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.12&#34;]/cda:entry/cda:encounter/cda:participant[@typeCode=&#34;LOC&#34;]/cda:participantRole/cda:code"
                 priority="4000"
                 mode="M48">
      <svrl:fired-rule context="//cda:section[cda:templateId/@root=&#34;2.16.840.1.113883.10.20.1.12&#34;]/cda:entry/cda:encounter/cda:participant[@typeCode=&#34;LOC&#34;]/cda:participantRole/cda:code"/>
      <xsl:choose>
         <xsl:when test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.111&#34; and                 document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.111&#34;]/code[@value = current()/@code]"/>
         <xsl:otherwise>
            <svrl:failed-assert test="@nullFlavor or @codeSystem=&#34;2.16.840.1.113883.5.111&#34; and document(&#34;codeSystems.xml&#34;)/systems/system[@root=&#34;2.16.840.1.113883.5.111&#34;]/code[@value = current()/@code]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: In Summary Patient Record, encounter location SHALL use codeSystem="2.16.840.1.113883.5.111" and a code from the specified list (value set OID: 2.16.840.1.113883.1.11.17660). See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="text()" priority="-1"/>
</xsl:stylesheet>