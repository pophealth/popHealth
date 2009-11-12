<?xml version="1.0" encoding="UTF-8"?>
<!-- 
   ISO_SVRL.xsl   

   Implementation of Schematron Validation Report Language from ISO Schematron
   ISO/IEC 19757 Document Schema Definition Languages (DSDL) 
     Part 3: Rule-based validation  Schematron 
     Annex D: Schematron Validation Report Language 

  This ISO Standard is available free as a Publicly Available Specification in PDF from ISO.
  Also see www.schematron.com for drafts and other information.

  This implementation of 

  History:
    2001: Conformance1-5.xsl Rick Jelliffe, using the skeleton code contributed by Oliver Becker
    2006: iso_svrl.xsl       Rick Jelliffe, update namespace, update phase handling,
                             add flag param to process-assert and process-report & @ flag on output
-->
<!--
 Derived from Conformance1-5.xsl.

 Copyright (c) 2001, 2006 Rick Jelliffe and Academia Sinica Computing Center, Taiwan

 This software is provided 'as-is', without any express or implied warranty. 
 In no event will the authors be held liable for any damages arising from 
 the use of this software.

 Permission is granted to anyone to use this software for any purpose, 
 including commercial applications, and to alter it and redistribute it freely,
 subject to the following restrictions:

 1. The origin of this software must not be misrepresented; you must not claim
 that you wrote the original software. If you use this software in a product, 
 an acknowledgment in the product documentation would be appreciated but is 
 not required.

 2. Altered source versions must be plainly marked as such, and must not be 
 misrepresented as being the original software.

 3. This notice may not be removed or altered from any source distribution.
-->
<!-- Ideas nabbed from schematrons by Francis N., Miloslav N. and David C. -->
<!-- The command-line parameters are:
            diagnose=yes|no  (default is yes) 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">

<xsl:import href="skeleton1-6.xsl"/>
<!--
<xsl:import href="..\..\schematron\skeleton1-6.xsl"/>
<xsl:import href="..\..\schematron\iso_schematron_skeleton.xsl"/>
-->

<xsl:param name="diagnose">yes</xsl:param>
<xsl:param name="block"/><!-- reserved -->
<xsl:param name="phase">
  <xsl:choose>
    <!-- Handle Schematron 1.5 and 1.6 phases -->
    <xsl:when test="//sch:schema/@defaultPhase">
      <xsl:value-of select="//sch:schema/@defaultPhase"/>
    </xsl:when>
    <!-- Handle ISO Schematron phases -->
    <xsl:when test="//iso:schema/@defaultPhase">
      <xsl:value-of select="//iso:schema/@defaultPhase"/>
    </xsl:when>
    <xsl:otherwise>#ALL</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:template name="process-prolog">
   <axsl:output method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>
</xsl:template>

<xsl:template name="process-root">
   <xsl:param name="title"/>
   <xsl:param name="contents"/>
   <xsl:param name="schemaVersion">unknown</xsl:param>
   <!-- unused params: fpi, id, icon, lang, version -->
   <svrl:schematron-output title="{$title}" schemaVersion="{$schemaVersion}">
   
			<xsl:if test=" string-length( $phase ) &gt; 0 and not( $phase = '#ALL') ">
                <xsl:attribute name="phase"><xsl:value-of select=" $phase "/></xsl:attribute>
            </xsl:if>
      <xsl:apply-templates mode="do-schema-p"/>
      <xsl:copy-of select="$contents"/>
   </svrl:schematron-output>
</xsl:template>

<xsl:template name="process-assert">
   <xsl:param name="id"/>
   <xsl:param name="test"/>
   <xsl:param name="role"/>
   <xsl:param name="diagnostics"/>
   <xsl:param name="flag"/>
		<svrl:failed-assert test="{$test}">
		    
			<xsl:if test=" string-length( $id ) &gt; 0">
                <xsl:attribute name="id"><xsl:value-of select=" $id "/></xsl:attribute>
            </xsl:if>
            
			<xsl:if test=" string-length( $role ) &gt; 0">
                <xsl:attribute name="role"><xsl:value-of select=" $role "/></xsl:attribute>
            </xsl:if>
			<axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute>
			<xsl:if test=" string-length( $flag ) &gt; 0">
                        <xsl:attribute name="flag"><xsl:value-of select=" $flag "/></xsl:attribute>
                  </xsl:if>
	         	
	         	<xsl:if test="$diagnose = 'yes'">
                           <xsl:call-template name="diagnosticsSplit">
	  			<xsl:with-param name="str" select="$diagnostics"/>
		 	   </xsl:call-template>
                        </xsl:if>
 			<svrl:text><xsl:apply-templates mode="text"/></svrl:text>
            </svrl:failed-assert>
