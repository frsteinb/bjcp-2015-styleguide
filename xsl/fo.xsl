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
  xmlns:dyn="http://exslt.org/dynamic"
  xmlns:brew="http://frankensteiner.familie-steinberg.org/brew"
  extension-element-prefixes="exsl str func math date dyn">



  <xsl:param name="lang">orig</xsl:param>



  <xsl:include href="../cache/config-current.xsl"/>
  
  

  <xsl:template name="subst">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="string-length($replace) = 0">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="contains($text, $replace)">
        <xsl:variable name="before" select="substring-before($text, $replace)"/>
        <xsl:variable name="after" select="substring-after($text, $replace)"/>
        <xsl:value-of select="$before"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="subst">
          <xsl:with-param name="text" select="$after"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when> 
      <xsl:otherwise>
        <xsl:value-of select="$text"/>  
      </xsl:otherwise>
    </xsl:choose>            
  </xsl:template>



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
        <xsl:when test="local-name(.) = 'description'"></xsl:when>
        <xsl:when test="local-name(.) = 'overall-impression'"><xsl:value-of select="$overall-impression"/></xsl:when>
        <xsl:when test="local-name(.) = 'aroma'"><xsl:value-of select="$aroma"/></xsl:when>
        <xsl:when test="local-name(.) = 'appearance'"><xsl:value-of select="$appearance"/></xsl:when>
        <xsl:when test="local-name(.) = 'flavor'"><xsl:value-of select="$flavor"/></xsl:when>
        <xsl:when test="local-name(.) = 'mouthfeel'"><xsl:value-of select="$mouthfeel"/></xsl:when>
        <xsl:when test="local-name(.) = 'comments'"><xsl:value-of select="$comments"/></xsl:when>
        <xsl:when test="local-name(.) = 'history'"><xsl:value-of select="$history"/></xsl:when>
        <xsl:when test="local-name(.) = 'characteristic-ingredients'"><xsl:value-of select="$characteristic-ingredients"/></xsl:when>
        <xsl:when test="local-name(.) = 'style-comparison'"><xsl:value-of select="$style-comparison"/></xsl:when>
        <xsl:when test="local-name(.) = 'entry-instructions'"><xsl:value-of select="$entry-instructions"/></xsl:when>
        <xsl:when test="local-name(.) = 'commercial-examples'"><xsl:value-of select="$commercial-examples"/></xsl:when>
        <xsl:when test="local-name(.) = 'specs'"><xsl:value-of select="$specs"/></xsl:when>
        <xsl:when test="local-name(.) = 'tags'"><xsl:value-of select="$tags"/></xsl:when>
        <xsl:when test="local-name(.) = 'strength-classifications'"><xsl:value-of select="$strength-classifications"/></xsl:when>
      </xsl:choose>
    </xsl:variable>
    <fo:block space-after="1em">
      <xsl:if test="string-length($label) > 0">
	<fo:inline font-weight="bold">
	  <xsl:value-of select="$label"/>
	</fo:inline>
	<xsl:text>: </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="asis"/>
    </fo:block>
  </xsl:template>


  
  <xsl:template match="bjcp:specs">
    <fo:block-container absolute-position="fixed" top="30mm" right="10mm" width="90mm" height="50mm" border="0.1mm solid black" font-family="Times">
	<xsl:choose>
	  <xsl:when test="bjcp:ibu or bjcp:srm or bjcp:og or bjcp:fg or bjcp:abv">

	    <xsl:variable name="pos">
	      <xsl:choose>
		<xsl:when test="$eurounits">25mm</xsl:when>
		<xsl:otherwise>40mm</xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>
	    <xsl:if test="bjcp:ibu">
	      <fo:block-container absolute-position="absolute" top="0mm" left="0mm" width="20mm" height="10mm">
		<fo:block margin-left="2mm" margin-top="3mm"><xsl:value-of select="$ibutitle"/></fo:block>
	      </fo:block-container>
	      <xsl:choose>
		<xsl:when test="bjcp:ibu/@min">
		  <fo:block-container absolute-position="absolute" top="0mm" left="{$pos}" width="35mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:value-of select="bjcp:ibu/@min"/>
		      <xsl:text> - </xsl:text>
		      <xsl:value-of select="bjcp:ibu/@max"/>
		      <xsl:text> IBU</xsl:text>
		    </fo:block>
		  </fo:block-container>
		  <xsl:if test="$bitterword and bjcp:og/@min">
		    <fo:block-container absolute-position="absolute" top="0mm" left="50mm" width="40mm" height="10mm">
		      <fo:block margin-top="3mm">
			<xsl:text>(</xsl:text>
			<xsl:value-of select="brew:bitterWort(bjcp:ibu/@min, bjcp:og/@max)"/>
			<xsl:if test="brew:bitterWort(bjcp:ibu/@min, bjcp:og/@max) != brew:bitterWort(bjcp:ibu/@max, bjcp:og/@min)">
			  <xsl:text> - </xsl:text>
			  <xsl:value-of select="brew:bitterWort(bjcp:ibu/@max, bjcp:og/@min)"/>
			</xsl:if>
			<xsl:text>)</xsl:text>
		      </fo:block>
		    </fo:block-container>
		  </xsl:if>
		</xsl:when>
		<xsl:otherwise>
		  <fo:block-container absolute-position="absolute" top="0mm" left="{$pos}" width="70mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:apply-templates select="bjcp:ibu/text()" mode="asis"/>
		    </fo:block>
		  </fo:block-container>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:if>
	    <xsl:if test="bjcp:srm">
	      <fo:block-container absolute-position="absolute" top="10mm" left="0mm" width="20mm" height="10mm">
		<fo:block margin-left="2mm" margin-top="3mm"><xsl:value-of select="$srmtitle"/></fo:block>
	      </fo:block-container>
	      <xsl:choose>
		<xsl:when test="bjcp:srm/@min">
		  <fo:block-container absolute-position="absolute" top="10mm" left="{$pos}" width="35mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:value-of select="bjcp:srm/@min"/>
		      <xsl:text> - </xsl:text>
		      <xsl:value-of select="bjcp:srm/@max"/>
		      <xsl:text> SRM</xsl:text>
		    </fo:block>
		  </fo:block-container>
		  <xsl:if test="$eurounits and bjcp:og/@min">
		    <fo:block-container absolute-position="absolute" top="10mm" left="50mm" width="40mm" height="10mm">
		      <fo:block margin-top="3mm">
			<xsl:value-of select="format-number(brew:srmToEbc(bjcp:srm/@min),'0.0')"/>
			<xsl:text> - </xsl:text>
			<xsl:value-of select="format-number(brew:srmToEbc(bjcp:srm/@max),'0.0')"/>
			<xsl:text> EBC</xsl:text>
		      </fo:block>
		    </fo:block-container>
		  </xsl:if>
		</xsl:when>
		<xsl:otherwise>
		  <fo:block-container absolute-position="absolute" top="10mm" left="{$pos}" width="70mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:apply-templates select="bjcp:srm/text()" mode="asis"/>
		    </fo:block>
		  </fo:block-container>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:if>
	    <xsl:if test="bjcp:og">
	      <fo:block-container absolute-position="absolute" top="20mm" left="0mm" width="20mm" height="10mm">
		<fo:block margin-left="2mm" margin-top="3mm"><xsl:value-of select="$ogtitle"/></fo:block>
	      </fo:block-container>
	      <xsl:choose>
		<xsl:when test="bjcp:og/@min">
		  <fo:block-container absolute-position="absolute" top="20mm" left="{$pos}" width="35mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:if test="$eurounits or substring($ogtitle,1,1)!='O'">
			<xsl:text>OG </xsl:text>
		      </xsl:if>
		      <xsl:value-of select="bjcp:og/@min"/>
		      <xsl:text> - </xsl:text>
		      <xsl:value-of select="bjcp:og/@max"/>
		    </fo:block>
		  </fo:block-container>
		  <xsl:if test="$eurounits">
		    <fo:block-container absolute-position="absolute" top="20mm" left="50mm" width="40mm" height="10mm">
		      <fo:block margin-top="3mm">
			<xsl:value-of select="format-number(brew:sgToPlato(bjcp:og/@min),'0.0')"/>
			<xsl:text> - </xsl:text>
			<xsl:value-of select="format-number(brew:sgToPlato(bjcp:og/@max),'0.0')"/>
			<xsl:text> °P</xsl:text>
		      </fo:block>
		    </fo:block-container>
		  </xsl:if>
		</xsl:when>
		<xsl:otherwise>
		  <fo:block-container absolute-position="absolute" top="20mm" left="{$pos}" width="70mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:apply-templates select="bjcp:og/text()" mode="asis"/>
		    </fo:block>
		  </fo:block-container>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:if>
	    <xsl:if test="bjcp:fg">
	      <fo:block-container absolute-position="absolute" top="30mm" left="0mm" width="20mm" height="10mm">
		<fo:block margin-left="2mm" margin-top="3mm"><xsl:value-of select="$fgtitle"/></fo:block>
	      </fo:block-container>
	      <xsl:choose>
		<xsl:when test="bjcp:fg/@min">
		  <fo:block-container absolute-position="absolute" top="30mm" left="{$pos}" width="35mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:if test="$eurounits or substring($fgtitle,1,1)!='F'">
			<xsl:text>FG </xsl:text>
		      </xsl:if>
		      <xsl:value-of select="bjcp:fg/@min"/>
		      <xsl:text> - </xsl:text>
		      <xsl:value-of select="bjcp:fg/@max"/>
		    </fo:block>
		  </fo:block-container>
		  <xsl:if test="$eurounits">
		    <fo:block-container absolute-position="absolute" top="30mm" left="50mm" width="40mm" height="10mm">
		      <fo:block margin-top="3mm">
			<xsl:value-of select="format-number(brew:sgToPlato(bjcp:fg/@min),'0.0')"/>
			<xsl:text> - </xsl:text>
			<xsl:value-of select="format-number(brew:sgToPlato(bjcp:fg/@max),'0.0')"/>
			<xsl:text> GG%</xsl:text>
		      </fo:block>
		    </fo:block-container>
		  </xsl:if>
		</xsl:when>
		<xsl:otherwise>
		  <fo:block-container absolute-position="absolute" top="30mm" left="{$pos}" width="70mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:apply-templates select="bjcp:fg/text()" mode="asis"/>
		    </fo:block>
		  </fo:block-container>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:if>
	    <xsl:if test="bjcp:abv">
	      <fo:block-container absolute-position="absolute" top="40mm" left="0mm" width="20mm" height="10mm">
		<fo:block margin-left="2mm" margin-top="3mm"><xsl:value-of select="$abvtitle"/></fo:block>
	      </fo:block-container>
	      <xsl:choose>
		<xsl:when test="bjcp:abv/@min">
		  <fo:block-container absolute-position="absolute" top="40mm" left="{$pos}" width="35mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:value-of select="format-number(bjcp:abv/@min,'0.0')"/>
		      <xsl:text> - </xsl:text>
		      <xsl:value-of select="format-number(bjcp:abv/@max,'0.0')"/>
		      <xsl:text> %vol</xsl:text>
		    </fo:block>
		  </fo:block-container>
		</xsl:when>
		<xsl:otherwise>
		  <fo:block-container absolute-position="absolute" top="40mm" left="{$pos}" width="70mm" height="10mm">
		    <fo:block margin-top="3mm">
		      <xsl:apply-templates select="bjcp:abv/text()" mode="asis"/>
		    </fo:block>
		  </fo:block-container>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:if>
	  </xsl:when>
	  <xsl:otherwise>
	    <fo:block-container absolute-position="absolute" top="10mm" left="0mm">
	      <fo:block text-align="center">
		<xsl:apply-templates select="text()" mode="asis"/>
	      </fo:block>
	    </fo:block-container>
	  </xsl:otherwise>
	</xsl:choose>
    </fo:block-container>
  </xsl:template>


  
  <xsl:template match="*" mode="asis">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*" mode="asis"/>
      <xsl:apply-templates mode="asis"/>
    </xsl:element>
  </xsl:template>
  

    
  <xsl:template match="bjcp:tag" mode="asis">
    <xsl:value-of select="text()"/>
  </xsl:template>



  <xsl:template match="bjcp:strength" mode="asis">
    <fo:block>
      <xsl:value-of select="text()"/>
    </fo:block>
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
  


  <xsl:template match="bjcp:subcategory" mode="list">
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
      <xsl:text> </xsl:text>
      <xsl:value-of select="bjcp:name"/>
    </fo:block>
  </xsl:template>


  
  <xsl:template match="bjcp:category | bjcp:subcategory">

    <fo:block page-break-before="always" font-family="Times" font-size="8pt">

      <fo:block-container absolute-position="fixed" top="10mm" right="10mm" text-align="right">
	<fo:block font-size="36pt" font-weight="bold">
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
	<fo:block font-size="24pt">
	  <xsl:if test="local-name(.) = 'category'">
	    <xsl:value-of select="$category"/><xsl:text>: </xsl:text>
	  </xsl:if>
	  <xsl:value-of select="bjcp:name"/>
	</fo:block>
	<xsl:if test="../bjcp:name">
	  <fo:block font-size="12pt">
	    <xsl:if test="../../bjcp:name">
	      <xsl:value-of select="../../bjcp:name"/>
	      <xsl:text> – </xsl:text>
	    </xsl:if>
	    <xsl:value-of select="../bjcp:name"/>
	  </fo:block>
	</xsl:if>
      </fo:block-container>
      
      <xsl:apply-templates select="bjcp:specs"/>

      <fo:block-container absolute-position="fixed" top="30mm" left="10mm" width="92mm" bottom="10mm">
	<xsl:apply-templates select="bjcp:description" mode="section"/>
	<xsl:apply-templates select="bjcp:overall-impression" mode="section"/>
	<xsl:apply-templates select="bjcp:appearance" mode="section"/>
	<xsl:apply-templates select="bjcp:aroma" mode="section"/>
	<xsl:apply-templates select="bjcp:flavor" mode="section"/>
	<xsl:apply-templates select="bjcp:mouthfeel" mode="section"/>
      </fo:block-container>
      <fo:block-container absolute-position="fixed" top="85mm" right="10mm" width="92mm" bottom="10mm">
	<xsl:if test="bjcp:subcategory">
	  <fo:block space-after="1em">
	    <fo:inline font-weight="bold">
	      <xsl:value-of select="$subcategories"/>
	    </fo:inline>
	    <xsl:text>: </xsl:text>
	  </fo:block>
	  <fo:block space-after="1em">
	    <xsl:apply-templates select="bjcp:subcategory" mode="list"/>
	  </fo:block>
	</xsl:if>
	<xsl:apply-templates select="bjcp:comments" mode="section"/>
	<xsl:apply-templates select="bjcp:history" mode="section"/>
	<xsl:apply-templates select="bjcp:characteristic-ingredients" mode="section"/>
	<xsl:apply-templates select="bjcp:style-comparison" mode="section"/>
	<xsl:apply-templates select="bjcp:entry-instructions" mode="section"/>
	<xsl:apply-templates select="bjcp:strength-classifications" mode="section"/>
	<xsl:apply-templates select="bjcp:commercial-examples" mode="section"/>
	<xsl:apply-templates select="bjcp:tags" mode="section"/>
      </fo:block-container>
      
    </fo:block>

  </xsl:template>


  
</xsl:stylesheet>
