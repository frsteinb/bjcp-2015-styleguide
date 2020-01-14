<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:bjcp="http://heimbrauconvention.de/bjcp-styleguide/2015"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  xmlns:str="http://exslt.org/strings"
  xmlns:func="http://exslt.org/functions"
  xmlns:math="http://exslt.org/math"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:brew="http://frankensteiner.familie-steinberg.org/brew"
  extension-element-prefixes="exsl str func math date">



  <!-- TBD: Einige Teile dieser Datei sind nur für die deutsche Ausgabe vorbereitet. -->
  <xsl:param name="lang">orig</xsl:param>
  <xsl:param name="tableprefix">wp</xsl:param>
  <xsl:param name="userid">1</xsl:param>
  <xsl:param name="footer"><![CDATA[<p style="font-size: 70%;">Diese Informationen entstammen dem <a href="/stilrichtlinien">Übersetzungsprojekt</a> der <a href="http://dev.bjcp.org/beer-styles/introduction-to-the-2015-guidelines/">BJCP Style Guidelines</a>. Zuletzt aktualisiert: ]]><xsl:value-of select="$date"/><![CDATA[.</p>]]></xsl:param>

  

  <xsl:variable name="date"><xsl:value-of select="substring(date:date-time(),1,10)"/><xsl:text> </xsl:text><xsl:value-of select="substring(date:date-time(),12,5)"/></xsl:variable>
  <xsl:variable name="posttype">glossary</xsl:variable>
  <xsl:variable name="toppostname">bjcp-styleguide-2015</xsl:variable>
  <xsl:variable name="deletepattern"> auto-generated bjcp post </xsl:variable>



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



  <xsl:template name="footer">
    <xsl:value-of select="$footer"/>
  </xsl:template>


  
  <xsl:template match="/bjcp:styleguide">
    <exsl:document href="-" method="text" encoding="UTF-8"
                   omit-xml-declaration="yes">
      <xsl:text>DELETE FROM `</xsl:text><xsl:value-of select="$tableprefix"/><xsl:text>_posts` WHERE post_content LIKE '<![CDATA[<!--]]></xsl:text><xsl:value-of select="$deletepattern"/><xsl:text><![CDATA[-->]]>%';
