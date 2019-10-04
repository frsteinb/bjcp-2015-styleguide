<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">



  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



  <xsl:template match="/styleguide">
    <xsl:element name="html">
      <xsl:element name="head">
	<xsl:element name="title">
	  <xsl:text>BJCP 2015 Styleguide</xsl:text>
	</xsl:element>
	<xsl:element name="style">

styleguide { 
  font-family: Helvetica, Arial, Geneva, sans-serif;
}

styleguide chapter, styleguide category, styleguide subcategory {
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

styleguide span.bold {
  font-weight: bold;
}

styleguide span.italic {
  font-style: italic;
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
styleguide tags {
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
styleguide tags:before {
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
	<!--<xsl:apply-templates select="chapter"/>-->
	<xsl:apply-templates select="." mode="copy"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>



  <xsl:template match="specs" mode="copy">
    <xsl:element name="specs">
      <xsl:element name="div">
        <xsl:element name="div">
  	<xsl:attribute name="class">ibu</xsl:attribute>
  	<xsl:value-of select="ibu/@min"/>
  	<xsl:text> - </xsl:text>
  	<xsl:value-of select="ibu/@max"/>
        </xsl:element>
        <xsl:element name="div">
  	<xsl:attribute name="class">srm</xsl:attribute>
  	<xsl:value-of select="srm/@min"/>
  	<xsl:text> - </xsl:text>
  	<xsl:value-of select="srm/@max"/>
        </xsl:element>
        <xsl:element name="div">
  	<xsl:attribute name="class">og</xsl:attribute>
  	<xsl:value-of select="og/@min"/>
  	<xsl:text> - </xsl:text>
  	<xsl:value-of select="og/@max"/>
        </xsl:element>
        <xsl:element name="div">
  	<xsl:attribute name="class">fg</xsl:attribute>
  	<xsl:value-of select="fg/@min"/>
  	<xsl:text> - </xsl:text>
  	<xsl:value-of select="fg/@max"/>
        </xsl:element>
        <xsl:element name="div">
  	<xsl:attribute name="class">abv</xsl:attribute>
  	<xsl:value-of select="abv/@min"/>
  	<xsl:text> - </xsl:text>
  	<xsl:value-of select="abv/@max"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>



  <xsl:template match="*" mode="copy">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates mode="copy"/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="@* | text()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates mode="copy"/>
    </xsl:copy>
  </xsl:template>



</xsl:stylesheet>
