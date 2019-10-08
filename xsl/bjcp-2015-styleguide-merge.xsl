<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
    xmlns="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:bjcp="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:dyn="http://exslt.org/dynamic"
    extension-element-prefixes="exsl dyn">



  <xsl:param name="snippet"></xsl:param>



  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



  <xsl:variable name="snippetid">
    <xsl:choose>
      <xsl:when test="document(concat('../',$snippet))/bjcp:styleguide/bjcp:category/bjcp:subcategory/bjcp:subcategory">
	<xsl:value-of select="document(concat('../',$snippet))/bjcp:styleguide/bjcp:category/bjcp:subcategory/bjcp:subcategory[@id]/@id"/>
      </xsl:when>
      <xsl:when test="document(concat('../',$snippet))/bjcp:styleguide/bjcp:category/bjcp:subcategory">
	<xsl:value-of select="document(concat('../',$snippet))/bjcp:styleguide/bjcp:category/bjcp:subcategory[@id]/@id"/>
      </xsl:when>
      <xsl:when test="document(concat('../',$snippet))/bjcp:styleguide/bjcp:category">
	<xsl:value-of select="document(concat('../',$snippet))/bjcp:styleguide/bjcp:category[@id]/@id"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>unknown</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="snippetnode" select="document(concat('../',$snippet))/bjcp:styleguide//bjcp:*[@id = $snippetid]"/>


  <!-- suppress these tags in translations -->
  <xsl:template match="bjcp:tags|bjcp:specs">
  </xsl:template>



  <xsl:template match="bjcp:*">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="bjcp:name|bjcp:description|bjcp:overall-impression|bjcp:aroma|bjcp:appearance|bjcp:flavor|bjcp:mouthfeel|bjcp:comments|bjcp:history|bjcp:characteristic-ingredients|bjcp:style-comparison|bjcp:entry-instructions|bjcp:commercial-examples">
    <xsl:variable name="name">
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:element name="{$name}">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
	<xsl:when test="(../@id = $snippetid) and ($snippetnode/bjcp:*[local-name(.)=$name])">
	  <xsl:apply-templates select="$snippetnode/bjcp:*[local-name(.)=$name]/bjcp:* | $snippetnode/bjcp:*[local-name(.)=$name]/text()"/>
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
  </xsl:template>



</xsl:stylesheet>
