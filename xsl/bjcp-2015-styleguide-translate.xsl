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



  <xsl:template match="bjcp:*">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="bjcp:styleguide">
    <xsl:element name="{local-name(.)}">
      <xsl:attribute name="lang">
	<xsl:value-of select="$lang"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*[local-name(.) != 'lang']"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="bjcp:chapter">
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
      <xsl:text>')/bjcp:styleguide/bjcp:chapter</xsl:text>
    </xsl:variable>
    <xsl:apply-templates select="." mode="chapter">
      <xsl:with-param name="t" select="$p"/>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template match="bjcp:category">
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
      <xsl:text>')/bjcp:styleguide/bjcp:category[@id='</xsl:text>
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



  <xsl:template match="bjcp:category/bjcp:subcategory">
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
      <xsl:text>')/bjcp:styleguide/bjcp:category/bjcp:subcategory[@id='</xsl:text>
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



  <xsl:template match="bjcp:category/bjcp:subcategory/bjcp:subcategory">
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
      <xsl:text>')/bjcp:styleguide/bjcp:category/bjcp:subcategory/bjcp:subcategory[@id='</xsl:text>
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



  <xsl:template match="bjcp:chapter" mode="chapter">
    <xsl:param name="t"/>
    <xsl:variable name="p">
      <xsl:value-of select="$t"/>
    </xsl:variable>
    <xsl:element name="chapter">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
	<xsl:when test="dyn:evaluate($p)">
	  <xsl:apply-templates select="dyn:evaluate($p)/bjcp:* | dyn:evaluate($p)/text()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>



  <xsl:template match="bjcp:name|bjcp:description|bjcp:overall-impression|bjcp:aroma|bjcp:appearance|bjcp:flavor|bjcp:mouthfeel|bjcp:comments|bjcp:history|bjcp:characteristic-ingredients|bjcp:style-comparison|bjcp:entry-instructions|bjcp:commercial-examples">
    <xsl:param name="t"/>
    <xsl:variable name="p">
      <xsl:value-of select="$t"/>
      <xsl:text>/bjcp:</xsl:text>
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:element name="{local-name(.)}">
      <xsl:choose>
	<xsl:when test="dyn:evaluate($p)">
	  <xsl:attribute name="source">lang-file</xsl:attribute>
	  <xsl:apply-templates select="dyn:evaluate($p)/@*"/>
	  <xsl:apply-templates select="dyn:evaluate($p)/bjcp:* | dyn:evaluate($p)/text()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="source">original</xsl:attribute>
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