</xsl:text>
      <xsl:call-template name="toppost"/>
      <xsl:apply-templates select="( //bjcp:category | //bjcp:subcategory | //bjcp:chapter )"/>
      <xsl:call-template name="tagposts"/>
    </exsl:document>
  </xsl:template>


  
  <xsl:template match="bjcp:subcategory/bjcp:subcategory" mode="classification">
    <xsl:variable name="postname">bjcp-<xsl:value-of select="translate(@id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/></xsl:variable>
    <xsl:apply-templates select=".." mode="classification">
      <xsl:with-param name="leaf">false</xsl:with-param>
    </xsl:apply-templates>
    <xsl:text>- - - </xsl:text>
    <xsl:text><![CDATA[<a href="]]></xsl:text>
    <xsl:value-of select="$postname"/>
    <xsl:text><![CDATA[">]]></xsl:text>
    <xsl:text>Alternative: </xsl:text>
    <xsl:value-of select="bjcp:name"/>
    <xsl:text><![CDATA[</a><br/>]]></xsl:text>
  </xsl:template>


  
  <xsl:template match="bjcp:category/bjcp:subcategory" mode="classification">
    <xsl:param name="leaf">true</xsl:param>
    <xsl:variable name="postname">bjcp-<xsl:value-of select="translate(@id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/></xsl:variable>
    <xsl:apply-templates select=".." mode="classification">
      <xsl:with-param name="leaf">false</xsl:with-param>
    </xsl:apply-templates>
    <xsl:text>- - </xsl:text>
    <xsl:text><![CDATA[<a href="]]></xsl:text>
    <xsl:value-of select="$postname"/>
    <xsl:text><![CDATA[">]]></xsl:text>
    <xsl:text>Unterkategorie </xsl:text>
    <xsl:choose>
      <xsl:when test="contains(@id,'-')">
	<xsl:value-of select="substring-before(@id,'-')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="bjcp:name"/>
    <xsl:text><![CDATA[</a><br/>]]></xsl:text>
    <xsl:if test="$leaf = 'true' and bjcp:subcategory">
      <xsl:text><![CDATA[</dt><dt>Alternativen</dt><dd>]]></xsl:text>
      <xsl:for-each select="bjcp:subcategory">
	<xsl:variable name="postname2">bjcp-<xsl:value-of select="translate(@id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/></xsl:variable>
	<xsl:text><![CDATA[- - - <a href="]]></xsl:text>
	<xsl:value-of select="$postname2"/>
	<xsl:text><![CDATA[">]]></xsl:text>
	<xsl:choose>
	  <xsl:when test="contains(@id,'-')">
	    <xsl:value-of select="substring-before(@id,'-')"/>
	    <xsl:text>*</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@id"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:text>: </xsl:text>
	<xsl:value-of select="bjcp:name"/>
	<xsl:text><![CDATA[</a><br/>]]></xsl:text>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  
  <xsl:template match="bjcp:category" mode="classification">
    <xsl:param name="leaf">true</xsl:param>
    <xsl:variable name="postname">bjcp-<xsl:value-of select="translate(@id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/></xsl:variable>
    <xsl:text><![CDATA[<a href="]]></xsl:text>
    <xsl:value-of select="$toppostname"/>
    <xsl:text><![CDATA[">]]></xsl:text>
    <xsl:value-of select="$topposttitle"/>
    <xsl:text><![CDATA[</a><br/>]]></xsl:text>
    <xsl:text>- </xsl:text>
    <xsl:text><![CDATA[<a href="]]></xsl:text>
    <xsl:value-of select="$postname"/>
    <xsl:text><![CDATA[">]]></xsl:text>
    <xsl:text>Kategorie </xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="bjcp:name"/>
    <xsl:text><![CDATA[</a><br/>]]></xsl:text>
    <xsl:if test="$leaf = 'true'">
      <xsl:text><![CDATA[</dt><dt>Unterkategorien</dt><dd>]]></xsl:text>
      <xsl:for-each select="bjcp:subcategory">
	<xsl:variable name="postname2">bjcp-<xsl:value-of select="translate(@id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/></xsl:variable>
	<xsl:text><![CDATA[- - <a href="]]></xsl:text>
	<xsl:value-of select="$postname2"/>
	<xsl:text><![CDATA[">]]></xsl:text>
	<xsl:choose>
	  <xsl:when test="contains(@id,'-')">
	    <xsl:value-of select="substring-before(@id,'-')"/>
	    <xsl:text>*</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@id"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:text>: </xsl:text>
	<xsl:value-of select="bjcp:name"/>
	<xsl:text><![CDATA[</a><br/>]]></xsl:text>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  
  <xsl:template match="*" mode="section">
    <xsl:text><![CDATA[<dt>]]></xsl:text>
    <xsl:choose>
      <xsl:when test="local-name(.) = 'description'">Beschreibung</xsl:when>
      <xsl:when test="local-name(.) = 'overall-impression'">Gesamteindruck</xsl:when>
      <xsl:when test="local-name(.) = 'appearance'">Erscheinungsbild</xsl:when>
      <xsl:when test="local-name(.) = 'aroma'">Geruch</xsl:when>
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
    <xsl:text><![CDATA[</dt>]]></xsl:text>
    <xsl:text><![CDATA[<dd>]]></xsl:text>
    <xsl:apply-templates mode="asis"/>
    <xsl:text><![CDATA[</dd>]]></xsl:text>
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
		<xsl:text>(</xsl:text>
		<xsl:value-of select="brew:bitterWort(bjcp:ibu/@min, bjcp:og/@max)"/>
		<xsl:text> - </xsl:text>
		<xsl:value-of select="brew:bitterWort(bjcp:ibu/@max, bjcp:og/@min)"/>
		<xsl:text>)</xsl:text>
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
    <xsl:text><![CDATA[<]]></xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:apply-templates select="@*" mode="asis"/>
    <xsl:text><![CDATA[>]]></xsl:text>
    <xsl:apply-templates select="* | text()" mode="asis"/>
    <xsl:text><![CDATA[</]]></xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:text><![CDATA[>]]></xsl:text>
  </xsl:template>



  <xsl:template match="bjcp:div[contains(@class,'table')]" mode="asis">
    <xsl:variable name="elem">
      <xsl:choose>
	<xsl:when test="@class='table'">table</xsl:when>
	<xsl:when test="@class='table-row'">tr</xsl:when>
	<xsl:when test="@class='table-cell'">td</xsl:when>
	<xsl:when test="@class='table-head'">tr</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:text><![CDATA[<]]></xsl:text>
    <xsl:value-of select="$elem"/>
    <xsl:if test="@class='table-head'">
      <xsl:text><![CDATA[><td colspan="2" style="font-weight:bold"]]></xsl:text>
    </xsl:if>
    <xsl:text><![CDATA[>]]></xsl:text>
    <xsl:apply-templates select="* | text()" mode="asis"/>
    <xsl:text><![CDATA[</]]></xsl:text>
    <xsl:if test="@class='table-head'">
      <xsl:text><![CDATA[td><]]></xsl:text>
    </xsl:if>
    <xsl:value-of select="$elem"/>
    <xsl:text><![CDATA[>]]></xsl:text>
  </xsl:template>



  <xsl:template match="bjcp:tag" mode="asis">
    <xsl:text><![CDATA[<a href="]]></xsl:text>
    <xsl:text>bjcp-</xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:text><![CDATA[">]]></xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:text><![CDATA[</a><br/>]]></xsl:text>
  </xsl:template>



  <xsl:template match="bjcp:a" mode="asis">
    <xsl:text><![CDATA[<]]></xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:apply-templates select="@*" mode="asis"/>
    <xsl:text><![CDATA[>]]></xsl:text>
    <xsl:apply-templates select="* | text()" mode="asis"/>
    <xsl:if test="string-length(text()) = 0">
      <xsl:variable name="i">
	<xsl:value-of select="substring-after(@href, '#')"/>
      </xsl:variable>
      <xsl:value-of select="//bjcp:subcategory[@id = $i]/bjcp:name"/>
    </xsl:if>
    <xsl:text><![CDATA[</]]></xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:text><![CDATA[>]]></xsl:text>
  </xsl:template>



  <xsl:template match="@*" mode="asis">
    <xsl:text><![CDATA[ ]]></xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:text><![CDATA[=\']]></xsl:text>
    <xsl:choose>
      <xsl:when test="substring(.,1,1) = '#'">
	<xsl:text>bjcp-</xsl:text>
	<xsl:value-of select="translate(substring(.,2),'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text><![CDATA[\']]></xsl:text>
  </xsl:template>


  
  <xsl:template match="text()" mode="asis">
    <xsl:variable name="tmp">
      <xsl:call-template name="subst">
	<xsl:with-param name="text" select="."/>
	<xsl:with-param name="replace">&lt;</xsl:with-param>
	<xsl:with-param name="with">&amp;lt;</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="subst">
      <xsl:with-param name="text" select="$tmp"/>
      <xsl:with-param name="replace">'</xsl:with-param>
      <xsl:with-param name="with">\'</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
  <xsl:template match="bjcp:category | bjcp:subcategory">
    <xsl:variable name="id">
      <xsl:choose>
	<xsl:when test="@type">
	  <xsl:value-of select="@type"/>
	</xsl:when>
	<xsl:when test="@id">
	  <xsl:value-of select="@id"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="bjcp:name"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:choose>
	<xsl:when test="@type">
          <xsl:value-of select="translate(substring(@type,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
          <xsl:value-of select="substring(@type,2)"/>
	</xsl:when>
	<xsl:otherwise>
          <xsl:value-of select="bjcp:name"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="postname">bjcp-<xsl:value-of select="translate($id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/></xsl:variable>
    <xsl:text>INSERT INTO `</xsl:text><xsl:value-of select="$tableprefix"/><xsl:text>_posts` (post_author,post_date,post_date_gmt,post_content,post_title,post_excerpt,comment_status,ping_status,post_name,to_ping,pinged,post_modified,post_modified_gmt,post_content_filtered,post_type) VALUES (</xsl:text><xsl:value-of select="$userid"/><xsl:text>,NOW(),NOW(),'<![CDATA[<!--]]></xsl:text><xsl:value-of select="$deletepattern"/><xsl:text><![CDATA[-->]]></xsl:text>

    <xsl:text><![CDATA[<dt>Klassifizierung</dt><dd>]]></xsl:text>
    <xsl:apply-templates select="." mode="classification"/>
    <xsl:text><![CDATA[</dd>]]></xsl:text>

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

    <xsl:call-template name="footer"/>

    <xsl:text>','</xsl:text>
    <xsl:choose>
      <xsl:when test="contains(@id,'-')">
	<xsl:value-of select="substring-before(@id,'-')"/>
	<xsl:text>*</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="$title"/>
    <xsl:text>','','closed','closed','</xsl:text>
    <xsl:value-of select="$postname"/>
    <xsl:text>','','',NOW(),NOW(),'','</xsl:text>
    <xsl:value-of select="$posttype"/>
    <xsl:text>');
</xsl:text>
  </xsl:template>


  
  <xsl:template match="bjcp:chapter">
    <xsl:variable name="id">
      <xsl:value-of select="@id"/>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:value-of select="bjcp:h2"/>
    </xsl:variable>
    <xsl:variable name="postname">bjcp-<xsl:value-of select="translate($id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/></xsl:variable>
    <xsl:text>INSERT INTO `</xsl:text><xsl:value-of select="$tableprefix"/><xsl:text>_posts` (post_author,post_date,post_date_gmt,post_content,post_title,post_excerpt,comment_status,ping_status,post_name,to_ping,pinged,post_modified,post_modified_gmt,post_content_filtered,post_type) VALUES (</xsl:text><xsl:value-of select="$userid"/><xsl:text>,NOW(),NOW(),'<![CDATA[<!--]]></xsl:text><xsl:value-of select="$deletepattern"/><xsl:text><![CDATA[-->]]></xsl:text>

    <xsl:apply-templates mode="asis"/>
    
    <xsl:call-template name="footer"/>

    <xsl:text>','</xsl:text>
    <xsl:value-of select="$title"/>
    <xsl:text>','','closed','closed','</xsl:text>
    <xsl:value-of select="$postname"/>
    <xsl:text>','','',NOW(),NOW(),'','</xsl:text>
    <xsl:value-of select="$posttype"/>
    <xsl:text>');
</xsl:text>
  </xsl:template>


  
  <xsl:template name="toppost">
    <xsl:text>INSERT INTO `</xsl:text><xsl:value-of select="$tableprefix"/><xsl:text>_posts` (post_author,post_date,post_date_gmt,post_content,post_title,post_excerpt,comment_status,ping_status,post_name,to_ping,pinged,post_modified,post_modified_gmt,post_content_filtered,post_type) VALUES (</xsl:text><xsl:value-of select="$userid"/><xsl:text>,NOW(),NOW(),'<![CDATA[<!--]]></xsl:text><xsl:value-of select="$deletepattern"/><xsl:text><![CDATA[-->]]></xsl:text>

    <xsl:for-each select="( //bjcp:category | //bjcp:chapter )">
      <xsl:variable name="postname">bjcp-<xsl:value-of select="translate(@id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/></xsl:variable>
      <xsl:text><![CDATA[<a href="]]></xsl:text>
      <xsl:value-of select="$postname"/>
      <xsl:text><![CDATA[">]]></xsl:text>
      <xsl:choose>
	<xsl:when test="local-name(.) = 'chapter'">
	  <xsl:value-of select="bjcp:h2"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@id"/>
	  <xsl:text>: </xsl:text>
	  <xsl:value-of select="bjcp:name"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text><![CDATA[</a><br/>]]></xsl:text>
    </xsl:for-each>
  
    <xsl:call-template name="footer"/>

    <xsl:text>','</xsl:text>
    <xsl:value-of select="$topposttitle"/>
    <xsl:text>','','closed','closed','</xsl:text>
    <xsl:value-of select="$toppostname"/>
    <xsl:text>','','',NOW(),NOW(),'','</xsl:text>
    <xsl:value-of select="$posttype"/>
    <xsl:text>');
</xsl:text>
  </xsl:template>


  
  <xsl:template name="tagposts">

    <xsl:for-each select="//bjcp:tag[not(./text()=preceding::bjcp:tag/text())]">
      <xsl:variable name="tag">
	<xsl:value-of select="text()"/>
      </xsl:variable>
      <xsl:text>INSERT INTO `</xsl:text><xsl:value-of select="$tableprefix"/><xsl:text>_posts` (post_author,post_date,post_date_gmt,post_content,post_title,post_excerpt,comment_status,ping_status,post_name,to_ping,pinged,post_modified,post_modified_gmt,post_content_filtered,post_type) VALUES (</xsl:text><xsl:value-of select="$userid"/><xsl:text>,NOW(),NOW(),'<![CDATA[<!--]]></xsl:text><xsl:value-of select="$deletepattern"/><xsl:text><![CDATA[-->]]></xsl:text>

      <xsl:text><![CDATA[<p>]]></xsl:text>
      <xsl:for-each select="//bjcp:div[@class='table']/bjcp:div[@class='table-row'][bjcp:div[@class='table-cell'] = $tag]">
	<xsl:value-of select="preceding::bjcp:div[@class='table-head'][1]/text()"/>
	<xsl:text>: </xsl:text>
	<xsl:value-of select="bjcp:div[@class='table-cell'][2]/text()"/>
      </xsl:for-each>
      <xsl:text><![CDATA[</p>]]></xsl:text>
      
      <xsl:for-each select="//bjcp:subcategory[bjcp:tags/bjcp:tag/text() = $tag]">
	<xsl:variable name="postname">bjcp-<xsl:value-of select="translate(@id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/></xsl:variable>
	<xsl:text><![CDATA[<a href="]]></xsl:text>
	<xsl:value-of select="$postname"/>
	<xsl:text><![CDATA[">]]></xsl:text>
	<xsl:choose>
	  <xsl:when test="contains(@id,'-')">
	    <xsl:value-of select="substring-before(@id,'-')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@id"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:text>: </xsl:text>
	<xsl:value-of select="bjcp:name"/>
	<xsl:text></xsl:text>
	<xsl:text><![CDATA[</a><br/>]]></xsl:text>
      </xsl:for-each>
      
      <xsl:call-template name="footer"/>
      
      <xsl:text>','</xsl:text><xsl:value-of select="$tagtitleprefix"/><xsl:text> "</xsl:text>
      <xsl:value-of select="$tag"/>
      <xsl:text>"','','closed','closed','bjcp-</xsl:text>
      <xsl:value-of select="$tag"/>
      <xsl:text>','','',NOW(),NOW(),'','</xsl:text>
      <xsl:value-of select="$posttype"/>
      <xsl:text>');
</xsl:text>

    </xsl:for-each>
    
  </xsl:template>


  
</xsl:stylesheet>
