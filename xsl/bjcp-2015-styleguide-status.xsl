<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
    xmlns="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:bjcp="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:dyn="http://exslt.org/dynamic"
    extension-element-prefixes="exsl dyn">



  <xsl:param name="lang">de</xsl:param>



  <xsl:output method="text" version="1.0" encoding="UTF-8"/>



  <xsl:template match="bjcp:*">
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
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
    <xsl:text>
</xsl:text>
  </xsl:template>



  <xsl:template match="bjcp:category">
    <xsl:value-of select="@id"/>
    <xsl:text>:</xsl:text>
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
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="bjcp:*[not(local-name(.)='subcategory')]">
      <xsl:with-param name="t" select="$p"/>
    </xsl:apply-templates>
    <xsl:text>
</xsl:text>
    <xsl:apply-templates select="bjcp:*[local-name(.)='subcategory']">
      <xsl:with-param name="t" select="$p"/>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template match="bjcp:category/bjcp:subcategory">
    <xsl:value-of select="@id"/>
    <xsl:text>:</xsl:text>
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
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="bjcp:*[not(local-name(.)='subcategory')]">
      <xsl:with-param name="t" select="$p"/>
    </xsl:apply-templates>
    <xsl:text>
</xsl:text>
    <xsl:apply-templates select="bjcp:*[local-name(.)='subcategory']">
      <xsl:with-param name="t" select="$p"/>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template match="bjcp:category/bjcp:subcategory/bjcp:subcategory">
    <xsl:value-of select="@id"/>
    <xsl:text>:</xsl:text>
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
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates>
      <xsl:with-param name="t" select="$p"/>
    </xsl:apply-templates>
    <xsl:text>
</xsl:text>
  </xsl:template>



  <xsl:template match="bjcp:chapter" mode="chapter">
    <xsl:param name="t"/>
    <xsl:value-of select="@id"/>
    <xsl:text>:</xsl:text>
    <xsl:variable name="p">
      <xsl:value-of select="$t"/>
    </xsl:variable>
    <xsl:apply-templates select="@*"/>
    <xsl:choose>
      <xsl:when test="dyn:evaluate($p)">
	<xsl:apply-templates select="dyn:evaluate($p)/* | dyn:evaluate($p)/text()"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="bjcp:name|bjcp:description|bjcp:overall-impression|bjcp:aroma|bjcp:appearance|bjcp:flavor|bjcp:mouthfeel|bjcp:comments|bjcp:history|bjcp:characteristic-ingredients|bjcp:style-comparison|bjcp:entry-instructions|bjcp:commercial-examples">
    <xsl:param name="t"/>
    <xsl:variable name="p">
      <xsl:value-of select="$t"/>
      <xsl:text>/bjcp:</xsl:text>
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:apply-templates select="@*"/>
    <xsl:choose>
      <xsl:when test="dyn:evaluate($p)">
	<xsl:text>+</xsl:text>
	<xsl:apply-templates select="dyn:evaluate($p)/* | dyn:evaluate($p)/text()"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>-</xsl:text>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!-- suppress these tags in translations -->
  <xsl:template match="bjcp:tags|bjcp:specs">
  </xsl:template>



  <xsl:template match="@*">
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:template>



  <xsl:template match="text()">
    <xsl:apply-templates/>
  </xsl:template>



</xsl:stylesheet>
