<?xml version="1.0" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:cda="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" cda:dummy-for-xmlns="" sdtc:dummy-for-xmlns="" xsi:dummy-for-xmlns="">
  <axsl:output xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>
  <axsl:template match="*|@*" mode="schematron-get-full-path">
    <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
    <axsl:text>/</axsl:text>
    <axsl:if test="count(. | ../@*) = count(../@*)">@</axsl:if>
    <axsl:value-of select="name()"/>
    <axsl:text>[</axsl:text>
    <axsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
    <axsl:text>]</axsl:text>
  </axsl:template>
  <axsl:template match="/">
    <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" title="HITSP_C32" schemaVersion="">
      <axsl:attribute name="phase">errors</axsl:attribute>
      <marker/>
      <svrl:ns-prefix-in-attribute-values uri="urn:hl7-org:v3" prefix="cda"/>
      <svrl:ns-prefix-in-attribute-values uri="urn:hl7-org:sdtc" prefix="sdtc"/>
      <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.1-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M8"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.2-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M11"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.3-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M14"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.4-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M17"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.5-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M21"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.6-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M25"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.7-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M29"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.8-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M33"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.9-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M37"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.10-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M41"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.11-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M45"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.12-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M49"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.13-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M53"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.14-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M57"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.15-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M61"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.16-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M65"/>
      <svrl:active-pattern>
        <axsl:attribute name="id">p-2.16.840.1.113883.3.88.11.32.17-errors</axsl:attribute>
        <axsl:apply-templates/>
      </svrl:active-pattern>
      <axsl:apply-templates select="/" mode="M69"/>
    </svrl:schematron-output>
  </axsl:template>
  <axsl:template match="/" priority="4000" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/"/>
    <axsl:choose>
      <axsl:when test="//cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="//cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A CDA Document shall declare conformance to HITSP/C32 by including a templateId element with the root attribute set to the value 2.16.840.1.113883.3.88.11.32.1. See Section 2.2.1.1 Rule C32-[1].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]" priority="3999" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]"/>
    <axsl:choose>
      <axsl:when test="self::cda:ClinicalDocument"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="self::cda:ClinicalDocument">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall be an HL7 CDA Clinical Document and the HITSP/C32 templateId (2.16.840.1.113883.3.88.11.32.1) shall appear on the root element. See Section 2.2.1.1 Rule C32-[1].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 document shall carry the template identifier for the ASTM/HL7 CCD Implementation Guide (2.16.840.1.113883.10.20.1) from which it is derived. See Section 2.2.1.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="count(./cda:recordTarget/cda:patientRole/cda:patient)=1"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="count(./cda:recordTarget/cda:patientRole/cda:patient)=1">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain Person Information for exactly one Patient. See HITSP/C32 Table 2.2.1-2 and Section 2.2.1.2 table 2.2.1.2-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="/cda:ClinicalDocument" priority="3998" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/cda:ClinicalDocument"/>
    <axsl:choose>
      <axsl:when test="cda:effectiveTime"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:effectiveTime">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Document Timestamp data element See Table 2.2.1.2-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:recordTarget/cda:patientRole"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:recordTarget/cda:patientRole">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Patient Information data element. See Table 2.2.1.2-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:recordTarget/cda:patientRole/cda:id"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:recordTarget/cda:patientRole/cda:id">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Person ID data element for the Patient Role. See Table 2.2.1.2-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:recordTarget/cda:patientRole/cda:addr"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:recordTarget/cda:patientRole/cda:addr">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Person Address data element for the Patient Role. Multiple addresses are possible to identify temporary addresses, vacation home addresses, work addresses, etc. Exactly one address for a patient should have a use attribute with a value set to HP (home permanent). Others may be set to HV (vacation) or WP (work place), etc. See Table 2.2.1.2-2 and Section 2.2.1.2.2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:recordTarget/cda:patientRole/cda:telecom"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:recordTarget/cda:patientRole/cda:telecom">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Person Phone/Email/URL data element for the Patient Role. Multiple telecom instances are used to record multiple telephone numbers, Fax numbers, email addresses, etc. The Use code on telecom is used to indicate the following: HP (home phone), HV (vacation home phone), WP (work phone), MC (mobile phone), etc. Telephone numbers shall be represented in international form, e.g. tel:+1-ddd-ddd-dddd;ext=dddd for U.S. numbers. Hyphens and parentheses are ignored. Email addresses shall use the mailto: URL scheme from RFC-2368. See Table 2.2.1.2-2 and Section 2.2.1.2.3.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:recordTarget/cda:patientRole/cda:patient"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:recordTarget/cda:patientRole/cda:patient">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Personal Information data element for the Patient Role. See Table 2.2.1.2-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:recordTarget/cda:patientRole/cda:patient/cda:name"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:recordTarget/cda:patientRole/cda:patient/cda:name">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Person Name data element for the Patient. See Table 2.2.1.2-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Person Gender data element for the Patient. See Table 2.2.1.2-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:recordTarget/cda:patientRole/cda:patient/cda:birthTime"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:recordTarget/cda:patientRole/cda:patient/cda:birthTime">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Person Date of Birth data element for the Patient. See Table 2.2.1.2-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient" priority="3997" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient"/>
    <axsl:choose>
      <axsl:when test="cda:name/cda:family"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:name/cda:family">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Patient Family name part. See Section 2.2.1.2.1 rule C32-[2].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:name/cda:given"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:name/cda:given">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: HITSP/C32 shall contain a Patient Given name part. See Section 2.2.1.2.1 rule C32-[3].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="count(cda:name[@use=&quot;L&quot;])=0 or count(cda:name[@use=&quot;L&quot;])=1"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="count(cda:name[@use=&quot;L&quot;])=0 or count(cda:name[@use=&quot;L&quot;])=1">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: At most one C32 Patient Name shall have a use element set to legal (L). See Section 2.2.1.2.1 rule C32-[6].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:addr" priority="3996" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:addr"/>
    <axsl:choose>
      <axsl:when test="@nullFlavor or (cda:country | cda:state | cda:city | cda:streetAddressLine | cda:postalCode)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="@nullFlavor or (cda:country | cda:state | cda:city | cda:streetAddressLine | cda:postalCode)">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: Each HITSP/C32 Patient address part shall be identified using the streetAddressLine, city, state, postalCode and country tags. See Section 2.2.1.2.2 rule C32-[12].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="count(cda:streetAddressLine) &lt; 5"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="count(cda:streetAddressLine) &lt; 5">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: Each HITSP/C32 Patient address shall contain no more than 4 streetAddressLine elements. See Section 2.2.1.2.2 rule C32-[14].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:country) or cda:country[string-length()=2]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:country) or cda:country[string-length()=2]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: Each HITSP/C32 Patient Country address part shall be recorded using ISO-3166-1 2-character codes. CHECK list. See Section 2.2.1.2.2 rule C32-[22].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:telecom" priority="3995" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:telecom"/>
    <axsl:choose>
      <axsl:when test="@nullFlavor or @value[substring(string(),1,5)=&quot;tel:+&quot;]                               or @value[substring(string(),1,7)=&quot;mailto:&quot;]                              or @value[substring(string(),1,4)=&quot;fax:&quot;]                              or @value[substring(string(),1,5)=&quot;http:&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="@nullFlavor or @value[substring(string(),1,5)=&quot;tel:+&quot;] or @value[substring(string(),1,7)=&quot;mailto:&quot;] or @value[substring(string(),1,4)=&quot;fax:&quot;] or @value[substring(string(),1,5)=&quot;http:&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: Each HITSP/C32 Patient Phone/Email element shall contain a telephone number using the tel: URL scheme, an Email address using the mailto: URL scheme, a Fax telephone using fax: URL scheme, or an http: URL referencing other contact information. US phone numbers should be of form tel:+1-ddd-ddd-dddd;ext=dddd where hyphens and parentheses are optional and are not considered significant in comparisons. See Section 2.2.1.2.3 rules C32-[23], C32-[24], C32-[25] and C32-[31].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode" priority="3994" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode"/>
    <axsl:choose>
      <axsl:when test="(@codeSystem=&quot;2.16.840.1.113883.5.1&quot; and (@code=&quot;F&quot; or @code=&quot;M&quot; or @code=&quot;UN&quot;))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="(@codeSystem=&quot;2.16.840.1.113883.5.1&quot; and (@code=&quot;F&quot; or @code=&quot;M&quot; or @code=&quot;UN&quot;))">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Patient Gender shall be coded using the HL7 AdministrativeGenderCode code system (2.16.840.1.113883.5.1). The codes are: Male (M), Female (F), Undifferentiated (UN). See Section 2.2.1.2.4 rule C32-[32].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:maritalStatusCode" priority="3993" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:maritalStatusCode"/>
    <axsl:choose>
      <axsl:when test="(@code and @codeSystem=&quot;2.16.840.1.113883.5.2&quot;) or @nullFlavor or cda:originalText"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="(@code and @codeSystem=&quot;2.16.840.1.113883.5.2&quot;) or @nullFlavor or cda:originalText">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Marital Status, if known, shall be coded using the HL7 MaritalStatus code system (2.16.840.1.113883.5.2). CHECK code list. See Section 2.2.1.2.5 rule C32-[33].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:raceCode" priority="3992" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:raceCode"/>
    <axsl:choose>
      <axsl:when test="(@code and @codeSystem=&quot;2.16.840.1.113883.6.238&quot;) or @nullFlavor or cda:originalText"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="(@code and @codeSystem=&quot;2.16.840.1.113883.6.238&quot;) or @nullFlavor or cda:originalText">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Race, if known, shall be coded using the CDC Race and Ethnicity code system (2.16.840.1.113883.6.238). CHECK code list. See Section 2.2.1.2.6 rule C32-[34].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode" priority="3991" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode"/>
    <axsl:choose>
      <axsl:when test="(@code and @codeSystem=&quot;2.16.840.1.113883.6.238&quot;) or @nullFlavor or cda:originalText"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="(@code and @codeSystem=&quot;2.16.840.1.113883.6.238&quot;) or @nullFlavor or cda:originalText">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Ethnicity Group, if known, shall be coded using the CDC Race and Ethnicity code system (2.16.840.1.113883.6.238). CHECK code list. See Section 2.2.1.2.7 rule C32-[36].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:religiousAffiliationcode" priority="3990" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.1&quot;]/cda:recordTarget/cda:patientRole/cda:patient/cda:religiousAffiliationcode"/>
    <axsl:choose>
      <axsl:when test="(@code and @codeSystem=&quot;2.16.840.1.113883.5.1076&quot;) or @nullFlavor or cda:originalText"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="(@code and @codeSystem=&quot;2.16.840.1.113883.5.1076&quot;) or @nullFlavor or cda:originalText">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Religious Affiliation, if known, shall be coded using the HL7 Religious Affiliation code system (2.16.840.1.113883.5.1076). See Section 2.2.1.2.8 rule C32-[38].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[cda:author]" priority="3989" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:author]"/>
    <axsl:choose>
      <axsl:when test="cda:author[1]/cda:time"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:author[1]/cda:time">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Document, Section or Entry First Author shall contain a C32 Author Time element. See Section 2.2.1.11 table 2.2.1.11-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[self::cda:author]" priority="3988" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[self::cda:author]"/>
    <axsl:choose>
      <axsl:when test="cda:assignedAuthor//cda:name[* or @nullFlavor or string-length(normalize-space()) &gt; 2]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:assignedAuthor//cda:name[* or @nullFlavor or string-length(normalize-space()) &gt; 2]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Document, Section or Entry Author shall contain a non-empty C32 Author Name element. The Name may be under assignedAuthor/assignedPerson or it may be under assignedAuthor/representedOrganization, or both. See Section 2.2.1.11 table 2.2.1.11-2 and rule c32-[162].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[self::cda:externalDocument][parent::cda:reference]" priority="3987" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[self::cda:externalDocument][parent::cda:reference]"/>
    <axsl:choose>
      <axsl:when test="cda:id"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:id">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Section or Entry External Reference shall contain a C32 Reference document ID element. See Section 2.2.1.11 table 2.2.1.11-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="*[self::cda:informant]" priority="3986" mode="M8">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[self::cda:informant]"/>
    <axsl:choose>
      <axsl:when test="//cda:name[* or @nullFlavor or string-length(normalize-space()) &gt; 2] or //sdtc:patient"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="//cda:name[* or @nullFlavor or string-length(normalize-space()) &gt; 2] or //sdtc:patient">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Section or Entry Informant shall contain a C32 Information source Name element. The Name may be under assignedEntity/assignedPerson, assignedEntity/representedOrganization, or relatedEntity/relatedPerson, or the informant may be the patient. See Section 2.2.1.11 table 2.2.1.11-2 and rules C32-[162] and C32-[163].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M8"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M8"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.2&quot;]" priority="4000" mode="M11">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.2&quot;]"/>
    <axsl:choose>
      <axsl:when test="self::cda:languageCommunication"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="self::cda:languageCommunication">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Spoken Language (2.16.840.1.113883.3.88.11.32.2) is in the wrong location. The HITSP/C32 Language Spoken module is represented as a CDA languageCommunication element. The C32 templateId for Spoken Language may optionally be included on the CDA languageCommunication element.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M11"/>
  </axsl:template>
  <axsl:template match="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient" priority="3999" mode="M11">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient"/>
    <axsl:choose>
      <axsl:when test="cda:languageCommunication"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:languageCommunication">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A Patient Language of communication shall appear in a languageCommunication element appearing beneath the patient element. Multiple languageCommunication elements are permitted. See Section 2.2.1.3.1 rule C32-[39].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M11"/>
  </axsl:template>
  <axsl:template match="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/child::cda:languageCommunication" priority="3998" mode="M11">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/child::cda:languageCommunication"/>
    <axsl:choose>
      <axsl:when test="cda:languageCode"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:languageCode">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A Patient Language of communication element shall contain a languageCode element set to a code for the language of communication. For example American English (en-US), American sign Language (sgn-US). See Section 2.2.1.3.1 rule C32-[40].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:modeCode) or cda:modeCode[(@code=&quot;ESGN&quot; or @code=&quot;ESP&quot; or @code=&quot;EWR&quot;                                                   or @code=&quot;RSGN&quot; or @code=&quot;RSP&quot; or @code=&quot;RWR&quot;)                                                and @codeSystem=&quot;2.16.840.1.113883.5.60&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:modeCode) or cda:modeCode[(@code=&quot;ESGN&quot; or @code=&quot;ESP&quot; or @code=&quot;EWR&quot; or @code=&quot;RSGN&quot; or @code=&quot;RSP&quot; or @code=&quot;RWR&quot;) and @codeSystem=&quot;2.16.840.1.113883.5.60&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: If the Patient Language element contains a modeCode element to express types of language expression, then that code shall come from the HL7 LanguageAbilityMode code system (2.16.840.1.113883.5.60), which specifies the following codes: ESGN (expressed signed), ESP (expressed spoken), EWR (expressed written), RSGN (received signed), RSP (received spoken), RWR (received written). See Section 2.2.1.3.1 rule C32-[44].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M11"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M11"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.3&quot;]" priority="4000" mode="M14">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.3&quot;]"/>
    <axsl:choose>
      <axsl:when test="(parent::cda:patient and self::cda:guardian[@classCode =&quot;GUARD&quot;])               or (parent::cda:ClinicalDocument and self::cda:participant[@typeCode=&quot;IND&quot;])"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="(parent::cda:patient and self::cda:guardian[@classCode =&quot;GUARD&quot;]) or (parent::cda:ClinicalDocument and self::cda:participant[@typeCode=&quot;IND&quot;])">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Support (2.16.840.1.113883.3.88.11.32.3) is in the wrong location. The C32 Support module shall be represented as a CDA Guardian under CDA Patient, or as a CDA Participant (indirect participant IND) directly under ClinicalDocument. The C32 templateId for the Support module may optionally be included on either of these CDA elements.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M14"/>
  </axsl:template>
  <axsl:template match="cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian" priority="3999" mode="M14">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian"/>
    <axsl:choose>
      <axsl:when test="cda:guardianPerson/cda:name/*"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:guardianPerson/cda:name/*">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 Patient Guardian element shall contain a non-empty Guardian Person Name element. See Table 2.2.1.4-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="self::cda:guardian[@classCode=&quot;GUARD&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="self::cda:guardian[@classCode=&quot;GUARD&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The C32 Contact Type element shall be expressed as GUARD in the classCode of the Guardian. See Section 2.2.1.4 rule C31-[49].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:code) or cda:code[@code and @codeSystem=&quot;2.16.840.1.113883.5.111&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:code) or cda:code[@code and @codeSystem=&quot;2.16.840.1.113883.5.111&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Contact Relationship should be recorded in the code element beneath the Guardian element. If the code is present, the code value shall be drawn from the HL7 PersonalRelationshipRoleType value set (2.16.840.1.113883.1.11.19563) drawn from the HL7 RoleCode code system (2.16.840.1.113883.5.111). There are 72 possible codes in the value set (e.g. GRMTH, STPDAU, etc). CHECK list. See Section 2.2.1.4.2 rule C31-[51].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M14"/>
  </axsl:template>
  <axsl:template match="cda:ClinicalDocument/cda:participant/cda:associatedEntity" priority="3998" mode="M14">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:ClinicalDocument/cda:participant/cda:associatedEntity"/>
    <axsl:choose>
      <axsl:when test="../cda:time"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="../cda:time">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 Support Participant data element shall contain a Date element. See Table 2.2.1.4-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:associatedPerson/cda:name/* or cda:associatedPerson/cda:name[string-length(normalize-space()) &gt; 2]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:associatedPerson/cda:name/* or cda:associatedPerson/cda:name[string-length(normalize-space()) &gt; 2]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 Support Participant Contact element shall contain a non-empty C32 Contact Name element. See Table 2.2.1.4-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="self::cda:associatedEntity[@classCode=&quot;AGNT&quot; or @classCode=&quot;CAREGIVER&quot;                   or @classCode=&quot;ECON&quot; or @classCode=&quot;NOK&quot; or @classCode=&quot;PRS&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="self::cda:associatedEntity[@classCode=&quot;AGNT&quot; or @classCode=&quot;CAREGIVER&quot; or @classCode=&quot;ECON&quot; or @classCode=&quot;NOK&quot; or @classCode=&quot;PRS&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The C32 Contact Type element shall be expressed in the classCode of the Contact role and shall be from the following list: AGNT (authorized to act on behalf of the patient), CAREGIVER (care at home), ECON (emergency contact), NOK (next of kin), PRS (personal). Guardian contacts (GUARD) are reported under the Patient element. See Section 2.2.1.4 rule C31-[49].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:code) or cda:code[(@code and @codeSystem=&quot;2.16.840.1.113883.5.111&quot;) or @nullFlavor or cda:originalText]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:code) or cda:code[(@code and @codeSystem=&quot;2.16.840.1.113883.5.111&quot;) or @nullFlavor or cda:originalText]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Contact Relationship should be recorded in the code element beneath the Participant Contact element. If the code is present, the code value shall be drawn from the HL7 PersonalRelationshipRoleType value set (2.16.840.1.113883.1.11.19563) drawn from the HL7 RoleCode code system (2.16.840.1.113883.5.111). There are 72 possible codes in the value set (e.g. GRMTH, STPDAU, etc.). CHECK list! See Section 2.2.1.4.2 rule C31-[51].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M14"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M14"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.4&quot;]" priority="4000" mode="M17">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.4&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:documentationOf              and parent::cda:serviceEvent              and self::cda:performer[@typeCode=&quot;PRF&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:documentationOf and parent::cda:serviceEvent and self::cda:performer[@typeCode=&quot;PRF&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Healthcare Provider (2.16.840.1.113883.3.88.11.32.4) is in the wrong location. The Healthcare Provider data element shall be represented as a cda:performer element under a cda:serviceEvent under a cda:documentationOf element. The C32 templateID for Healthcare Provider may optionally be included on the cda:performer element. See Table 2.2.1.5-2 and Section 2.2.1.5.1</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:time"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:time">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 Provider data element (i.e. CDA performer) shall contain a Date Range data element. See Table 2.2.1.5-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:assignedEntity"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:assignedEntity">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 Provider data element (i.e. CDA performer) shall contain a Provider Entity data element. See Table 2.2.1.5-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:functionCode)                or cda:functionCode[@codeSystem=&quot;2.16.840.1.113883.12.443&quot; and (@code=&quot;CP&quot; or @code=&quot;PP&quot; or @code=&quot;RP&quot;)]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:functionCode) or cda:functionCode[@codeSystem=&quot;2.16.840.1.113883.12.443&quot; and (@code=&quot;CP&quot; or @code=&quot;PP&quot; or @code=&quot;RP&quot;)]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The Provider Role Coded data element (i.e. CDA functionCode), if present, shall be coded as Consulting Provider (CP), Primary Care Provider (PP) or Referring Provider (RP), a limited subset taken from the HL7 v2 Provider Role code system (2.16.840.1.113883.12.443). See rule C32-[52]</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:assignedEntity/cda:code)                or (cda:assignedEntity/cda:code[@codeSystem=&quot;2.16.840.1.113883.6.101&quot;]                   and cda:assignedEntity/cda:code[substring(@code,3,10)=&quot;0000000X&quot;]                  and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;17&quot;])                  and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;19&quot;])                  and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;24&quot;])                  and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;27&quot;])                  and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;34&quot;]))"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:assignedEntity/cda:code) or (cda:assignedEntity/cda:code[@codeSystem=&quot;2.16.840.1.113883.6.101&quot;] and cda:assignedEntity/cda:code[substring(@code,3,10)=&quot;0000000X&quot;] and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;17&quot;]) and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;19&quot;]) and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;24&quot;]) and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;27&quot;]) and not(cda:assignedEntity/cda:code[substring(@code,1,2)=&quot;34&quot;]))">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The Provider Type data element, if present, shall be one of 23 selected top-level values (format dd0000000X) taken from the NUCC ProviderCodes code system (2.16.840.1.113883.6.101). See Table 2.2.1.5-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M17"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M17"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;]" priority="4000" mode="M21">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.9&quot;]              and ancestor::cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.20&quot;]              and self::cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.26&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.9&quot;] and ancestor::cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.20&quot;] and self::cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.26&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Insurance Payment Provider (2.16.840.1.113883.3.88.11.32.5) is in the wrong location. A C32 Insurance Payment Providers data element shall be represented as a CCD Policy Activity act (2.16.840.1.113883.10.20.1.26) under a CCD Coverage Activity act (2.16.840.1.113883.10.20.1.20) under a CCD Payors section (2.16.840.1.113883.10.20.1.9). The C32 templateId for Insurance Payment Providers may optionally be included on the CCD Policy Activity act. If no insurance payment sources are known, the reason shall be provided as free text in the narrative block (e.g. Not Insured, Payer Unknown, Medicare Pending, et cetera) of the CCD Payers section. See HITSP/C32 Section 2.2.1.6 and Section 2.2.1.6.1.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M21"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;]" priority="3999" mode="M21">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:performer/cda:assignedEntity"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:performer/cda:assignedEntity">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Payment Providers data element shall contain a C32 Payer element. See Table 2.2.1.6-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:performer/cda:assignedEntity/cda:code"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:performer/cda:assignedEntity/cda:code">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Payment Providers data element shall contain a C32 Financial Responsibility Party Type element. See Table 2.2.1.6-2 and Section 2.2.1.6.11 rule C32-[75].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:performer/cda:assignedEntity/cda:code[@code and @codeSystem=&quot;2.16.840.1.113883.5.110&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:performer/cda:assignedEntity/cda:code[@code and @codeSystem=&quot;2.16.840.1.113883.5.110&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Financial Responsibility Party Type element shall have a code attribute that contains a value from the HL7 RoleClassRelationshipFormal vocabulary (2.16.840.1.113883.5.110). CHECK list. See Table 2.2.1.6-2 and Section 2.2.1.6.11 rule C32-[76].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:code[@code=&quot;PP&quot;]) or cda:performer/cda:assignedEntity/cda:code[@code=&quot;GUAR&quot; or @code=&quot;PAT&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:code[@code=&quot;PP&quot;]) or cda:performer/cda:assignedEntity/cda:code[@code=&quot;GUAR&quot; or @code=&quot;PAT&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: If the C32 Health Insurance Type of the encompassing C32 Payment Provider (i.e. cda:code) is PP, then the C32 Financial Responsibility Party Type code attribute shall be set to GUAR or PAT to indicate a Guarantor or self-paying patient, respectively. See Table 2.2.1.6-2 and Section 2.2.1.6.11 rule C32-[77].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:code) or cda:code[@code=&quot;PP&quot;] or cda:performer/cda:assignedEntity/cda:code[@code=&quot;PAYOR&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:code) or cda:code[@code=&quot;PP&quot;] or cda:performer/cda:assignedEntity/cda:code[@code=&quot;PAYOR&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: If the C32 Health Insurance Type of the encompassing C32 Payment Provider (i.e. cda:code) is anything other than PP, then the C32 Financial Responsibility Party Type code attribute shall be set to PAYOR. See Table 2.2.1.6-2 and Section 2.2.1.6.11 rule C32-[77].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M21"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;]/cda:participant[@typeCode=&quot;COV&quot;]/cda:participantRole[@classCode=&quot;PAT&quot;]" priority="3998" mode="M21">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;]/cda:participant[@typeCode=&quot;COV&quot;]/cda:participantRole[@classCode=&quot;PAT&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:code"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:code">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Subscribers Patient data element shall contain a C32 Relationship to Subscriber element (i.e. cda:code). See Table 2.2.1.6-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:code[@code and @codeSystem=&quot;2.16.840.1.113883.5.111&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:code[@code and @codeSystem=&quot;2.16.840.1.113883.5.111&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Subscribers Patient data element shall contain a C32 Relationship to Subscriber element (i.e. cda:code) with the code attribute taken from the HL7 CoverageRoleType vocabulary (2.16.840.1.113883.5.111). CHECK list. See Table 2.2.1.6-2 and Section 2.2.1.6.8.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:playingEntity/cda:name"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:playingEntity/cda:name">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Subscribers Patient data element shall contain a C32 Patient Name element. If this element is empty, then the name shall be assumed equal to the patient name recorded in cda:recordTarget. See Table 2.2.1.6-2 and Section 2.2.1.6.9.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:playingEntity/sdtc:birthTime"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:playingEntity/sdtc:birthTime">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Subscribers Patient data element shall contain a C32 Patient Date of Birth element (sdtc:birthTime). If this element is empty, then the date of birth shall be assumed equal to the patient date of birth recorded in cda:recordTarget. NOTE: The sdtc:birthTime represents an extension to HL7 CDA Release 2.0. See Table 2.2.1.6-2 and Section 2.2.1.6.10.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M21"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;]/cda:participant[@typeCode=&quot;HLD&quot;]/cda:participantRole" priority="3997" mode="M21">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;]/cda:participant[@typeCode=&quot;HLD&quot;]/cda:participantRole"/>
    <axsl:choose>
      <axsl:when test="cda:id/@root and cda:id/@extension"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:id/@root and cda:id/@extension">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Subscriber Information data element shall contain a C32 Subscriber ID element with both root and extension attributes. The root attribute (OID or GUID) identifies the assigning authority of the extension attribute. The extension attribute is the subscriber identification number. See Table 2.2.1.6-2 and Section 2.2.1.6.13.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:addr/*"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:addr/*">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Subscriber Information data element shall contain a non-empty C32 addr element. The address should follow the C32 address format. See Table 2.2.1.6-2 and Section 2.2.1.1.2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:playingEntity/cda:name/* or cda:playingEntity/cda:name[string-length(normalize-space()) &gt; 2]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:playingEntity/cda:name/* or cda:playingEntity/cda:name[string-length(normalize-space()) &gt; 2]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Subscriber Information data element shall contain a non-empty C32 Subscriber Name element. See Table 2.2.1.6-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:playingEntity/sdtc:birthTime"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:playingEntity/sdtc:birthTime">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Subscriber Information data element shall contain a C32 Subscriber Date of Birth element (sdtc:birthTime). NOTE: The sdtc:birthTime represents an extension to HL7 CDA Release 2.0. See Table 2.2.1.6-2 and Section 2.2.1.6.14.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M21"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M21"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]" priority="4000" mode="M25">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.2&quot;]              and self::cda:act [cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.27&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.2&quot;] and self::cda:act [cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.27&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Allergy and Drug Sensitivities (2.16.840.1.113883.3.88.11.32.6) is in the wrong location. A HITSP C32 Allergy and Drug Sensitivities module (2.16.840.1.113883.3.88.11.32.6) shall be represented as a CCD Problem act (2.16.840.1.113883.10.20.1.27) under a CCD Alerts section (2.16.840.1.113883.10.20.1.2). The C32 templateId for Allergy and Drug Sensitivities may optionally be included on the CCD Problem act element. See HITSP/C32 Section 2.2.1.7 and Figure 2.2.1.7-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M25"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.18&quot;]" priority="3999" mode="M25">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.18&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:code[@codeSystem=&quot;2.16.840.1.113883.6.96&quot;]               and cda:code[@code=&quot;420134006&quot; or @code=&quot;418038007&quot; or @code=&quot;419511003&quot; or @code=&quot;418471000&quot;                        or @code=&quot;419199007&quot; or @code=&quot;416098002&quot; or @code=&quot;414285001&quot; or @code=&quot;59037007&quot;                        or @code=&quot;235719002&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:code[@codeSystem=&quot;2.16.840.1.113883.6.96&quot;] and cda:code[@code=&quot;420134006&quot; or @code=&quot;418038007&quot; or @code=&quot;419511003&quot; or @code=&quot;418471000&quot; or @code=&quot;419199007&quot; or @code=&quot;416098002&quot; or @code=&quot;414285001&quot; or @code=&quot;59037007&quot; or @code=&quot;235719002&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Adverse Event Entry data element shall contain an Adverse Event Type code element with code set to a limited subset of SNOMED CT (2.16.840.1.113883.6.96) terms as presented in HITSP/C32 Table 2.2.1.7.1-2. See Table 2.2.1.7-2 and Section 2.2.1.7.1 rule C32-[88]</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M25"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.18&quot;]/cda:participant[@typeCode=&quot;CSM&quot;]/cda:participantRole[@classCode=&quot;MANU&quot;]/cda:playingEntity[@classCode=&quot;MMAT&quot;]" priority="3998" mode="M25">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.18&quot;]/cda:participant[@typeCode=&quot;CSM&quot;]/cda:participantRole[@classCode=&quot;MANU&quot;]/cda:playingEntity[@classCode=&quot;MMAT&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:name"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:name">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Product data element shall contain a Product Free-Text element to name or describe the product causing the reaction. See Table 2.2.1.7-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:code) or cda:code[@codeSystem and @code]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:code) or cda:code[@codeSystem and @code]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Product Coded data element shall be coded to UNII for Food and substance allergies, or RxNorm when to medications, or NDF-RT when to classes of medications. CHECK codes! See Section 2.2.1.7.2 rule C32-[89]</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M25"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.18&quot;]/cda:entryRelationship[@typeCode=&quot;MFST&quot;]/cda:observation[templateId/@root=&quot;2.16.840.1.113883.10.20.1.54&quot;]" priority="3997" mode="M25">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.18&quot;]/cda:entryRelationship[@typeCode=&quot;MFST&quot;]/cda:observation[templateId/@root=&quot;2.16.840.1.113883.10.20.1.54&quot;]"/>
    <axsl:choose>
      <axsl:when test="not(cda:value) or cda:value[@codeSystem=&quot;2.16.840.1.113883.6.96&quot; and @code]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:value) or cda:value[@codeSystem=&quot;2.16.840.1.113883.6.96&quot; and @code]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Reaction Coded data element shall have its value coded using the VA/KP Problem List Subset of SNOMED CT (2.16.840.1.113883.6.96) and shall be terms that descend from the clinical finding (404684003) concept. CHECK list of codes. See Section 2.2.1.7.3 rule C32-[90].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M25"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.18&quot;]/cda:entryRelationship[@typeCode=&quot;MFST&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.54&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.55&quot;]" priority="3996" mode="M25">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.18&quot;]/cda:entryRelationship[@typeCode=&quot;MFST&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.54&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.55&quot;]"/>
    <axsl:choose>
      <axsl:when test="not(cda:value)                   or cda:value[@codeSystem=&quot;2.16.840.1.113883.6.96&quot;                    and (@code=&quot;255604002&quot; or @code=&quot;371923003&quot; or @code=&quot;6736007&quot;                      or @code=&quot;371924009&quot; or @code=&quot;24484000&quot; or @code=&quot;399166001&quot;)]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:value) or cda:value[@codeSystem=&quot;2.16.840.1.113883.6.96&quot; and (@code=&quot;255604002&quot; or @code=&quot;371923003&quot; or @code=&quot;6736007&quot; or @code=&quot;371924009&quot; or @code=&quot;24484000&quot; or @code=&quot;399166001&quot;)]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Reaction Severity data element shall have its value coded to SNOMED CT (2.16.840.1.113883.6.96) terms that descend from the severities (272141005) concept. HITSP/C32 Table 2.2.1.7.4-1 lists the SNOMED codes for: mild, mild to moderate, moderate, moderate to severe, severe, and fatal. See Section 2.2.1.7.4 rule C32-[91].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M25"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M25"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]" priority="4000" mode="M29">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.11&quot;]               and self::cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.27&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.11&quot;] and self::cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.27&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Conditions - Problem entry (2.16.840.1.113883.3.88.11.32.7) is in the wrong location. The HITSPC32 Conditions module (2.16.840.1.113883.3.88.11.32.7) shall be represented as a CCD Problem act (2.16.840.1.113883.10.20.1.27) under a CCD Problems section (2.16.840.1.113883.10.20.1.11). The C32 templateId for Conditions - Problem entry may optionally be included on the CCD Problem act element. See HITSP/C32 Section 2.2.1.8 and Section 2.2.1.8.3.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.28&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.28&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSPC32 Conditions module (2.16.840.1.113883.3.88.11.32.7) represented as a CCD Problem Act (2.16.840.1.113883.10.20.1.27) shall contain a subject (SUBJ) entryRelationship with target a HITSP/C32 Problem Entry data element represented as a CCD Problem Observation (2.16.840.1.113883.10.20.1.28). See Table 2.2.1.8-2</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M29"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.28&quot;]" priority="3999" mode="M29">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.28&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:text/cda:reference/@value"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:text/cda:reference/@value">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Problem Entry data element element shall contain a free text element to record the C32 Problem Name. The Problem Name element shall contain a reference element whose value attribute points to narrative text in the parent section containing the name of the problem. See Table 2.2.1.8-2 and Section 2.2.1.8.3</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M29"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.28&quot;]/cda:code" priority="3998" mode="M29">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.28&quot;]/cda:code"/>
    <axsl:choose>
      <axsl:when test="@codeSystem=&quot;2.16.840.1.113883.6.96&quot; "/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="@codeSystem=&quot;2.16.840.1.113883.6.96&quot;">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Problem Type shall contain a codeSystem attribute that identifies the SNOMED CT codeSystem (2.16.840.1.113883.6.96). See Section 2.2.1.8.2 rule C32-[92]</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="@code=&quot;404684003&quot; or @code=&quot;418799008&quot; or @code=&quot;55607006&quot;                or @code=&quot;409586006&quot; or @code=&quot;64572001&quot; or @code=&quot;282291009&quot;                or @code=&quot;248536006&quot;"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="@code=&quot;404684003&quot; or @code=&quot;418799008&quot; or @code=&quot;55607006&quot; or @code=&quot;409586006&quot; or @code=&quot;64572001&quot; or @code=&quot;282291009&quot; or @code=&quot;248536006&quot;">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Problem Type shall shall contain a code that identifies the SNOMED CT code for one of the following seven conditions: Finding (404684003), Symptom (418799008), Problem (55607006), Complaint (409586006), Condition (64572001), Diagnosis (282291009, Functional limitation (248536006). See Section 2.2.1.8.2 rule C32-[93] and Table 2.2.1.8.2-1</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M29"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.28&quot;]/cda:value" priority="3997" mode="M29">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]/cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]/cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.28&quot;]/cda:value"/>
    <axsl:choose>
      <axsl:when test="@xsi:type=&quot;CD&quot; and @codeSystem=&quot;2.16.840.1.113883.6.96&quot; and @code"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="@xsi:type=&quot;CD&quot; and @codeSystem=&quot;2.16.840.1.113883.6.96&quot; and @code">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Problem Code shall be recorded in a cda:value element and coded using the VA/KP Problem List Subset of SNOMED CT (2.16.840.1.113883.6.96), and shall use SNOMED terms that descend from the clinical finding (404684003) concept. CHECK the problem list subset! See Section 2.2.1.8.4 rule C32-[94]</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="@xsi:type=&quot;CD&quot;"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="@xsi:type=&quot;CD&quot;">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Problem Code shall be recorded in the cda:value element using an HL7 CD data type. See Section 2.2.1.8.4 rule C32-[95]</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M29"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]/cda:performer" priority="3996" mode="M29">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]/cda:performer"/>
    <axsl:choose>
      <axsl:when test="true()"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="true()">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Treating Provider data element shall be recorded in a cda:performer element under the C32 Conditions module. See Section 2.2.1.8.5 rule C32-[96]</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:assignedEntity/cda:id"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:assignedEntity/cda:id">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Treating Provider data element shall contain a cda:assignedEntity/cda:id element to identify the treating provider. This identifier shall be the identifier of one of the providers listed in the C32 Providers module. See Section 2.2.1.8.5 rule C32-[98] and Section 2.2.1.4.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="(cda:assignedEntity/cda:id/@root = /cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:assignedEntity/cda:id/@root)               and (cda:assignedEntity/cda:id/@extension = /cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:assignedEntity/cda:id/@extension)"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="(cda:assignedEntity/cda:id/@root = /cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:assignedEntity/cda:id/@root) and (cda:assignedEntity/cda:id/@extension = /cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer/cda:assignedEntity/cda:id/@extension)">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Constraint Violation: A C32 Treating Provider data element shall contain a cda:assignedEntity/cda:id element to identify the treating provider. This identifier shall be the identifier of one of the providers listed in the C32 Providers module. See Section 2.2.1.8.5 rule C32-[98] and Section 2.2.1.4.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M29"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M29"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.8&quot;]" priority="4000" mode="M33">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.8&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.8&quot;]            and self::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.8&quot;] and self::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Medications - Administration Information (2.16.840.1.113883.3.88.11.32.8) is in the wrong location. The HITSP/C32 Medications - Administration Information data element shall be represented as a CCD Medication Activity substanceAdministration (2.16.840.1.113883.10.20.1.24) under a CCD Medications section (2.16.840.1.113883.10.20.1.8). The C32 templateId for Medications - Administration Information may optionally be included on the CCD Medication Activity substanceAdministration. See HITSP/C32 Section 2.2.1.9 Table 2.2.1.9-2 and Section 2.2.1.9.1.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:consumable/cda:manufacturedProduct[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.53&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:consumable/cda:manufacturedProduct[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.53&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Administration Information data element (2.16.840.1.113883.3.88.11.32.8) shall contain a C32 Medication Information element represented as a CCD Manufactured Product (2.16.840.1.113883.10.20.1.53). The HITSP/C32 templateId for Medication Information (2.16.840.1.113883.3.88.11.32.9) may optionally be included on the CCD Manufactured Product. See Table 2.2.1.9-2 and Section 2.2.1.9.9.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:text) or cda:text/cda:reference/@value"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:text) or cda:text/cda:reference/@value">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Free Text Sig data element shall contain a cda:reference element whose value attribute points to the narrative portion of the CCD section. See Section 2.2.1.9.1 rule C32-[99].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:effectiveTime[1]) or cda:effectiveTime[1][@nullFlavor or @xsi:type=&quot;IVL_TS&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:effectiveTime[1]) or cda:effectiveTime[1][@nullFlavor or @xsi:type=&quot;IVL_TS&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The first effectiveTime in a C32 Administration Information data element (2.16.840.1.113883.3.88.11.32.8) shall use the IVL_TS data type to record the start and stop dates for administration of the medication. If the administration is a single occurrence, then use the effectiveTime/@value attribute to declare a collapsed interval of time equal to the precision of the timestamp used for that attribute. See Table 2.2.1.9-2 and Section 2.2.1.9.3 rule C32-[103].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:effectiveTime[2]) or cda:effectiveTime[2][@operator=&quot;A&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:effectiveTime[2]) or cda:effectiveTime[2][@operator=&quot;A&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The second effectiveTime in a C32 Administration Information data element (2.16.840.1.113883.3.88.11.32.8) shall include the operator attribute with its value set to A. See Table 2.2.1.9-2 and Section 2.2.1.9.3 rule C32-[105].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:effectiveTime[2]) or cda:effectiveTime[2][@nullFlavor or @xsi:type=&quot;PIVL_TS&quot; or @xsi:type=&quot;EIVL&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:effectiveTime[2]) or cda:effectiveTime[2][@nullFlavor or @xsi:type=&quot;PIVL_TS&quot; or @xsi:type=&quot;EIVL&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The second effectiveTime in a C32 Administration Information data element (2.16.840.1.113883.3.88.11.32.8) shall use the PIVL_TS data type to record details about frequency, interval, and duration and shall use the EIVL data type to record administration based on activities of daily living. See Table 2.2.1.9-2 and Section 2.2.1.9.3 rule C32-[106], C32-[107], C32-[108].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:effectiveTime[2][@xsi:type=&quot;PIVL_TS&quot;]) or cda:effectiveTime[2][@xsi:type=&quot;PIVL_TS&quot; and @institutionSpecified]/cda:period"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:effectiveTime[2][@xsi:type=&quot;PIVL_TS&quot;]) or cda:effectiveTime[2][@xsi:type=&quot;PIVL_TS&quot; and @institutionSpecified]/cda:period">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The second effectiveTime in a C32 Administration Information data element (2.16.840.1.113883.3.88.11.32.8) shall use the PIVL_TS data type to record details about frequency, interval, and duration, shall use the institutionSpecified attribute to distinguish between interval and frequency (true is frequency and false is interval), and shall contain a period element to provide the timing of the interval or frequency. See Table 2.2.1.9-2 and Section 2.2.1.9.3 rule C32-[106], C32-[107].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:effectiveTime[2][@xsi:type=&quot;EIVL&quot;]) or cda:effectiveTime[2][@xsi:type=&quot;EIVL&quot;]/cda:event"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:effectiveTime[2][@xsi:type=&quot;EIVL&quot;]) or cda:effectiveTime[2][@xsi:type=&quot;EIVL&quot;]/cda:event">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The second effectiveTime in a C32 Administration Information data element (2.16.840.1.113883.3.88.11.32.8) shall use the EIVL data type to indicate administration based on activities of daily living and shall identify the events which trigger administration in a cda:event element beneath the effectiveTime element. See Table 2.2.1.9-2 and Section 2.2.1.9.3 rule C32-[108].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:routeCode) or cda:routeCode[@nullflavor or cda:originalText or (@code and @codeSystem=&quot;2.16.840.1.113883.3.26.1.1&quot;)]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:routeCode) or cda:routeCode[@nullflavor or cda:originalText or (@code and @codeSystem=&quot;2.16.840.1.113883.3.26.1.1&quot;)]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Route of Administration element shall have a value drawn from the FDA route of administration code system (2.16.840.1.113883.3.26.1.1). CHECK list. See Section 2.2.1.9.4 rule C32-[109].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:doseQuantity) or cda:doseQuantity[@nullflavor or @value]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:doseQuantity) or cda:doseQuantity[@nullflavor or @value]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Dose Quantity element shall have a CDA value attribute. The unit attribute may be present when needed. If present it shall be coded using the Unified Code for Units of Measure (UCUM). See Section 2.2.1.9.5 rules C32-[110] and C32-[111]. Also see rule C32-[112] for how to represent doses described in tablets, capsules, etc.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:approachSiteCode) or cda:approachSiteCode[@nullflavor or cda:originalText or (@code and @codeSystem=&quot;2.16.840.1.113883.6.96&quot;)]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:approachSiteCode) or cda:approachSiteCode[@nullflavor or cda:originalText or (@code and @codeSystem=&quot;2.16.840.1.113883.6.96&quot;)]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Approach Site Code shall be from the SNOMED CT code system (2.16.840.1.113883.6.96) with a value drawn from the Anatomical Structure (91723000) hierarchy. CHECK list. See Section 2.2.1.9.6 rule C32-[113] and C32-[114].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:administrationUnitCode) or cda:administrationUnitCode[@nullflavor or cda:originalText or (@code and @codeSystem=&quot;2.16.840.1.113883.3.26.1.1&quot;)]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:administrationUnitCode) or cda:administrationUnitCode[@nullflavor or cda:originalText or (@code and @codeSystem=&quot;2.16.840.1.113883.3.26.1.1&quot;)]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Product Form unit code shall be from the FDA Dosage Form vocabulary (2.16.840.1.113883.3.26.1.1). CHECK list. See Section 2.2.1.9.7 rule C32-[115].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M33"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.8&quot;]/cda:entryRelationship/cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.43&quot;]/cda:text" priority="3999" mode="M33">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.8&quot;]/cda:entryRelationship/cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.43&quot;]/cda:text"/>
    <axsl:choose>
      <axsl:when test="cda:reference/@value"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:reference/@value">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Fulfillment Instructions data element shall contain a cda:reference element whose value attribute points to the narrative text that contains the instructions. See Section 2.2.1.9.19 rule C32-[147].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M33"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M33"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.9&quot;]" priority="4000" mode="M37">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.9&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]              and self::cda:manufacturedProduct[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.53&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;] and self::cda:manufacturedProduct[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.53&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Medication Information (2.16.840.1.113883.3.88.11.32.9) is in the wrong location. A HITSP/C32 Medication Information data element shall be represented as a CCD Manufactured Product (2.16.840.1.113883.10.20.1.53) under a CCD Medication Activity (2.16.840.1.113883.10.20.1.24). The parent CCD section may be Medications or Immunizations. The C32 templateId for Medication Information may optionally be included on the CCD Manufactured Product element. See Sections 2.2.1.9.9 and 2.2.1.13 and CCD rule CONF-356.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M37"/>
  </axsl:template>
  <axsl:template match="*[ancestor::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]              and self::cda:manufacturedProduct[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.53&quot;]]/cda:manufacturedMaterial/cda:code" priority="3999" mode="M37">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[ancestor::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]              and self::cda:manufacturedProduct[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.53&quot;]]/cda:manufacturedMaterial/cda:code"/>
    <axsl:choose>
      <axsl:when test="not(ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.8&quot;])               or @codeSystem=&quot;2.16.840.1.113883.6.88&quot; or cda:translation[@codeSystem=&quot;2.16.840.1.113883.6.88&quot;]               or @codeSystem=&quot;2.16.840.1.113883.6.69&quot; or cda:translation[@codeSystem=&quot;2.16.840.1.113883.6.69&quot;]               or @codeSystem=&quot;2.16.840.1.113883.4.209&quot;               or @codeSystem=&quot;2.16.840.1.113883.4.9&quot;               or @nullFlavor               or (not(@code) and not(@codeSystem)) "/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.8&quot;]) or @codeSystem=&quot;2.16.840.1.113883.6.88&quot; or cda:translation[@codeSystem=&quot;2.16.840.1.113883.6.88&quot;] or @codeSystem=&quot;2.16.840.1.113883.6.69&quot; or cda:translation[@codeSystem=&quot;2.16.840.1.113883.6.69&quot;] or @codeSystem=&quot;2.16.840.1.113883.4.209&quot; or @codeSystem=&quot;2.16.840.1.113883.4.9&quot; or @nullFlavor or (not(@code) and not(@codeSystem))">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The product name or brand name of a C32 Medications - Medication Information shall be coded using code system RxNorm (2.16.840.1.113883.6.88) or NDC (2.16.840.1.113883.6.69). The code shall appear in the code attribute of the code or translation element. When only the class of a drug is known (e.g. Beta Blocker or Sulfa Drug), it shall be coded using NDF-RT (2.16.840.1.113883.4.209). FDA Unique Ingredient Identifier codes (UNII) may be used when there are no suitable codes in the other vocabularies to identify the medication. If the code for a generic product is unknown, the code and codeSystem attributes may be omitted. Check list. See Section 2.2.1.9.9 and rules C32-[118] through C32-[121].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.6&quot;])               or @codeSystem=&quot;2.16.840.1.113883.12.292&quot; or cda:translation[@codeSystem=&quot;2.16.840.1.113883.12.292&quot;]               or @codeSystem=&quot;2.16.840.1.113883.6.59&quot; or cda:translation[@codeSystem=&quot;2.16.840.1.113883.6.59&quot;]               or @nullFlavor               or (not(@code) and not(@codeSystem)) "/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.6&quot;]) or @codeSystem=&quot;2.16.840.1.113883.12.292&quot; or cda:translation[@codeSystem=&quot;2.16.840.1.113883.12.292&quot;] or @codeSystem=&quot;2.16.840.1.113883.6.59&quot; or cda:translation[@codeSystem=&quot;2.16.840.1.113883.6.59&quot;] or @nullFlavor or (not(@code) and not(@codeSystem))">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The product name or brand name of a C32 Immunizations- Medication Information shall be coded using code system CVX (2.16.840.1.113883.12.292) or (2.16.840.1.113883.6.59). The code shall appear in the code attribute of the code or translation element. If the code for an immunization product is unknown, the code and codeSystem attributes may be omitted. Check list. See Section 2.2.1.13 and rule C32-[198].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="@nullFlavor or cda:originalText"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="@nullFlavor or cda:originalText">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The product (generic) name (Medication or Immunization) shall appear in the originalText element beneath the code element. See Section 2.2.1.9.9 rule C32-[122] and Section 2.2.1.13.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:translation) or cda:translation/@code"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:translation) or cda:translation/@code">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The code for the specific brand of a product, if known, shall appear in a translation element under the code element. See Section 2.2.1.9.9 and rule C32-[123].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M37"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M37"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.10&quot;]" priority="4000" mode="M41">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.10&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.8&quot;]              and (ancestor::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]                or ancestor::cda:supply[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.34&quot;])              and parent::cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]              and self::cda:observation"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.8&quot;] and (ancestor::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;] or ancestor::cda:supply[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.34&quot;]) and parent::cda:entryRelationship[@typeCode=&quot;SUBJ&quot;] and self::cda:observation">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Type of Medication (2.16.840.1.113883.3.88.11.32.10) is in the wrong location. A HITSP/C32 Type of Medication data element shall be represented as an observation entry under an entryRelationship of type subject (SUBJ) in a CCD substance Administration (2.16.840.1.113883.10.20.1.24) or CCD supply (2.16.840.1.113883.10.20.1.34) in a CCD Medications section (2.16.840.1.113883.10.20.1.8). The C32 templateId for Type of Medication may optionally be included on the CDA observation element. See Table 2.2.1.9-2 and Section 2.2.1.9.11 rules C32-[125] and C32-[126].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:code"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:code">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Type of Medication data element shall have a code element that represents the kind of medication actually or intended to be administered or supplied. See Section 2.2.1.9.11 rule C32-[128].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:code[@codeSystem=&quot;2.16.840.1.113883.6.96&quot; and (@code=&quot;329505003&quot; or @code=&quot;73639000&quot;)]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:code[@codeSystem=&quot;2.16.840.1.113883.6.96&quot; and (@code=&quot;329505003&quot; or @code=&quot;73639000&quot;)]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Type of Medication data element shall have a code element with a code attribute taken from SNOMED CT (2.16.840.1.113883.6.96) and with the code restricted to Over the counter products (329505003) or prescription drug (73639000). See Section 2.2.1.9.11 rule C32-[129].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M41"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M41"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.11&quot;]" priority="4000" mode="M45">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.11&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.8&quot;]]              and parent::cda:entryRelationship[@typeCode=&quot;REFR&quot;]              and self::cda:supply[@moodCode=&quot;INT&quot; or @moodCode=&quot;EVN&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.8&quot;]] and parent::cda:entryRelationship[@typeCode=&quot;REFR&quot;] and self::cda:supply[@moodCode=&quot;INT&quot; or @moodCode=&quot;EVN&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Order Information (2.16.840.1.113883.3.88.11.32.11) is in the wrong location. A HITSP/C32 Order Information data element shall be represented as a CCD supply entry, in INT mood, under a refers to (REFR) entryRelationship in a CCD Medications section (2.16.840.1.113883.10.20.1.8). It may be recorded as part of the fufillment history (with moodCode="EVN") or as part of the administration information. The C32 templateId for Order Information may optionally be included on the cda:supply element. See Table 2.2.1.9-2 and Section 2.2.1.9.16.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="ancestor::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]                or ancestor::cda:supply[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.34&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;] or ancestor::cda:supply[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.34&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Order Information data element (2.16.840.1.113883.3.88.11.32.11) shall be contained in a CCD substanceAdministration entry (2.16.840.1.113883.10.20.1.24) or in a CCD supply entry (2.16.840.1.113883.10.20.1.34). See Section 2.2.1.9.16.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M45"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M45"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.12&quot;]" priority="4000" mode="M49">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.12&quot;]"/>
    <axsl:choose>
      <axsl:when test="self::cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.40&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="self::cda:act[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.40&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for a Comments Module (2.16.840.1.113883.3.88.11.32.12) is in the wrong location. A HITSP/C32 Comments Module shall be represented as a CCD Comment act (2.16.840.1.113883.10.20.1.40). The C32 templateId for Comments Module may optionally be included on the CCD Comment act element. See Section 2.2.1.12.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.26&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.27&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.8&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.9&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.53&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.10&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.11&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.13&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.17&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.14&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.15&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.16&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.31&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.17&quot;]               or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.21&quot;]               or ../../cda:observation[cda:code/@code=&quot;77386006&quot; and cda:code/@codeSystem=&quot;2.16.840.1.113883.6.96&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.26&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.27&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.8&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.24&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.9&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.53&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.10&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.11&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.13&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.17&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.14&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.15&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.16&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.31&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.17&quot;] or ../../cda:templateId[@root=&quot;2.16.840.1.113883.10.20.1.21&quot;] or ../../cda:observation[cda:code/@code=&quot;77386006&quot; and cda:code/@codeSystem=&quot;2.16.840.1.113883.6.96&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Comments Module (2.16.840.1.113883.3.88.11.32.12) shall be included only in a HITSP/C32 content module defined in one of the following sections: CCD Payers, CCD Alerts, CCD Problems, CCD Medications, CCD Advance Directives, CCD Immunizations, CCD Vital Signs, CCD Results, CCD Encounters, or under a HITSP/C32 Pregnancy Module. See Section 2.2.1.12.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M49"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.12&quot;                 and ancestor::*[cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.26&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.27&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.8&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.24&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.9&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.53&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.10&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.11&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.13&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.17&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.14&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.15&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.16&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.31&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.17&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.21&quot;]                                or self::cda:observation[cda:code/@code=&quot;77386006&quot; and cda:code/@codeSystem=&quot;2.16.840.1.113883.6.96&quot;]]]" priority="3999" mode="M49">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.12&quot;                 and ancestor::*[cda:templateId[@root=&quot;2.16.840.1.113883.3.88.11.32.5&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.26&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.6&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.7&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.27&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.8&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.24&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.9&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.53&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.10&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.11&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.13&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.17&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.14&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.15&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.16&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.31&quot;                                             or @root=&quot;2.16.840.1.113883.3.88.11.32.17&quot;                                             or @root=&quot;2.16.840.1.113883.10.20.1.21&quot;]                                or self::cda:observation[cda:code/@code=&quot;77386006&quot; and cda:code/@codeSystem=&quot;2.16.840.1.113883.6.96&quot;]]]"/>
    <axsl:choose>
      <axsl:when test="ancestor-or-self::*/cda:author[1]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor-or-self::*/cda:author[1]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Comments module shall have an author, either defined directly in the comment or as the first author of a parent element. See Section 2.2.1.12 Table 2.2.1.12-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:text"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:text">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Comments module shall contain a C32 Free Text Comment data element. See Section 2.2.1.12 Table 2.2.1.12-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="parent::cda:entryRelationship"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="parent::cda:entryRelationship">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: Comments shall be included in entries using an entryRelationship element. See Section 2.2.1.12.1 rule C32-[164].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="parent::cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="parent::cda:entryRelationship[@typeCode=&quot;SUBJ&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The typeCode attribute of the entryRelationship shall be SUBJ. See Section 2.2.1.12.1 rule C32-[165].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="parent::cda:entryRelationship[@inversionInd=&quot;true&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="parent::cda:entryRelationship[@inversionInd=&quot;true&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The inversionInd attribute of the entryRelationship shall be true. See Section 2.2.1.12.1 rule C32-[166].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:text/cda:reference/@value"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:text/cda:reference/@value">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The Free Text Comment data element shall contain a reference element whose value attribute points to the text of the comment in the narrative portion of the parent CCD section. See Section 2.2.1.12.1 rule C32-[167].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="ancestor-or-self::*/cda:author[1]/cda:assignedAuthor/cda:assignedPerson/cda:name"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor-or-self::*/cda:author[1]/cda:assignedAuthor/cda:assignedPerson/cda:name">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The name of the C32 Author shall be provided in the name element of the assignedPerson under the assignedAuthor. See Section 2.2.1.12 rule C32-[164] and Section 2.2.1.10.1 rule C32-[158].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="ancestor-or-self::*/cda:author[1]/cda:time"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor-or-self::*/cda:author[1]/cda:time">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The C32 Author data element shall contain an Author Time element. See Section 2.2.1.12 rule C32-[164] and Section 2.2.1.10.1 Table 2.2.1.10-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M49"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M49"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.13&quot;]" priority="4000" mode="M53">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.13&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.1&quot;]              and self::cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.17&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.1&quot;] and self::cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.17&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Advance Directives (2.16.840.1.113883.3.88.11.32.13) is in the wrong location. A HITSP/C32 Advance Directive data element shall be represented as a CCD Advance Directive Observation (2.16.840.1.113883.10.20.1.17) under a CCD Advance Directives section (2.16.840.1.113883.10.20.1.1). The C32 templateId for Advance Directives may optionally be included on the CCD Advance Directive Observation element. See Section 2.2.1.13.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M53"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.13&quot;]" priority="3999" mode="M53">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.13&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:code/cda:originalText"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:code/cda:originalText">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Advance Directive shall contain an Advance Directive Free Text Type element. See Table 2.2.1.13-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:effectiveTime"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:effectiveTime">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Advance Directive shall contain an Effective Date element. See Table 2.2.1.13-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:participant/cda:participantRole"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:participant/cda:participantRole">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Advance Directive shall contain a Custodian of the Document element. See Table 2.2.1.13-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:code/@code) or cda:code[@code and @codeSystem=&quot;2.16.840.1.113883.6.96&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:code/@code) or cda:code[@code and @codeSystem=&quot;2.16.840.1.113883.6.96&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Advance Directive with Coded Type shall contain an advance directive code from from the advance directive subset of SNOMED CT (2.16.840.1.113883.6.96). CHECK list of values. See Section 2.2.1.13.1 rule C32-[169].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:code/cda:originalText/cda:reference/@value"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:code/cda:originalText/cda:reference/@value">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The human readable description of the type of advance directive shall appear in the narrative text of the parent section and shall be pointed to by the value attribute of the reference element inside the originalText element of the code element. See Section 2.2.1.13.2 Rule C32-[171].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:effectiveTime/cda:low"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:effectiveTime/cda:low">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The starting time of the C32 Advance Directive shall be recorded in the low element of the Effective Date. See Section 2.2.1.13.3 Rule C32-[172].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:effectiveTime/cda:low[@value or @nullFlavor=&quot;UNK&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:effectiveTime/cda:low[@value or @nullFlavor=&quot;UNK&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: If the starting time of an Advance Directive is unknown, then the low element of its Effective Date shall have a nullFlavor attribute set to UNK. See Section 2.2.1.13.3 Rule C32-[173].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:effectiveTime/cda:high"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:effectiveTime/cda:high">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The endingtime of the C32 Advance Directive shall be recorded in the high element of the Effective Date. See Section 2.2.1.13.3 Rule C32-[174].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:effectiveTime/cda:high[@value or @nullFlavor=&quot;UNK&quot; or @nullFlavor=&quot;NA&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:effectiveTime/cda:high[@value or @nullFlavor=&quot;UNK&quot; or @nullFlavor=&quot;NA&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: If the ending time of an Advance Directive is unknown, then the high element of its Effective Date shall have a nullFlavor attribute set to UNK. If the Advance Directive does not have a specified ending time, then the high element of its Effective Date shall have a nullFlavor attribute set to NA. See Section 2.2.1.13.3 Rule C32-[175] and C32-[176].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:participant/cda:participantRole"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:participant/cda:participantRole">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: Information required to obtain a copy of a C32 Advance Directive shall be recorded in the Custodian of the Document data element. See Section 2.2.1.13.4 Rule C32-[177].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:participant[@typeCode=&quot;CST&quot;]/cda:participantRole"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:participant[@typeCode=&quot;CST&quot;]/cda:participantRole">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Custodian of the Document data element shall have participant typeCode set to CST. See Section 2.2.1.13.4 Rule C32-[178].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:participant[@typeCode=&quot;CST&quot;]/cda:participantRole[@classCode=&quot;AGNT&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:participant[@typeCode=&quot;CST&quot;]/cda:participantRole[@classCode=&quot;AGNT&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Custodian of the Document data element shall have classCode set to AGNT. See Section 2.2.1.13.4 Rule C32-[179].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:participant/cda:participantRole/cda:playingEntity/cda:name"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:participant/cda:participantRole/cda:playingEntity/cda:name">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A C32 Custodian of the Document data element shall contain a playingEntity element and the name of the agent who can provide a copy of the advance directive shall be recorded in the name element. See Section 2.2.1.13.4 Rule C32-[182].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M53"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M53"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.14&quot;]" priority="4000" mode="M57">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.14&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.6&quot;]            and self::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.6&quot;] and self::cda:substanceAdministration[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.24&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Immunization Event (2.16.840.1.113883.3.88.11.32.14) is in the wrong location. The HITSP/C32 Immunizations Event Entry data element shall be represented as a CCD Medication Activity substanceAdministration act (2.16.840.1.113883.10.20.1.24) under a CCD Immunizations section (2.16.840.1.113883.10.20.1.6). The C32 templateId for Immunization Event may optionally be included on the CCD Medication Activity substanceAdministration act. See HITSP/C32 Section 2.2.1.14 Table 2.2.1.14-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M57"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.14&quot;]" priority="3999" mode="M57">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.14&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:consumable/cda:manufacturedProduct[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.53&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:consumable/cda:manufacturedProduct[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.53&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Immunization Event Entry data element (2.16.840.1.113883.3.88.11.32.14) shall contain a C32 Medication Information element represented as a CCD Manufactured Product (2.16.840.1.113883.10.20.1.53). The C32 templateId for Medication Information (2.16.840.1.113883.3.88.11.32.9) may optionally be included on the CCD Manufactured Product element. See HITSP/C32 Section 2.2.1.14 Table 2.2.1.14-2 and Figure 2.2.1.14-1. Note: Does HITSP want the Medication Information element to carry the templateId for Medication Information from the Medications section (2.16.840.1.113883.3.88.11.32.9) as shown in Figure 2.2.1.14-1? It adds requirements related to codeSystems for the manufacturedMaterial (as medication) that may not be intended for manufacturedMaterial (as immunization).</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="@negationInd"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="@negationInd">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Immunization Event Entry data element (2.16.840.1.113883.3.88.11.32.14) shall contain a C32 Refusal Indication attribute (Boolean). A value of false indicates that the immunization was administered. A value of true indicates that the medication was refused and not taken. The reason for refusal, if known, is carried by the C32 Refusal Reason data element. See HITSP/C32 Section 2.2.1.14 Table 2.2.1.14-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(@negationInd=&quot;true&quot;) or cda:entryRelationship[@typeCode=&quot;RSON&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(@negationInd=&quot;true&quot;) or cda:entryRelationship[@typeCode=&quot;RSON&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: If a HITSP/C32 Immunization Event Entry data element (2.16.840.1.113883.3.88.11.32.14) contains a Refusal Indication that indicates an immunization was refused, then the Immunization Event Entry shall contain a C32 Refusal Reason data element. See HITSP/C32 Section 2.2.1.14 Table 2.2.1.14-2 and rule c32-[199].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(@negationInd=&quot;true&quot;) or cda:entryRelationship[@typeCode=&quot;RSON&quot;]/cda:act/cda:code[@code                                               and @codeSystem=&quot;2.16.840.1.113883.11.19725&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(@negationInd=&quot;true&quot;) or cda:entryRelationship[@typeCode=&quot;RSON&quot;]/cda:act/cda:code[@code and @codeSystem=&quot;2.16.840.1.113883.11.19725&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Refusal Reason data element shall be an act with code drawn from the HL7 ActNoImmunizationReason vocabulary (2.16.840.1.113883.11.19725). See HITSP/C32 Section 2.2.1.14 rule c32-[199].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(@negationInd=&quot;true&quot;) or cda:entryRelationship[@typeCode=&quot;RSON&quot;]/cda:act/cda:code[@codeSystem=&quot;2.16.840.1.113883.11.19725&quot; and                                                 (@code=&quot;IMMUNE&quot;                                               or @code=&quot;MEDPREC&quot; or @code=&quot;OSTOCK&quot;                                               or @code=&quot;PATOBJ&quot; or @code=&quot;PHILISOP&quot; or @code=&quot;RELIG&quot;                                               or @code=&quot;VACEFF&quot; or @code=&quot;VACSAF&quot;)]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(@negationInd=&quot;true&quot;) or cda:entryRelationship[@typeCode=&quot;RSON&quot;]/cda:act/cda:code[@codeSystem=&quot;2.16.840.1.113883.11.19725&quot; and (@code=&quot;IMMUNE&quot; or @code=&quot;MEDPREC&quot; or @code=&quot;OSTOCK&quot; or @code=&quot;PATOBJ&quot; or @code=&quot;PHILISOP&quot; or @code=&quot;RELIG&quot; or @code=&quot;VACEFF&quot; or @code=&quot;VACSAF&quot;)]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Refusal Reason data element shall be an act with code drawn from the HL7 ActNoImmunizationReason vocabulary (2.16.840.1.113883.11.19725). Valid values are: IMMUNE (immunity), MEDPREC (medical precaution), OSTOCK (out of stock), PATOBJ (patient objection), PHILISOP (philosophical objection), RELIG (religious objection), VACEFF (vaccine efficiency concerns), or VACSAF (vaccine safety concerns). See HITSP/C32 Section 2.2.1.14 rule c32-[199].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M57"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M57"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.15&quot;]" priority="4000" mode="M61">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.15&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.16&quot;]              and self::cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.31&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.16&quot;] and self::cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.31&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for a Vital Signs entry (2.16.840.1.113883.3.88.11.32.15) is in the wrong location. A HITSP/C32 Vital Signs entry data element shall be represented as a CCD Result observation (2.16.840.1.113883.10.20.1.31) under a CCD Vital Signs section (2.16.840.1.113883.10.20.1.16). The C32 templateId for Vital signs entry may optionally be included on the CCD Result observation element. See Section 2.2.1.15 Table 2.2.1.15-2 and Section 2.2.1.15 Table 2.2.1.15-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M61"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.15&quot;]" priority="3999" mode="M61">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.15&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:id"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:id">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Vital Signs observation shall contain a C32 Result ID element. See Section 2.2.1.15 and Table 2.2.1.15-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:effectiveTime"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:effectiveTime">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Vital Signs observation shall contain a C32 Result DateTime element. See Section 2.2.1.15 and Table 2.2.1.15-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:code"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:code">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Vital Signs observation shall contain a C32 Result Type element. See Section 2.2.1.15 and Table 2.2.1.15-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:value"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:value">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Vital Signs observation shall contain a Result Value element. See Section 2.2.1.15 and Table 2.2.1.15-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:statusCode) or cda:statusCode[@code=&quot;completed&quot; or @code=&quot;active&quot;       or @code=&quot;held&quot; or @code=&quot;aborted&quot; or @code=&quot;cancelled&quot; or @code=&quot;new&quot; or @code=&quot;suspended&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:statusCode) or cda:statusCode[@code=&quot;completed&quot; or @code=&quot;active&quot; or @code=&quot;held&quot; or @code=&quot;aborted&quot; or @code=&quot;cancelled&quot; or @code=&quot;new&quot; or @code=&quot;suspended&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Result Status data element shall contain a code derived from the HL7 ActStatusNormal code system (2.16.840.1.113883.11.15936). Usual codes are: completed (completed result), active (in-progress result), held (pending release). Four other ActStatusNormal codes are: aborted, cancelled, new, suspended. The element type for statusCode is CS (code simple) so the codeSystem attribute is not permitted. See Section 2.2.1.16.1 rule C32-[201].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M61"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M61"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.16&quot;]" priority="4000" mode="M65">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.16&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.14&quot;]              and self::cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.31&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.14&quot;] and self::cda:observation[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.31&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for a Result observation (2.16.840.1.113883.3.88.11.32.16) is in the wrong location. A HITSP/C32 Result observation shall be represented as a CCD Result observation (2.16.840.1.113883.10.20.1.31) under a CCD Results section (2.16.840.1.113883.10.20.1.14). The C32 templateId for Result observation may optionally be included on the CCD Result observation element. See Section 2.2.1.16 Table 2.2.1.16-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M65"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.16&quot;]" priority="3999" mode="M65">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.16&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:id"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:id">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Results observation shall contain a C32 Result ID element. See Section 2.2.1.16 Table 2.2.1.16-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:effectiveTime"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:effectiveTime">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Results observation shall contain a C32 Result DateTime element. See Section 2.2.1.16 Table 2.2.1.16-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:code"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:code">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Results observation shall contain a C32 Result Type element. See Section 2.2.1.16 Table 2.2.1.16-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:value"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:value">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Results observation shall contain a C32 Result Value element. See Section 2.2.1.16 Table 2.2.1.16-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="not(cda:statusCode) or cda:statusCode[@code=&quot;completed&quot; or @code=&quot;active&quot;       or @code=&quot;held&quot; or @code=&quot;aborted&quot; or @code=&quot;cancelled&quot; or @code=&quot;new&quot; or @code=&quot;suspended&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="not(cda:statusCode) or cda:statusCode[@code=&quot;completed&quot; or @code=&quot;active&quot; or @code=&quot;held&quot; or @code=&quot;aborted&quot; or @code=&quot;cancelled&quot; or @code=&quot;new&quot; or @code=&quot;suspended&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Result Status data element shall contain a code derived from the HL7 ActStatusNormal code system (2.16.840.1.113883.11.15936). Usual codes are: completed (completed result), active (in-progress result), held (pending release). Four other ActStatusNormal codes are: aborted, cancelled, new, suspended. The element type for statusCode is CS (code simple) so the codeSystem attribute is not permitted. See Section 2.2.1.16.1 rule C32-[201].</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M65"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M65"/>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.17&quot;]" priority="4000" mode="M69">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.17&quot;]"/>
    <axsl:choose>
      <axsl:when test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.3&quot;]              and self::cda:encounter[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.21&quot;]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="ancestor::cda:section[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.3&quot;] and self::cda:encounter[cda:templateId/@root=&quot;2.16.840.1.113883.10.20.1.21&quot;]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: The HITSP/C32 templateId for Encounter entry (2.16.840.1.113883.3.88.11.32.17) is in the wrong location. A HITSP/C32 Encounter entry data element shall be represented as a CCD Encounter activity (2.16.840.1.113883.10.20.1.21) under a CCD Encounter section (2.16.840.1.113883.10.20.1.3). The C32 templateId for Encounter entry may optionally be included on the CCD Encounter activity element. See Section 2.2.1.17 Table 2.2.1.17-2.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M69"/>
  </axsl:template>
  <axsl:template match="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.17&quot;]" priority="3999" mode="M69">
    <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[cda:templateId/@root=&quot;2.16.840.1.113883.3.88.11.32.17&quot;]"/>
    <axsl:choose>
      <axsl:when test="cda:id[@nullFlavor or @root]"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:id[@nullFlavor or @root]">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Encounter entry data element shall contain a C32 Encounter ID element to identify this encounter instance. If a specific ID is unknown, a nullFlavor attribute with an appropriate value may be used. See Section 2.2.1.17 Table 2.2.1.17-2 Item 16.01.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:text/cda:reference/@value or cda:code/cda:originalText/cda:reference/@value"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:text/cda:reference/@value or cda:code/cda:originalText/cda:reference/@value">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Encounter entry data element shall contain a C32 Encounter Free Text Type element to describe the encounter type. The description may appear under cda:originalText in cda:code or under cda:text. In either case a cda:reference/@value is required to identify required text in the parent section. See Section 2.2.1.17 Table 2.2.1.17-2 Item 16.03.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:choose>
      <axsl:when test="cda:effectiveTime"/>
      <axsl:otherwise>
        <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" test="cda:effectiveTime">
          <axsl:attribute name="location">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
          </axsl:attribute>
          <svrl:text>Error: A HITSP/C32 Encounter entry data element shall contain a C32 Encounter DateTime element. See Section 2.2.1.17 Table 2.2.1.17-2 Item 16.04.</svrl:text>
        </svrl:failed-assert>
      </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates mode="M69"/>
  </axsl:template>
  <axsl:template match="text()" priority="-1" mode="M69"/>
  <axsl:template match="text()" priority="-1"/>
</axsl:stylesheet>
