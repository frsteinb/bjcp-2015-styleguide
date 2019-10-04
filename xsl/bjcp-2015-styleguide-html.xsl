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
styleguide chapter {
  display: list-item;
  list-style-position: inside;
}
styleguide category {
  display: list-item;
  list-style-position: inside;
}
styleguide category:before {
  display: inline;
  content: attr(id);
}
styleguide category name {
  display: inline;
}
styleguide category * {
  display: none;
}
styleguide category subcategory {
  display: none;
}

	</xsl:element>
      </xsl:element>
      <xsl:element name="body">
	<!--<xsl:apply-templates select="chapter"/>-->
	<xsl:apply-templates select="." mode="copy"/>
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
