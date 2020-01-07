<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
    xmlns="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:bjcp="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:dyn="http://exslt.org/dynamic"
    extension-element-prefixes="exsl dyn">



  <xsl:param name="lang">de</xsl:param>



  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



  <xsl:variable name="snippetid">
    <xsl:choose>
      <xsl:when test="/bjcp:styleguide/bjcp:category/bjcp:subcategory/bjcp:subcategory">
	<xsl:value-of select="/bjcp:styleguide/bjcp:category/bjcp:subcategory/bjcp:subcategory[@id]/@id"/>
      </xsl:when>
      <xsl:when test="/bjcp:styleguide/bjcp:category/bjcp:subcategory">
	<xsl:value-of select="/bjcp:styleguide/bjcp:category/bjcp:subcategory[@id]/@id"/>
      </xsl:when>
      <xsl:when test="/bjcp:styleguide/bjcp:category">
	<xsl:value-of select="/bjcp:styleguide/bjcp:category[@id]/@id"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>unknown</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="snippetnode" select="/bjcp:styleguide//bjcp:*[@id = $snippetid]"/>

  <xsl:variable name="origroot" select="document(concat('../orig/',$snippetid,'.xml'))/bjcp:styleguide"/>

  <xsl:variable name="orignode" select="$origroot//bjcp:*[@id = $snippetid]"/>

  <xsl:variable name="targetfilename">
    <xsl:value-of select="$lang"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$snippetid"/>
    <xsl:text>.xml</xsl:text>
  </xsl:variable>

  <xsl:variable name="langroot" select="document(concat('../',$lang,'/',$snippetid,'.xml'))/bjcp:styleguide"/>

  <xsl:variable name="langnode" select="$langroot//bjcp:*[@id = $snippetid]"/>



  <xsl:template match="/bjcp:styleguide">
    <exsl:document href="{$targetfilename}" method="xml" version="1.0" encoding="UTF-8" indent="yes">
      <xsl:element name="styleguide">
	<xsl:apply-templates />
      </xsl:element>
    </exsl:document>
  </xsl:template>



  <!-- suppress these tags in translations -->
  <xsl:template match="bjcp:tags|bjcp:specs">
  </xsl:template>
  <xsl:template match="bjcp:tags|bjcp:specs" mode="merge">
  </xsl:template>
  


  <xsl:template match="bjcp:*">
    <xsl:variable name="thisid">
      <xsl:value-of select="@id"/>
    </xsl:variable>
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*"/>
      <!-- special handling for the target id -->
      <xsl:choose>
	<xsl:when test="$thisid = $snippetid">
	  <xsl:apply-templates select="$orignode/bjcp:*" mode="merge"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>



  <!-- somehow some strange elements may find its way into snippets -->
  <xsl:template match="bjcp:div | bjcp:span">
    <xsl:apply-templates/>
  </xsl:template>



  <xsl:template match="bjcp:name|bjcp:description|bjcp:overall-impression|bjcp:aroma|bjcp:appearance|bjcp:flavor|bjcp:mouthfeel|bjcp:comments|bjcp:history|bjcp:characteristic-ingredients|bjcp:style-comparison|bjcp:entry-instructions|bjcp:commercial-examples|bjcp:specs">
    <xsl:variable name="name">
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:element name="{$name}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="bjcp:name|bjcp:description|bjcp:overall-impression|bjcp:aroma|bjcp:appearance|bjcp:flavor|bjcp:mouthfeel|bjcp:comments|bjcp:history|bjcp:characteristic-ingredients|bjcp:style-comparison|bjcp:entry-instructions|bjcp:commercial-examples|bjcp:specs|bjcp:ibu|bjcp:srm|bjcp:og|bjcp:fg|bjcp:abv" mode="merge">
    <xsl:variable name="name">
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$snippetnode/*[local-name(.)=$name]">
	<xsl:element name="{$name}">
	  <xsl:apply-templates select="$snippetnode/bjcp:*[local-name(.)=$name]/@*"/>
	  <xsl:apply-templates select="$snippetnode/bjcp:*[local-name(.)=$name]/bjcp:* | $snippetnode/bjcp:*[local-name(.)=$name]/text()"/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$langnode/*[local-name(.)=$name]">
	<xsl:element name="{$name}">
	  <xsl:apply-templates select="$langnode/bjcp:*[local-name(.)=$name]/@*"/>
	  <xsl:apply-templates select="$langnode/bjcp:*[local-name(.)=$name]/bjcp:* | $langnode/bjcp:*[local-name(.)=$name]/text()"/>
	</xsl:element>
      </xsl:when>
    </xsl:choose>
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
