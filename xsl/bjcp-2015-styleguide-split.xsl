<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:bjcp="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:dyn="http://exslt.org/dynamic"
    extension-element-prefixes="exsl str dyn date">



  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



  <xsl:template match="/bjcp:styleguide">
    <xsl:apply-templates select="bjcp:chapter"/>
    <xsl:apply-templates select="bjcp:category"/>
    <xsl:apply-templates select="bjcp:category/bjcp:subcategory"/>
    <xsl:apply-templates select="bjcp:category/bjcp:subcategory/bjcp:subcategory"/>
  </xsl:template>



  <xsl:template match="/bjcp:styleguide/bjcp:chapter">
    <xsl:variable name="filename">
      <xsl:text>orig/</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <exsl:document href="{$filename}" method="xml" version="1.0" encoding="UTF-8" indent="yes">
      <xsl:element name="styleguide">
        <xsl:element name="chapter">
          <xsl:apply-templates select="@*"/>
          <xsl:apply-templates select="*"/>
        </xsl:element>
      </xsl:element>
    </exsl:document>
  </xsl:template>



  <xsl:template match="/bjcp:styleguide/bjcp:category">
    <xsl:variable name="filename">
      <xsl:text>orig/</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <exsl:document href="{$filename}" method="xml" version="1.0" encoding="UTF-8" indent="yes">
      <xsl:element name="styleguide">
        <xsl:element name="category">
          <xsl:apply-templates select="@*"/>
          <xsl:apply-templates select="*[not(local-name()='subcategory')]"/>
        </xsl:element>
      </xsl:element>
    </exsl:document>
  </xsl:template>



  <xsl:template match="/bjcp:styleguide/bjcp:category/bjcp:subcategory">
    <xsl:variable name="filename">
      <xsl:text>orig/</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <exsl:document href="{$filename}" method="xml" version="1.0" encoding="UTF-8" indent="yes">
      <xsl:element name="styleguide">
        <xsl:element name="category">
          <xsl:apply-templates select="../@*"/>
          <xsl:element name="subcategory">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*[not(local-name()='subcategory')]"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </exsl:document>
  </xsl:template>



  <xsl:template match="/bjcp:styleguide/bjcp:category/bjcp:subcategory/bjcp:subcategory">
    <xsl:variable name="filename">
      <xsl:text>orig/</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <exsl:document href="{$filename}" method="xml" version="1.0" encoding="UTF-8" indent="yes">
      <xsl:element name="styleguide">
        <xsl:element name="category">
          <xsl:apply-templates select="../../@*"/>
          <xsl:element name="subcategory">
            <xsl:apply-templates select="../@*"/>
            <xsl:element name="subcategory">
              <xsl:apply-templates select="@*"/>
              <xsl:apply-templates select="*[not(local-name()='subcategory')]"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </exsl:document>
  </xsl:template>



  <!-- suppress these tags in translations -->
  <xsl:template match="bjcp:tags|bjcp:specs">
  </xsl:template>



  <xsl:template match="*">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="@* | text()">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>



</xsl:stylesheet>
