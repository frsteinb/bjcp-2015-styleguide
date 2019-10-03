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



  <xsl:template match="category">
    <xsl:variable name="d">
      <xsl:text>../</xsl:text>
      <xsl:value-of select="$lang"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <xsl:variable name="p">
      <xsl:text>document('</xsl:text>
      <xsl:value-of select="$d"/>
      <xsl:text>')/styleguide/category[@id='</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>']</xsl:text>
    </xsl:variable>
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates>
	<xsl:with-param name="t" select="$p"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>



  <xsl:template match="category/subcategory">
    <xsl:variable name="d">
      <xsl:text>../</xsl:text>
      <xsl:value-of select="$lang"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <xsl:variable name="p">
      <xsl:text>document('</xsl:text>
      <xsl:value-of select="$d"/>
      <xsl:text>')/styleguide/category/subcategory[@id='</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>']</xsl:text>
    </xsl:variable>
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates>
	<xsl:with-param name="t" select="$p"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>



  <xsl:template match="category/subcategory/subcategory">
    <xsl:variable name="d">
      <xsl:text>../</xsl:text>
      <xsl:value-of select="$lang"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <xsl:variable name="p">
      <xsl:text>document('</xsl:text>
      <xsl:value-of select="$d"/>
      <xsl:text>')/styleguide/category/subcategory/subcategory[@id='</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>']</xsl:text>
    </xsl:variable>
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates>
	<xsl:with-param name="t" select="$p"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>



  <xsl:template match="name|description|overall-impression|aroma|appearance|flavor|mouthfeel|comments|history|characteristic-ingredients|style-comparison|entry-instructions|commercial-examples">
    <xsl:param name="t"/>
    <xsl:variable name="p">
      <xsl:value-of select="$t"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
	<xsl:when test="dyn:evaluate($p)">
	  <xsl:apply-templates select="dyn:evaluate($p)/* | dyn:evaluate($p)/text()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>



  <xsl:template match="@*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>



  <xsl:template match="text()">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
<!--
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
-->
  </xsl:template>



</xsl:stylesheet>
