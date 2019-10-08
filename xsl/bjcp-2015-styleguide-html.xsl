<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:bjcp="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">



  <xsl:param name="edit">no</xsl:param>
  <xsl:param name="orig"></xsl:param>



  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



  <xsl:template match="/bjcp:styleguide">
    <xsl:element name="html">
      <xsl:element name="head">
	<xsl:element name="title">
	  <xsl:text>BJCP 2015 Styleguide</xsl:text>
	</xsl:element>
	<xsl:element name="link">
	  <xsl:attribute name="rel">stylesheet</xsl:attribute>
	  <xsl:attribute name="type">text/css</xsl:attribute>
	  <xsl:attribute name="href">bjcp-styleguide.css</xsl:attribute>
	</xsl:element>
	<xsl:element name="link">
	  <xsl:attribute name="rel">stylesheet</xsl:attribute>
	  <xsl:attribute name="type">text/css</xsl:attribute>
	  <xsl:attribute name="href">pell.css</xsl:attribute>
	</xsl:element>
	<xsl:if test="not($edit = 'no')">
	  <xsl:element name="link">
	    <xsl:attribute name="rel">stylesheet</xsl:attribute>
	    <xsl:attribute name="type">text/css</xsl:attribute>
	    <xsl:attribute name="href">edit.css</xsl:attribute>
	  </xsl:element>
	</xsl:if>
      </xsl:element>
      <xsl:element name="body">
	<xsl:apply-templates select="." mode="copy"/>
	<xsl:if test="not($edit = 'no')">
	  <div id="editor">
	    <div id="editor-inner">
	      <p>Editing <span id="editstylename">-</span>, element: <span id="editelemname">-</span>, last change: <span id="lastdate">-</span> by <span id="lastauthor">-</span></p>
	      <div id="original">-</div>
	      <p>Your Author ID: <input type="text" name="author" id="author" /></p>
	      <div id="pelleditor">-</div>
	      <div>Markup:<div id="markup">-</div></div>
	      <!--
		  <div>Preview:<div id="render">-</div></div>
		  -->
	    </div>
	  </div>
	  <div/>
	  <xsl:element name="script">
	    <xsl:attribute name="src">pell.js</xsl:attribute>
	    <xsl:text> </xsl:text>
	  </xsl:element>
	  <xsl:element name="script">
	    <xsl:attribute name="src">edit.js</xsl:attribute>
	    <xsl:text> </xsl:text>
	  </xsl:element>
	</xsl:if>
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
    <xsl:variable name="href">
      <xsl:value-of select="@href"/>
    </xsl:variable>
    <xsl:variable name="idref">
      <xsl:value-of select="translate(@href,'#','')"/>
    </xsl:variable>
    <xsl:element name="{local-name(.)}">
      <xsl:attribute name="href">
	<xsl:value-of select="$href"/>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="string-length(./text()) > 0">
	  <xsl:value-of select="./text()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="//bjcp:styleguide//bjcp:*[@id=$idref]/bjcp:name"/>
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



  <xsl:template match="bjcp:name|bjcp:description|bjcp:overall-impression|bjcp:aroma|bjcp:appearance|bjcp:flavor|bjcp:mouthfeel|bjcp:comments|bjcp:history|bjcp:characteristic-ingredients|bjcp:style-comparison|bjcp:entry-instructions|bjcp:commercial-examples" mode="copy">
    <xsl:variable name="name">
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:variable name="idref">
      <xsl:value-of select="../@id"/>
    </xsl:variable>
    <xsl:element name="{$name}">
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:if test="not($edit = 'no')">
	<xsl:attribute name="onclick">
	  <xsl:text>doedit(this);</xsl:text>
	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="copy"/>
    </xsl:element>
    <xsl:if test="$orig">
      <xsl:variable name="orignode" select="document(concat('../',$orig))/bjcp:styleguide//bjcp:*[@id=$idref]/bjcp:*[local-name(.) = $name]"/>
      <xsl:element name="{$name}">
	<xsl:apply-templates select="$orignode/@*" mode="copy"/>
	<xsl:attribute name="orig">true</xsl:attribute>
	<xsl:apply-templates select="$orignode/* | $orignode/text()" mode="copy"/>
      </xsl:element>
    </xsl:if>
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
