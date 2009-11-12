<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!DOCTYPE schema [

<!--

This schematron file codifies the requirements from "NHIN Core
Content Specificiation for Exchange of Summary Patient Record" into a
series of rules.  The rules in this file are based upon the final version, Date: April 8, 2008.

-->

<!ENTITY baseURI "http://www.hhs.gov/healthit/healthnetwork/background/">
]>
<schema xmlns="http://www.ascc.net/xml/schematron" xmlns:cda="urn:hl7-org:v3">
	<title>Schematron schema for validating conformance to NHIN Core Content Specificiation for
		Exchange of Summary Patient Record (April 2008)</title>
	<ns prefix="cda" uri="urn:hl7-org:v3"/>
	<ns prefix="sdtc" uri="urn:hl7-org:sdtc" />
	
	<phase id="errors">
		<active pattern="PersonInformationModule"/>
		<active pattern="SupportModule"/>
		<active pattern="AllergiesDrugModule"/>
		<active pattern="ConditionsModule"/>
		<active pattern="MedicationsModule"/>
		<active pattern="InformationSourceModule"/>
		
		<active pattern="AdministrativeGender"/>
		<active pattern="MaritalStatus"/>
		<active pattern="ReligiousAffiliation"/>
		<active pattern="RaceCode" />
		<active pattern="EthnicityCode" />
		<active pattern="HumanLanguage" />
		<active pattern="ContactType"/>
		<active pattern="ContactRelationship"/>
		<active pattern="ProviderRole"/>
		<active pattern="ProviderType"/>
		<active pattern="CoverageRoleType"/>
		<active pattern="RoleClassRelationshipFormal"/>
		<active pattern="AdverseEventType"/>
	    <!--
	        Removing 2008/06/16: See note below
	        
	           <active pattern="AlertTypeCode" />
	           -->
	           <active pattern="AdverseEventProduct" />
		<active pattern="ProblemListSubset"/>
		<active pattern="ReactionSeverity"/>
		<active pattern="AllergyStatus"/>
		<active pattern="ProblemType"/>
		<active pattern="ProblemStatus"/>
		<active pattern="RouteOfAdministration" />
		<active pattern="DoseForm" />
		<active pattern="ProductName" />
		<active pattern="FillStatus"/>
		<active pattern="AdvanceDirectiveType"/>
		<active pattern="AdvanceDirectiveStatus"/>
		<active pattern="VaccineProduct" />
		<active pattern="ActNoImmunizationReason"/>
		<active pattern="VitalSigns"/>
	           <active pattern="ResultType" />
		<active pattern="ResultStatus"/>
		<active pattern="ObservationInterpretation" />
		<active pattern="ProcedureStatus"/>
		<active pattern="ResultTypeCode" />
		<active pattern="EncounterLocation" />
		
	</phase>

	<phase id="warning">
		<active pattern="InformationSourceModuleWarning"/>
	</phase>

            <phase id="note">
                <active pattern="CoverageType" />              
                <active pattern="EncounterType" />
            </phase>

	<pattern id="PersonInformationModule" name="PersonInformationModule">
		<rule context="/cda:ClinicalDocument">
			<!-- 
	     Verify that Summary Patient Record contains required Personal
	     Information.  This check is not actually needed because it is already
	     Required (R) in C32.
	     -->
			<assert test="count(./cda:recordTarget/cda:patientRole/cda:patient)=1">
				<!-- Verify that the Patient element exists  --> Error: In Summary Patient Record,
				Personal Information Module is a required Module. </assert>
		</rule>
	</pattern>
	<pattern id="SupportModule" name="SupportModule">
		<rule context="/cda:ClinicalDocument">
			<!--
	     Verify that Summary Patient Record contains required Support
	     Module.
	     -->
			<assert
				test="cda:recordTarget/cda:patientRole/cda:patient/cda:guardian or cda:participant[@typeCode='IND']"
				>Error: In Summary Patient Record, Support Module is a required Module. </assert>
		</rule>
	</pattern>
	
	<pattern id="AllergiesDrugModule" name="AllergiesDrugModule">
		<rule context="/cda:ClinicalDocument">
			<!--
	     Verify that Summary Patient Record contains required Allergies
	     and Drug Sensitivities Module.
	     -->
			
			<assert
				test=".//cda:templateId/@root='2.16.840.1.113883.3.88.11.32.6'"
				> Error: In Summary Patient Record, Allergies and Drug Sensitivities Module is a
				required Module. </assert>
		</rule>
	</pattern>
	<pattern id="ConditionsModule" name="ConditionsModule">
		<rule context="/cda:ClinicalDocument">
			<!-- Verify that Summary Patient Record contains required
	     Conditions Module (problem list).
	     -->
			<assert
				test=".//cda:templateId/@root='2.16.840.1.113883.3.88.11.32.7'"
				> Error: In Summary Patient Record, Conditions Module (problem list) is a required
				module. </assert>
		</rule>
	</pattern>
	<pattern id="MedicationsModule" name="MedicationsModule">
		<rule context="/cda:ClinicalDocument">
			<!-- Verify that Summary Patient Record contains required
	     Medications Module.
	     -->
			<assert
				test=".//cda:templateId/@root='2.16.840.1.113883.3.88.11.32.8'"
				> Error: In Summary Patient Record, Medications Module is a required Module.
			</assert>
		</rule>
	</pattern>
	<pattern id="InformationSourceModule" name="InformationSourceModule">
		<rule context="/cda:ClinicalDocument">
			<!--
	     Verify that Summary Patient Record contains required
	     Information Source Module.  This check is not actually needed
	     because it is already Required (R) in C32.
	     -->
			<assert test="cda:author"> Error: In Summary Patient Record, Information Source Module
				is a required Module. </assert>
		</rule>

		<!-- 
	     Additional constraints are taken from Section IV.E
	     -->

		<rule id="AttributingSourceAuthor" context="/cda:ClinicalDocument/cda:author">
			<assert
				test="./cda:assignedAuthor/cda:assignedPerson or
                              ./cda:assignedAuthor/cda:assignedAuthoringDevice"
				> Error: The author element SHALL identify either an individual
				(assignedAuthor/assignedPerson) or a system/device
				(assignedAuthor/assignedAuthoringDevice). See section IV. E of
				the Specification for Exchange of the Summary Patient Record.
			</assert>
		</rule>
	</pattern>

	<pattern id="InformationSourceModuleWarning" name="InformationSourceModuleWarning">
		<!--
             Additional constraints are taken from Section IV.E
             -->

		<rule context="/cda:ClinicalDocument/cda:author">
			<assert test="./cda:assignedAuthor/cda:representedOrganization"> Warning: The author
				element should identify an organization with which the person or device is
				associated (assignedAuthor/representedOrganization). See section IV. E of
				the Specification for Exchange of the Summary Patient Record.</assert>
		</rule>
	</pattern>
	
	
    <pattern id='AdministrativeGender' name='AdministrativeGender'>
        <rule context='/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.5.1" and
		           (@code="F" or @code="M" or @code="UN")'>
                Error: In Summary Patient Record, administrativeGenderCode
                SHALL use codeSystem="2.16.840.1.113883.5.1" and code=[F|M|UN].
            </assert>
        </rule>
    </pattern>
    
    <pattern id='MaritalStatus' name='MaritalStatus'>
        <rule context='/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:maritalStatusCode'>
	    <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.5.2" and
			  (@code="A" or	
                           @code="D" or
                           @code="T" or
                           @code="I" or
                           @code="L" or
                           @code="M" or
                           @code="S" or
                           @code="P" or
                           @code="W")'>
	        Error: In Summary Patient Record, maritalStatusCode SHALL use
		codeSystem="2.16.840.1.113883.5.2" and a code from the
		specified list (value set OID: 2.16.840.1.113883.1.11.12212).
		See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
	    </assert>
	</rule>
    </pattern>

    <pattern id='ReligiousAffiliation' name='ReligiousAffiliation'>
        <rule context='/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:religiousAffiliationCode'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.5.1076" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.5.1076"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, religiousAffiliationCode
                SHALL use codeSystem="2.16.840.1.113883.5.1076" and a code
                from the specified list (value set OID: 2.16.840.1.113883.1.11.19185).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='RaceCode' name='RaceCode'>
        <rule context='/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:raceCode |
                 /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/sdtc:raceCode '>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.238" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.6.238"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, raceCode SHALL use
                codeSystem="2.16.840.1.113883.6.238" and a code from the
                specified list (value set OID: 2.16.840.1.113883.1.11.14914).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    
    <pattern id='EthnicityCode' name='EthnicityCode'>
        <rule context='/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.238" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.6.238"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, ethnicGroupCode SHALL use
                codeSystem="2.16.840.1.113883.6.238" and a code from the
                specified list (value set OID: 2.16.840.1.113883.1.11.15836). 
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    
    <pattern name="HumanLanguage" id="HumanLanguage">
        <rule context='/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:languageCommunication/cda:languageCode'>
            <assert test='@nullFlavor or
                (
                string-length(current()/@code) = 5
                and
                substring( current()/@code , 1, 2 ) = document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.6.121"]/code/@value
                and
                substring( current()/@code , 3, 1 ) = "-"
                and
                substring( current()/@code, 4, 2) = document("codeSystems.xml")/systems/system[@root="2.16.1"]/code/@value                                
                )                
                or
                (
                string-length(current()/@code) = 6
                and
                substring( current()/@code , 1, 3 ) = document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.6.121"]/code/@value
                and
                substring( current()/@code , 4, 1 ) = "-"
                and
                substring( current()/@code, 5, 2) = document("codeSystems.xml")/systems/system[@root="2.16.1"]/code/@value                                
                )
                ' >                
                Error: In Summary Patient Record, human langauge SHALL use
                a code from the specified list (value set OID: 2.16.840.1.113883.1.11.11526).  
                The code consists of a two or three letter language code (ISO 639-2) followed by 
                a hyphen, followed by a two letter country code (ISO 3166).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>

    
        </rule>
    </pattern>
    
    
    <!--
    <pattern id='HumanLanguage' name='HumanLanguage'>
        <rule context='/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:languageCommunication/cda:languageCode'>
        	<assert test='@nullFlavor or document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.6.121"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, human langauge SHALL use
                a code from the specified list (value set OID: 2.16.840.1.113883.1.11.11526). 
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    -->
    <pattern id='ContactType' name='ContactType'>
        <rule
        context='/cda:ClinicalDocument/cda:participant/cda:associatedEntity |
                 /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian'>
        	<assert test='@classCode="AGNT" or
                @classCode="CAREGIVER" or
                @classCode="ECON" or
                @classCode="GUARD" or
                @classCode="NOK" or
                @classCode="PRS"'>
                Error: In Summary Patient Record, contact type SHALL use
                a classCode from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.3.2).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='ContactRelationship' name='ContactRelationship'>
        <rule
            context='/cda:ClinicalDocument/cda:participant/cda:associatedEntity/cda:code |
            /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.5.111" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.5.111"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, contact relationship SHALL
                use codeSystem="2.16.840.1.113883.5.111" and a code from
                the specified list (value set OID: 2.16.840.1.113883.1.11.19579).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='ProviderRole' name='ProviderRole'>
        <rule context='/cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:functionCode'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.12.443" and
		          (@code="CP" or
			   @code="PP" or
			   @code="RP")'>
                Error: In Summary Patient Record, provider role SHALL use
		codeSystem="2.16.840.1.113883.12.443" and code=[CP|PP|RP].
            </assert>
        </rule>
    </pattern>
    
    <pattern id='ProviderType' name='ProviderType'>
        <rule context='/cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:assignedEntity/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.101" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.6.101"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, provider type SHALL use
                codeSystem="2.16.840.1.113883.6.101" and a code
                from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.4.4).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    
    <pattern id='CoverageType' name='CoverageType' >
        <rule context='//cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.26"]/cda:code'>
            <report test=".">
                Note: In Summary Patient Record, for coverage type the value set 
                (OID: 2.16.840.1.113883.3.88.12.3221.5.2) is based 
                on X12N Data Element 1336.  However, the X12N 270/271
                Implementation Guide contains the values for this value set and 
                this document is not freely available.  Please make certain that
                the code element conforms to this code system and code set.
            </report>                    
        </rule>
    </pattern>
    <pattern id='CoverageRoleType' name='CoverageRoleType'>
        <rule context='//cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.26"]/cda:participant[@typeCode="COV"]/cda:participantRole[@classCode="PAT"]/cda:code'>
	    <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.5.111" and
	                  (@code="STUD" or
			   @code="FSTUD" or
                           @code="PSTUD" or
                           @code="FAMDEP" or
                           @code="HANDIC" or
                           @code="INJ" or
                           @code="SELF" or
                           @code="SPON")'>
	        Error: In Summary Patient Record, coverage role type SHALL use
		codeSystem="2.16.840.1.113883.5.111" and a code from the
		specified list (value set OID: 2.16.840.1.113883.1.11.19809).  See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
	    </assert>
	</rule>
    </pattern>
    
    <pattern id='RoleClassRelationshipFormal' name='RoleClassRelationshipFormal'>
        <rule context='//cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.26"]/cda:performer/cda:assignedEntity/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.5.110" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.5.110"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, role class relationship
                formal SHALL use codeSystem="2.16.840.1.113883.5.110" and
                a code from the specified list (value set OID: 2.16.840.1.113883.1.11.10416).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    
    <pattern id='AdverseEventType' name='AdverseEventType'>
        <rule context='//cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.27"]/cda:entryRelationship[@typeCode="SUBJ"]/cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.18"]/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.96" and 
		                  (@code="420134006" or
				   @code="418038007" or
                                   @code="419511003" or
                                   @code="418471000" or
                                   @code="419199007" or
                                   @code="416098002" or
                                   @code="414285001" or
                                   @code="59037007" or
                                   @code="235719002")'>
                Error: In Summary Patient Record, adverse event type SHALL use
		codeSystem="2.16.840.1.113883.6.96" and a code from the
		specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.6.2).  
		See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    <!--
        
        Removing 2008/06/16: An act doesn't have a value...
        
    <pattern id="AlertTypeCode" name="AlertTypeCode">
        <rule context='//cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.27"]/cda:value'>
            <assert test='@nullFlavor or (@codeSystem="2.16.840.1.113883.6.96" and (@code="106190000" or @code="281647001"))'>                
                Error: In Summary Patient Record, alert type code SHALL use codeSystem="2.16.840.1.113883.6.96"
                and code = "106190000" (Allergy) or code = "281647001" (Adverse Reaction).
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.                
            </assert>            
        </rule>
    </pattern>
    -->
    <pattern id="AdverseEventProduct" name="AdverseEventProduct">
        <rule context='//cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.27"]/cda:entryRelationship[@typeCode="SUBJ"]/cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.18"]/cda:participant[@typeCode="CSM"]/cda:participantRole[@classCode="MANU"]/cda:playingEntity[@classCode="MMAT"]/cda:code'> 
            <assert test='@nullFlavor or 
                (@codeSystem="2.16.840.1.113883.6.69") or
                (@codeSystem="2.16.840.1.113883.4.9" and document("unii.xml")/systems/system[@root="2.16.840.1.113883.4.9"]/code[@value = current()/@code]) or
                (@codeSystem="2.16.840.1.113883.4.209" and document("ndf-rt.xml")/systems/system[@root="2.16.840.1.113883.4.209"]/code[@value = current()/@code]) or
                (@codeSystem="2.16.840.1.113883.6.88" )                
                '>
                Error: In Summary Patient Record, adverse event product SHALL use
                a codeSystem and a code from the specified list 
                (value set OID: 2.16.840.1.113883.3.18.6.1.10).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    
    
    <!--         <rule context='cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.27"]/cda:entryRelationship[@typeCode="SUBJ"]/cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.18"]/cda:participant[@typeCode="CSM"]/cda:participantRole[@classCode="MANU"]/cda:playingEntity[@classCode="MAMT"]/cda:code'>
    -->    
    
    <pattern id='ProblemListSubset' name='ProblemListSubset'>
        <rule context='//cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.54"]/cda:value |
		         //cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.27"]/cda:entryRelationship[@typeCode="SUBJ"]/cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.28"]/cda:value |
	                    //cda:substanceAdministration[cda:templateId/@root="2.16.840.1.113883.10.20.1.24"]/cda:consumable/cda:manufacturedProduct/cda:entryRelationship[@typeCode="RSON"]/ cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.28"]/cda:value'>                              
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.96" and
				document("problemListSubset.xml")/systems/system[@root="2.16.840.1.113883.6.96"]/code[@value = current()/@code]'>
				Error: In Summary Patient Record, problem list subset SHALL
				use codeSystem="2.16.840.1.113883.6.96" and a code from the
				specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.7.4).  
				See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
	 </assert>
        </rule>
    </pattern>
   
    <pattern id='ReactionSeverity' name='ReactionSeverity'>
        <rule context='//cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.55"]/cda:value'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.96" and 
	                 (@code="255604002" or
			  @code="371923003" or
                          @code="6736007" or
                          @code="371924009" or
                          @code="24484000" or
                          @code="399166001")'>
                Error: In Summary Patient Record, reaction severity SHALL use
		codeSystem="2.16.840.1.113883.6.96" and a code from the
		specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.6.8).  
		See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='AllergyStatus' name='AllergyStatus'>
        <rule context='//cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.55"]/cda:entryRelationship/cda:observation[cda:code/@code="33999-4"]/cda:value'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.96" and
                (@code="55561003" or
                @code="392521001" or
                @code="73425007")'>
                Error: In Summary Patient Record, allergy status SHALL use 
                codeSystem="2.16.840.1.113883.6.96" and a code from the
                specified list (value set OID: 2.16.840.1.113883.1.11.20.3).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    
    <pattern id='ProblemType' name='ProblemType'>
        <rule context='//cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.27"]/cda:entryRelationship[@typeCode="SUBJ"]/cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.28"]/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.96" and
		         (@code="404684003" or
			  @code="418799008" or
                          @code="55607006" or
                          @code="409586006" or
                          @code="64572001" or
                          @code="282291009" or
                          @code="248536006")'>
                Error: In Summary Patient Record, problem type SHALL use
		codeSystem="2.16.840.1.113883.6.96" and a code from the
		specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.7.2).  
		See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

   <pattern id='ProblemStatus' name='ProblemStatus'>
        <rule
        context='//cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.27"]/cda:entryRelationship[@typeCode="SUBJ"]/cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.28"]/cda:entryRelationship/cda:observation[cda:code/@code="33999-4"]/cda:value'>
            <assert test='@nullFlavor or (@codeSystem="2.16.840.1.113883.6.96" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.6.96"]/code[@value = current()/@code])'>
                Error: In Summary Patient Record, problem status SHALL use
                codeSystem="2.16.840.1.113883.6.96" and a code from the
                specified list (value set OID: 2.16.840.1.113883.3.18.6.1.10).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='RouteOfAdministration' name='RouteOfAdministration'>
        <rule context='//cda:substanceAdministration[cda:templateId/@root="2.16.840.1.113883.10.20.1.24"]/cda:routeCode'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.3.26.1.1" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.3.26.1.1"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, route of administration
                SHALL use codeSystem="2.16.840.1.113883.3.26.1.1" and
                a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.8.7).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='DoseForm' name='DoseForm'>
        <rule
        context='//cda:substanceAdministration[cda:templateId/@root="2.16.840.1.113883.10.20.1.24"]/cda:administrationUnitCode'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.3.26.1.1" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.3.26.1.1"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, dose form
                SHALL use codeSystem="2.16.840.1.113883.3.26.1.1" and
                a code from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.8.11).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>


    <pattern id='ProductName' name='ProductName'>
        <rule context='//cda:substanceAdministration[cda:templateId/@root="2.16.840.1.113883.10.20.1.24" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.8"]/cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code |
                              //cda:participant/cda:participantRole[cda:code/@code = "412307009" and cda:code/@codeSystem="2.16.840.1.113883.6.96"]/cda:playingEntity/cda:code'>                   
            <assert test='@nullFlavor or 
                (@codeSystem="2.16.840.1.113883.6.69" and document("productName.xml")/systems/system[@root="2.16.840.1.113883.6.69"]/code[@value = current()/@code]) or
                (@codeSystem="2.16.840.1.113883.4.9" and document("unii.xml")/systems/system[@root="2.16.840.1.113883.4.9"]/code[@value = current()/@code]) or
                (@codeSystem="2.16.840.1.113883.4.209" and document("ndf-rt.xml")/systems/system[@root="2.16.840.1.113883.4.209"]/code[@value = current()/@code]) or
                (@codeSystem="2.16.840.1.113883.6.88" )
                
                '>
                Error: In Summary Patient Record, product name SHALL use
                a codeSystem and a code from the specified list 
                (value set OID: 2.16.840.1.113883.3.88.12.3221.8.13).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='FillStatus' name='FillStatus'>
        <rule context='//cda:substanceAdministration[cda:templateId/@root="2.16.840.1.113883.10.20.1.24"]/cda:entryRelationship/cda:supply[@moodCode="EVN"]/cda:statusCode'>
        	<assert test='@nullFlavor or @code="aborted" or
                          @code="completed"'>
                Error: In Summary Patient Record, fill status SHALL code=[aborted|completed].
            </assert>
        </rule>
    </pattern>

    <pattern id='AdvanceDirectiveType' name='AdvanceDirectiveType'>
        <rule context='//cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.17" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.13"]/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.96" and
                         (@code="304251008" or
			  @code="52765003" or
                          @code="225204009" or
                          @code="89666000" or
                          @code="281789004" or
                          @code="78823007" or
                          @code="61420007" or
                          @code="71388002")'>
                Error: In Summary Patient Record, advance directive type SHALL
		use codeSystem="2.16.840.1.113883.6.96" and a code from the
		specified list (value set OID: 2.16.840.1.113883.1.11.20.2).  
		See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    <pattern id='AdvanceDirectiveStatus' name='AdvanceDirectiveStatus'>
        <rule context='//cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.17"]/cda:entryRelationship/cda:observation/cda:value'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.96" and
                          (@code="425392003" or
                           @code="425394002" or
                           @code="425393008" or
                           @code="425396000" or
                           @code="310305009")'>
                Error: In Summary Patient Record, advance directive status
		SHALL use codeSystem="2.16.840.1.113883.6.96" and a code from
		the specified list (value set OID: 2.16.840.1.113883.1.11.20.1).  See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='VaccineProduct' name='VaccineProduct'>
        <rule context='//cda:substanceAdministration[cda:templateId/@root="2.16.840.1.113883.10.20.1.24" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.14"]/cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.59" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.6.59"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, vaccine product SHALL use
                codeSystem="2.16.840.1.113883.6.59" and a code
                from the specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.13.6).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='ActNoImmunizationReason' name='ActNoImmunizationReason'>
        <rule context='//cda:substanceAdministration[cda:templateId/@root="2.16.840.1.113883.10.20.1.24" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.14"]/cda:entryRelationship[@typeCode="RSON"]/cda:act[cda:templateId/@root="2.16.840.1.113883.10.20.1.27"]/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.5.8" and
                         (@code="IMMUNE" or
			  @code="MEDPREC" or
                          @code="OSTOCK" or
                          @code="PATOBJ" or
                          @code="PHILISOP" or
                          @code="RELIG" or
                          @code="VACEFF" or
                          @code="VACSAF")'>
                Error: In Summary Patient Record, act no immunization reason
		SHALL use codeSystem="2.16.840.1.113883.5.8" and a code from
		the specified list (value set OID: 2.16.840.1.113883.11.19725).  See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='VitalSigns' name='VitalSigns'>
        <rule context='//cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.14" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.15"]/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.1" and
                         (@code="9279-1" or
			  @code="8867-4" or
                          @code="2710-2" or
                          @code="8480-6" or
                          @code="8462-4" or
                          @code="8310-5" or
                          @code="8302-2" or
                          @code="8306-3" or
                          @code="8287-5" or
                          @code="3141-9")'>
                Error: In Summary Patient Record, vital sign SHALL use
		codeSystem="2.16.840.1.113883.6.1" and a code from the
		specified list (value set OID: 2.16.840.1.113883.3.88.12.3221.15.3.103).  
		See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id="ResultType" name="ResultType">
        <rule context='//cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.14" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.16"]/cda:code'>            
            <assert test='@nullFlavor or @codeSystem = "2.16.840.1.113883.6.1" and
                document("resultType.xml")/systems/system[@root="2.16.840.1.113883.6.1"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, result code SHALL use
                codeSystem="2.16.840.1.113883.6.1" and a code from the
                specified list (value set OID: 2.16.840.1.113883.3.18.6.1.12).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.                
            </assert>            
        </rule>        
    </pattern>

    <pattern id='ResultStatus' name='ResultStatus'>
        <rule context='//cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.14" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.15"]/cda:statusCode |
            //cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.14" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.16"]/cda:statusCode |
            //cda:section[cda:templateId/@root="2.16.840.1.113883.10.20.1.12"]/cda:entry/cda:organizer/cda:statusCode'>
        	<assert test='@nullFlavor or @code="aborted" or
			  @code="completed" or
                          @code="active" or
                          @code="cancelled" or
                          @code="held" or
                          @code="new" or
                          @code="suspended"'>
                Error: In Summary Patient Record, result status SHALL use
		a code from the
		specified list (value set OID: 2.16.840.1.113883.1.11.15936).  
		See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    
    <pattern id='ObservationInterpretation' name='ObservationInterpretation'>       
        <rule context='//cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.14" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.15"]/cda:interpretationCode |
            //cda:observation[cda:templateId/@root="2.16.840.1.113883.10.20.1.14" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.16"]/cda:interpretationCode'>                            
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.5.83" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.5.83"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, result status SHALL use
                codeSystem="2.16.840.1.113883.5.83" and a code from the
                specified list (value set OID: 2.16.840.1.113883.1.11.78).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='EncounterType' name='EncounterType'>
        <rule context='//cda:encounter[cda:templateId/@root="2.16.840.1.113883.10.20.1.21" and cda:templateId/@root="2.16.840.1.113883.3.88.11.32.17"]/cda:code'>
            <report test='.'>
                Note: In Summary Patient Record, for encounter type the value set 
                (OID: 2.16.840.1.113883.3.88.12.3221.16.2) is based 
                on CPT-4.  However, CPT-4 codes are licensed by the AMA and 
                are not freely available. .  Please make certain that
                the code element conforms to this code system and code set.       
            </report>                           
        </rule>
    </pattern>
        
    <pattern id='ProcedureStatus' name='ProcedureStatus'>
        <rule context='//cda:section[cda:templateId/@root="2.16.840.1.113883.10.20.1.12"]/cda:entry/cda:procedure[cda:templateId/@root="2.16.840.1.113883.10.20.1.29"]/cda:statusCode'>
        	<assert test='@nullFlavor or @code="cancelled" or
                @code="held" or
                @code="active" or
                @code="aborted" or
                @code="completed"'>
                Error: In Summary Patient Record, procedure status SHALL use
                codeSystem="2.16.840.1.113883.5.14" and a code from the
                specified list (value set OID: 2.16.840.1.113883.1.11.20.15).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>

    <pattern id='ResultTypeCode' name='ResultTypeCode'>
        <rule context='//cda:section[cda:templateId/@root="2.16.840.1.113883.10.20.1.12"]/cda:entry/cda:organizer/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.6.96" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.6.96"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, result type code SHALL use
                codeSystem="2.16.840.1.113883.6.96" and a code from the
                specified list (value set OID: 2.16.840.1.113883.1.11.20.16).  
                See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
    <pattern id='EncounterLocation' name='EncounterLocation'>
        <rule context='//cda:section[cda:templateId/@root="2.16.840.1.113883.10.20.1.12"]/cda:entry/cda:encounter/cda:participant[@typeCode="LOC"]/cda:participantRole/cda:code'>
            <assert test='@nullFlavor or @codeSystem="2.16.840.1.113883.5.111" and
                document("codeSystems.xml")/systems/system[@root="2.16.840.1.113883.5.111"]/code[@value = current()/@code]'>
                Error: In Summary Patient Record, encounter location SHALL use
                codeSystem="2.16.840.1.113883.5.111" and a code from the
                specified list (value set OID: 2.16.840.1.113883.1.11.17660).  See NHIN Core Content Specificiation for Exchange of Summary Patient Record (April 2008) document and related spreadsheet.
            </assert>
        </rule>
    </pattern>
	
</schema>
