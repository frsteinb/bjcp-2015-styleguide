<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:bjcp="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">



  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



  <xsl:template match="/bjcp:styleguide">
    <xsl:element name="html">
      <xsl:element name="head">
	<xsl:element name="title">
	  <xsl:text>BJCP 2015 Styleguide</xsl:text>
	</xsl:element>
	<xsl:element name="style">

styleguide { 
  font-family: Helvetica, Arial, Geneva, sans-serif;
  font-size: 8pt;
}

styleguide chapter table {
  font-size: 8pt;
}

styleguide p.list-item {
  list-style-type: decimal;
}

styleguide category, styleguide subcategory {
  font-size: 9pt;
  margin-top:1em;
  margin-bottom:1em;
  margin-left:0em;
  display: list-item;
  list-style-position: inside;
}

styleguide p {
  margin-top:1em;
}

styleguide b {
  font-weight: bold;
}

styleguide i {
  font-style: italic;
}

styleguide u {
  text-decoration: underline;
}

styleguide category:before, styleguide subcategory:before {
  content: attr(id);
}
styleguide name {
  display: inline-block;
  margin-bottom:1em;
}
styleguide description {
  font-size: 8pt;
  margin-left:1em;
  display: block;
}
styleguide description p {
  margin-top: 0;
}

styleguide overall-impression:before {
  content: "Overall Impression: ";
}
styleguide aroma:before {
  content: "Aroma: ";
}
styleguide appearance:before {
  content: "Appearance: ";
}
styleguide flavor:before {
  content: "Flavor: ";
}
styleguide mouthfeel:before {
  content: "Mouthfeel: ";
}
styleguide comments:before {
  content: "Comments: ";
}
styleguide history:before {
  content: "History: ";
}
styleguide characteristic-ingredients:before {
  content: "Characteristic Ingredients: ";
}
styleguide style-comparison:before {
  content: "Style Comparison: ";
}
styleguide entry-instructions:before {
  content: "Entry Instructions: ";
}
styleguide specs:before {
  content: "Vital Statistics: ";
}
styleguide commercial-examples:before {
  content: "Commercial Examples: ";
}
styleguide tags:before {
  content: "Tags: ";
}
styleguide strength-classifications:before {
  content: "Strength Classifications: ";
}

styleguide overall-impression,
styleguide aroma,
styleguide appearance,
styleguide flavor,
styleguide mouthfeel,
styleguide comments,
styleguide history,
styleguide characteristic-ingredients,
styleguide style-comparison,
styleguide specs,
styleguide entry-instructions,
styleguide commercial-examples,
styleguide tags,
styleguide strength-classifications {
  position: relative;
  margin-left: 1em;
  display: block;
  font-size: 8pt;
}
styleguide overall-impression:before,
styleguide aroma:before,
styleguide appearance:before,
styleguide flavor:before,
styleguide mouthfeel:before,
styleguide comments:before,
styleguide history:before,
styleguide characteristic-ingredients:before,
styleguide style-comparison:before,
styleguide specs:before,
styleguide entry-instructions:before,
styleguide commercial-examples:before,
styleguide tags:before,
styleguide strength-classifications:before {
  font-weight: bold;
}

styleguide specs div.ibu:before {
  content: "IBU: ";
}
styleguide specs div.srm:before {
  content: "SRM: ";
}
styleguide specs div.og:before {
  content: "OG: ";
}
styleguide specs div.fg:before {
  content: "FG: ";
}
styleguide specs div.abv:before {
  content: "ABV: ";
}
styleguide specs div {
  display: inline-block;
}
styleguide specs div * {
  border: 1px solid;
  display: inline-block;
  width: 9em;
}

	</xsl:element>
      </xsl:element>
      <xsl:element name="body">
	<xsl:apply-templates select="." mode="copy"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>



  <xsl:template match="bjcp:specs" mode="copy">
    <xsl:element name="specs">
      <xsl:value-of select="./text()"/>
      <xsl:if test="bjcp:ibu or bjcp:srm or bjcp:og or bjcp:fg or bjcp:abv">
	<xsl:element name="div">
	  <xsl:if test="bjcp:ibu">
	    <xsl:element name="div">
	      <xsl:attribute name="class">ibu</xsl:attribute>
	      <xsl:if test="bjcp:ibu/@min">
		<xsl:value-of select="bjcp:ibu/@min"/>
		<xsl:text> – </xsl:text>
		<xsl:value-of select="bjcp:ibu/@max"/>
	      </xsl:if>
	      <xsl:value-of select="normalize-space(bjcp:ibu/text())"/>
	    </xsl:element>
	  </xsl:if>
	  <xsl:if test="bjcp:srm">
	    <xsl:element name="div">
	      <xsl:attribute name="class">srm</xsl:attribute>
	      <xsl:if test="bjcp:srm/@min">
		<xsl:value-of select="bjcp:srm/@min"/>
		<xsl:text> – </xsl:text>
		<xsl:value-of select="bjcp:srm/@max"/>
	      </xsl:if>
	      <xsl:value-of select="normalize-space(bjcp:srm/text())"/>
	    </xsl:element>
	  </xsl:if>
	  <xsl:if test="bjcp:og">
	    <xsl:element name="div">
	      <xsl:attribute name="class">og</xsl:attribute>
	      <xsl:if test="bjcp:og/@min">
		<xsl:value-of select="bjcp:og/@min"/>
		<xsl:text> – </xsl:text>
		<xsl:value-of select="bjcp:og/@max"/>
	      </xsl:if>
	      <xsl:value-of select="normalize-space(bjcp:og/text())"/>
	    </xsl:element>
	  </xsl:if>
	  <xsl:if test="bjcp:fg">
	    <xsl:element name="div">
	      <xsl:attribute name="class">fg</xsl:attribute>
	      <xsl:if test="bjcp:fg/@min">
		<xsl:value-of select="bjcp:fg/@min"/>
		<xsl:text> – </xsl:text>
		<xsl:value-of select="bjcp:fg/@max"/>
	      </xsl:if>
	      <xsl:value-of select="normalize-space(bjcp:fg/text())"/>
	    </xsl:element>
	  </xsl:if>
	  <xsl:if test="bjcp:abv">
	    <xsl:element name="div">
	      <xsl:attribute name="class">abv</xsl:attribute>
	      <xsl:if test="bjcp:abv/@min">
		<xsl:value-of select="bjcp:abv/@min"/>
		<xsl:text> – </xsl:text>
		<xsl:value-of select="bjcp:abv/@max"/>
	      </xsl:if>
	      <xsl:value-of select="normalize-space(bjcp:abv/text())"/>
	    </xsl:element>
	  </xsl:if>
	</xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>



  <xsl:template match="bjcp:a" mode="copy">
    <xsl:variable name="idref">
      <xsl:value-of select="@idref"/>
    </xsl:variable>
    <xsl:element name="{local-name(.)}">
      <xsl:attribute name="href">
	<xsl:text>#</xsl:text>
	<xsl:value-of select="$idref"/>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="string-length(./text()) > 0">
	  <xsl:value-of select="./text()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="//bjcp:styleguide//*[@id=$idref]/bjcp:name"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>



  <xsl:template match="bjcp:*" mode="copy">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates mode="copy"/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="@id" mode="copy">
    <xsl:attribute name="id">
      <xsl:choose>
	<xsl:when test="contains(.,'-')">
	  <xsl:value-of select="substring-before(.,'-')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="."/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>



  <xsl:template match="@* | text()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates mode="copy"/>
    </xsl:copy>
  </xsl:template>



</xsl:stylesheet>
