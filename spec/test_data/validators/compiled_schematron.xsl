<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" version="1.0">
<xsl:output method="xml" omit-xml-declaration="no" standalone="yes" indent="yes" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron"/>
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
<svrl:schematron-output xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Schematron schema for validating conformance to CCD documents" schemaVersion="">
<xsl:attribute name="phase">errors</xsl:attribute>
<marker/>
<svrl:active-pattern>
<xsl:attribute name="id">Required ID</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M2"/>
<svrl:active-pattern>
<xsl:attribute name="id">Required IDREF</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M3"/>
<svrl:active-pattern>
<xsl:attribute name="id">IDREF should reference an ID used in the same document</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M4"/>
<svrl:active-pattern>
<xsl:attribute name="id">IDREF should reference an ID of a certain element type only</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M5"/>
</svrl:schematron-output>
</xsl:template>
<xsl:template match="cat | dog" priority="4000" mode="M2">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cat | dog"/>
<xsl:choose>
<xsl:when test="@id"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@id">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>An element of type<xsl:text xml:space="preserve"> </xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:text xml:space="preserve"> </xsl:text>should have an id attribute that is a unique identifier for that animal.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates mode="M2"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M2"/>
<xsl:template match="catowner" priority="4000" mode="M3">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="catowner"/>
<xsl:choose>
<xsl:when test="@pet"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@pet">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>An element of type<xsl:text xml:space="preserve"> </xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:text xml:space="preserve"> </xsl:text>should have a pet attribute.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates mode="M3"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M3"/>
<xsl:template match="catowner[@pet]" priority="4000" mode="M4">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="catowner[@pet]"/>
<xsl:choose>
<xsl:when test="id(@pet)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="id(@pet)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>An element of type<xsl:text xml:space="preserve"> </xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:text xml:space="preserve"> </xsl:text>should have a pet attribute that should contain a unique identifier.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates mode="M4"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M4"/>
<xsl:template match="catowner[@pet]" priority="4000" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="catowner[@pet]"/>
<xsl:choose>
<xsl:when test="(name(id(@pet)) ='cat')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(name(id(@pet)) ='cat')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>An element of type<xsl:text xml:space="preserve"> </xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:text xml:space="preserve"> </xsl:text>should have a pet attribute that should contain the unique identifier for a cat.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates mode="M5"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M5"/>
<xsl:template match="text()" priority="-1"/>
</xsl:stylesheet>