</xsl:template>


<xsl:template name="process-report">
           <xsl:param name="id"/>
		<xsl:param name="test"/>
		<xsl:param name="role"/>
   		<xsl:param name="diagnostics"/>
            <xsl:param name="flag"/>
		<svrl:successful-report test="{$test}">
		
			<xsl:if test=" string-length( $id ) &gt; 0">
                <xsl:attribute name="id"><xsl:value-of select=" $id "/></xsl:attribute>
            </xsl:if>
            
			<xsl:if test=" string-length( $role ) &gt; 0">
                <xsl:attribute name="role"><xsl:value-of select=" $role "/></xsl:attribute>
            </xsl:if>
			<axsl:attribute name="location"><axsl:apply-templates select="." mode="schematron-get-full-path"/></axsl:attribute>
     			<xsl:if test=" string-length( $flag ) &gt; 0">
                        <xsl:attribute name="flag"><xsl:value-of select=" $flag "/></xsl:attribute>
                  </xsl:if>
        		<xsl:if test="$diagnose = 'yes'">
	         		<xsl:call-template name="diagnosticsSplit">
	  				<xsl:with-param name="str" select="$diagnostics"/>
		 		</xsl:call-template>
                        </xsl:if>
 			<svrl:text><xsl:apply-templates mode="text"/></svrl:text>
		</svrl:successful-report>
	</xsl:template>

<xsl:template name="process-diagnostic">
     <xsl:param name="id"/>
	<svrl:diagnostic-reference diagnostic="{$id}"><svrl:text/></svrl:diagnostic-reference>
</xsl:template>

<xsl:template name="process-rule">
     <xsl:param name="id"/>
	<xsl:param name="context"/>
	<xsl:param name="role"/>
      <svrl:fired-rule context="{$context}">
      
			<xsl:if test=" string-length( $id ) &gt; 0">
                <xsl:attribute name="id"><xsl:value-of select=" $id "/></xsl:attribute>
            </xsl:if>
            
			<xsl:if test=" string-length( $role ) &gt; 0">
                <xsl:attribute name="role"><xsl:value-of select=" $role "/></xsl:attribute>
            </xsl:if></svrl:fired-rule>
</xsl:template>


<xsl:template name="process-ns">
     <xsl:param name="prefix"/>
	<xsl:param name="uri"/>
  <svrl:ns uri="{$uri}" prefix="{$prefix}"/>
</xsl:template>

<xsl:template name="process-p">
		<!-- params: pattern, role -->
		<svrl:text><xsl:apply-templates mode="text"/></svrl:text>
</xsl:template>

<xsl:template name="process-pattern">
     <xsl:param name="name"/>
     <xsl:param name="role"/>
     <xsl:param name="id"/> 
  <svrl:active-pattern>
  
			<xsl:if test=" string-length( $name ) &gt; 0">
                <xsl:attribute name="name"><xsl:value-of select=" $name "/></xsl:attribute>
            </xsl:if>
            
			<xsl:if test=" string-length( $role ) &gt; 0">
                <xsl:attribute name="role"><xsl:value-of select=" $role "/></xsl:attribute>
            </xsl:if>
			<xsl:if test=" string-length( $id ) &gt; 0">
                <xsl:attribute name="id"><xsl:value-of select=" $id "/></xsl:attribute>
            </xsl:if>
            
      <xsl:if test=" string-length( $role ) &gt; 0 ">
                        <xsl:attribute name="role"><xsl:value-of select=" $role "/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="do-pattern-p"/>
      <axsl:apply-templates/>
   </svrl:active-pattern>
</xsl:template>

  
<xsl:template name="process-message"/>


</xsl:stylesheet>