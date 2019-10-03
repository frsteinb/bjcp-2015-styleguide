<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:dyn="http://exslt.org/dynamic"
    extension-element-prefixes="exsl str dyn date">



  <xsl:param name="lang">de</xsl:param>



  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



  <xsl:template match="*">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="@*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>



  <xsl:template match="text()">
    <xsl:variable name="d">
      <xsl:value-of select="$lang"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="../../@id"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <xsl:value-of select="$d"/>
    <xsl:choose>
      <xsl:when test="document($d)">
	<xsl:apply-templates select="document($d)/*"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



</xsl:stylesheet>
