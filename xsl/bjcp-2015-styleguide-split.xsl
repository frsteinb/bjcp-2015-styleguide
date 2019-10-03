<?xml version="1.0"?>



<xsl:stylesheet 
    version="1.0" 
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:dyn="http://exslt.org/dynamic"
    extension-element-prefixes="exsl str dyn date">



  <xsl:template match="/styleguide">
    <!--<xsl:apply-templates select="chapter"/>-->
    <xsl:apply-templates select="category"/>
    <xsl:apply-templates select="category/subcategory"/>
    <xsl:apply-templates select="category/subcategory/subcategory"/>
  </xsl:template>



  <xsl:template match="/styleguide/category">
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



  <xsl:template match="/styleguide/category/subcategory">
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



  <xsl:template match="/styleguide/category/subcategory/subcategory">
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
