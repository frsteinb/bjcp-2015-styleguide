<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:bjcp="http://heimbrauconvention.de/bjcp-styleguide/2015"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  xmlns:str="http://exslt.org/strings"
  xmlns:func="http://exslt.org/functions"
  xmlns:math="http://exslt.org/math"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:brew="http://frankensteiner.familie-steinberg.org/brew"
  extension-element-prefixes="exsl str func math date">



  <xsl:param name="lang">orig</xsl:param>



  <xsl:include href="../cache/config-current.xsl"/>
  
  

  <func:function name="brew:sgToPlato">
    <xsl:param name="sg"/>
    <xsl:variable name="r">
      <xsl:value-of select="(-1 * 616.868) + (1111.14 * $sg) - (630.272 * math:power($sg,2)) + (135.997 * math:power($sg,3))"/>
    </xsl:variable>
    <func:result select="$r"/>
  </func:function>



  <func:function name="brew:srmToEbc">
    <xsl:param name="srm"/>
    <xsl:variable name="r">
      <xsl:value-of select="$srm div 0.508"/>
    </xsl:variable>
    <func:result select="$r"/>
  </func:function>



  <func:function name="brew:bitterWort">
    <xsl:param name="ibu"/>
    <xsl:param name="sg"/>
    <xsl:variable name="plato">
      <xsl:value-of select="brew:sgToPlato($sg)"/>
    </xsl:variable>
    <xsl:variable name="q">
      <xsl:value-of select="$ibu div $plato"/>
    </xsl:variable>
    <xsl:variable name="r">
      <xsl:choose>
	<xsl:when test="1.5 >= $q">sehr malzig</xsl:when>
	<xsl:when test="2.0 >= $q">malzig</xsl:when>
	<xsl:when test="2.2 >= $q">ausgewogen</xsl:when>
	<xsl:when test="3.0 >= $q">herb</xsl:when>
	<xsl:when test="6.0 >= $q">sehr herb</xsl:when>
	<xsl:otherwise>Hopfenbombe</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <func:result select="$r"/>
  </func:function>



  <xsl:template match="/bjcp:styleguide">
    <exsl:document href="-" method="xml" encoding="UTF-8">
      <fo:root>
	<fo:layout-master-set>
	  <fo:simple-page-master master-name="simple" page-height="297mm" page-width="210mm">
	    <fo:region-body margin="0mm" padding="0mm"/>
	  </fo:simple-page-master>
	</fo:layout-master-set>
	<fo:page-sequence master-reference="simple">
	  <fo:flow flow-name="xsl-region-body">
	    <xsl:apply-templates select="( //bjcp:category | //bjcp:subcategory )"/>
	  </fo:flow>
	</fo:page-sequence>
      </fo:root>
    </exsl:document>
  </xsl:template>


  
  <xsl:template match="*" mode="section">
    <xsl:variable name="label">
      <xsl:choose>
        <!--<xsl:when test="local-name(.) = 'description'">Beschreibung</xsl:when>-->
        <xsl:when test="local-name(.) = 'description'"></xsl:when>
        <xsl:when test="local-name(.) = 'overall-impression'">Gesamteindruck</xsl:when>
        <xsl:when test="local-name(.) = 'aroma'">Geruch</xsl:when>
        <xsl:when test="local-name(.) = 'appearance'">Erscheinungsbild</xsl:when>
        <xsl:when test="local-name(.) = 'flavor'">Geschmack</xsl:when>
        <xsl:when test="local-name(.) = 'mouthfeel'">Mundgefühl</xsl:when>
        <xsl:when test="local-name(.) = 'comments'">Kommentare</xsl:when>
        <xsl:when test="local-name(.) = 'history'">Geschichte</xsl:when>
        <xsl:when test="local-name(.) = 'characteristic-ingredients'">Charakteristische Zutaten</xsl:when>
        <xsl:when test="local-name(.) = 'style-comparison'">Stilvergleich</xsl:when>
        <xsl:when test="local-name(.) = 'entry-instructions'">Einreichungsbestimmungen</xsl:when>
        <xsl:when test="local-name(.) = 'commercial-examples'">Kommerzielle Beispiele</xsl:when>
        <xsl:when test="local-name(.) = 'specs'">Eckdaten</xsl:when>
        <xsl:when test="local-name(.) = 'tags'">Tags</xsl:when>
        <xsl:when test="local-name(.) = 'strength-classifications'">Stärkeklassifikationen</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <fo:block>
      <xsl:if test="string-length($label) > 0">
	<xsl:value-of select="$label"/>
	<xsl:text>: </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="asis"/>
    </fo:block>
  </xsl:template>


  
  <xsl:template match="bjcp:specs">
    <xsl:text><![CDATA[<dt>]]>Eckdaten<![CDATA[</dt>]]></xsl:text>
    <xsl:text><![CDATA[<dd>]]></xsl:text>
    <xsl:choose>
      <xsl:when test="bjcp:ibu or bjcp:srm or bjcp:og or bjcp:fg or bjcp:abv">
	<xsl:text><![CDATA[<table>]]></xsl:text>
	<xsl:if test="bjcp:ibu">
	  <xsl:text><![CDATA[<tr><td>Bittere</td><td>]]></xsl:text>
	  <xsl:choose>
	    <xsl:when test="bjcp:ibu/@min">
	      <xsl:value-of select="bjcp:ibu/@min"/>
	      <xsl:text> - </xsl:text>
	      <xsl:value-of select="bjcp:ibu/@max"/>
	      <xsl:text> IBU</xsl:text>
	      <xsl:text><![CDATA[</td><td>]]></xsl:text>
	      <xsl:if test="bjcp:og/@min">
		<xsl:text>( </xsl:text>
		<xsl:value-of select="brew:bitterWort(bjcp:ibu/@min, bjcp:og/@max)"/>
		<xsl:text> - </xsl:text>
		<xsl:value-of select="brew:bitterWort(bjcp:ibu/@max, bjcp:og/@min)"/>
		<xsl:text> )</xsl:text>
	      </xsl:if>
	      <xsl:text><![CDATA[</td></tr>]]></xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:apply-templates select="bjcp:ibu/text()" mode="asis"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:if>
	<xsl:if test="bjcp:srm">
	  <xsl:text><![CDATA[<tr><td>Farbe</td><td>]]></xsl:text>
	  <xsl:choose>
	    <xsl:when test="bjcp:srm/@min">
	      <xsl:value-of select="format-number(brew:srmToEbc(bjcp:srm/@min),'0.0')"/>
	      <xsl:text> - </xsl:text>
	      <xsl:value-of select="format-number(brew:srmToEbc(bjcp:srm/@max),'0.0')"/>
	      <xsl:text> EBC</xsl:text>
	      <xsl:text><![CDATA[</td><td>]]></xsl:text>
	      <xsl:value-of select="bjcp:srm/@min"/>
	      <xsl:text> - </xsl:text>
	      <xsl:value-of select="bjcp:srm/@max"/>
	      <xsl:text> SRM</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:apply-templates select="bjcp:srm/text()" mode="asis"/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:text><![CDATA[</td></tr>]]></xsl:text>
	</xsl:if>
	<xsl:if test="bjcp:og">
	  <xsl:text><![CDATA[<tr><td>Stammwürze</td><td>]]></xsl:text>
	  <xsl:choose>
	    <xsl:when test="bjcp:og/@min">
	      <xsl:value-of select="format-number(brew:sgToPlato(bjcp:og/@min),'0.0')"/>
	      <xsl:text> - </xsl:text>
	      <xsl:value-of select="format-number(brew:sgToPlato(bjcp:og/@max),'0.0')"/>
	      <xsl:text> °P</xsl:text>
	      <xsl:text><![CDATA[</td><td>]]></xsl:text>
	      <xsl:text>OG </xsl:text>
	      <xsl:value-of select="bjcp:og/@min"/>
	      <xsl:text> - </xsl:text>
	      <xsl:value-of select="bjcp:og/@max"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:apply-templates select="bjcp:og/text()" mode="asis"/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:text><![CDATA[</td></tr>]]></xsl:text>
	</xsl:if>
	<xsl:if test="bjcp:fg">
	  <xsl:text><![CDATA[<tr><td>Restextrakt</td><td>]]></xsl:text>
	  <xsl:choose>
	    <xsl:when test="bjcp:fg/@min">
	      <xsl:value-of select="format-number(brew:sgToPlato(bjcp:fg/@min),'0.0')"/>
	      <xsl:text> - </xsl:text>
	      <xsl:value-of select="format-number(brew:sgToPlato(bjcp:fg/@max),'0.0')"/>
	      <xsl:text> GG%</xsl:text>
	      <xsl:text><![CDATA[</td><td>]]></xsl:text>
	      <xsl:text>FG </xsl:text>
	      <xsl:value-of select="bjcp:fg/@min"/>
	      <xsl:text> - </xsl:text>
	      <xsl:value-of select="bjcp:fg/@max"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:apply-templates select="bjcp:fg/text()" mode="asis"/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:text><![CDATA[</td></tr>]]></xsl:text>
	</xsl:if>
	<xsl:if test="bjcp:abv">
	  <xsl:text><![CDATA[<tr><td>Alkohol</td><td>]]></xsl:text>
	  <xsl:choose>
	    <xsl:when test="bjcp:abv/@min">
	      <xsl:value-of select="format-number(bjcp:abv/@min,'0.0')"/>
	      <xsl:text> - </xsl:text>
	      <xsl:value-of select="format-number(bjcp:abv/@max,'0.0')"/>
	      <xsl:text> %vol</xsl:text>
	      <xsl:text><![CDATA[</td><td>]]></xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:apply-templates select="bjcp:abv/text()" mode="asis"/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:text><![CDATA[</td></tr>]]></xsl:text>
	</xsl:if>
	<xsl:text><![CDATA[</table>]]></xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="text()" mode="asis"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text><![CDATA[</dd>]]></xsl:text>
  </xsl:template>


  
  <xsl:template match="*" mode="asis">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*" mode="asis"/>
      <xsl:apply-templates mode="asis"/>
    </xsl:element>
  </xsl:template>
  

    
  <xsl:template match="bjcp:p" mode="asis">
    <fo:block>
      <xsl:apply-templates mode="asis"/>
    </fo:block>
  </xsl:template>
  

    
  <xsl:template match="bjcp:b" mode="asis">
    <fo:inline font-weight="bold">
      <xsl:apply-templates mode="asis"/>
    </fo:inline>
  </xsl:template>
  

    
  <xsl:template match="bjcp:u" mode="asis">
    <fo:inline text-decoration="underline">
      <xsl:apply-templates mode="asis"/>
    </fo:inline>
  </xsl:template>
  

    
  <xsl:template match="bjcp:i" mode="asis">
    <fo:inline font-style="italic">
      <xsl:apply-templates mode="asis"/>
    </fo:inline>
  </xsl:template>
  

    
  <xsl:template match="@* | text()" mode="asis">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="asis"/>
      <xsl:apply-templates mode="asis"/>
    </xsl:copy>
  </xsl:template>
  


  <xsl:template match="bjcp:category | bjcp:subcategory">
    <fo:block page-break-before="always">

      <fo:block-container absolute-position="fixed" top="10mm" right="10mm" text-align="right">
	<fo:block>
	  <xsl:choose>
	    <xsl:when test="contains(@id,'-')">
	      <xsl:value-of select="substring-before(@id,'-')"/>
	      <xsl:text>*</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="@id"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</fo:block>
      </fo:block-container>
      <fo:block-container absolute-position="fixed" top="10mm" left="10mm">
	<fo:block>
	  <xsl:value-of select="bjcp:name"/>
	</fo:block>
      </fo:block-container>
      
      <fo:block-container absolute-position="fixed" top="30mm" left="10mm">
	
    <xsl:apply-templates select="bjcp:description" mode="section"/>
    
    <xsl:apply-templates select="bjcp:overall-impression" mode="section"/>
    <xsl:apply-templates select="bjcp:aroma" mode="section"/>
    <xsl:apply-templates select="bjcp:appearance" mode="section"/>
    <xsl:apply-templates select="bjcp:flavor" mode="section"/>
    <xsl:apply-templates select="bjcp:mouthfeel" mode="section"/>
    <xsl:apply-templates select="bjcp:comments" mode="section"/>
    <xsl:apply-templates select="bjcp:history" mode="section"/>
    <xsl:apply-templates select="bjcp:characteristic-ingredients" mode="section"/>
    <xsl:apply-templates select="bjcp:style-comparison" mode="section"/>
    <xsl:apply-templates select="bjcp:entry-instructions" mode="section"/>

    <xsl:apply-templates select="bjcp:strength-classifications" mode="section"/>
    
    <xsl:apply-templates select="bjcp:commercial-examples" mode="section"/>

    <xsl:apply-templates select="bjcp:specs"/>

    <xsl:apply-templates select="bjcp:tags" mode="section"/>

          </fo:block-container>

    </fo:block>
  </xsl:template>


  
</xsl:stylesheet>
