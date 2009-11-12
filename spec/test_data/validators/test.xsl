<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
    <results>
     <xsl:apply-templates select="famous-persons/persons/*">
       <xsl:sort select="@category" />
     </xsl:apply-templates>
      <xsl:text> 
       </xsl:text>
   </results>
  </xsl:template>


  <xsl:template match="person">
    <xsl:text> 
    </xsl:text>
   <xsl:value-of select="firstname" />, <xsl:value-of select="name"      /> 
  </xsl:template>

</xsl:stylesheet>

