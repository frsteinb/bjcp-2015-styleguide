<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns="http://heimbrauconvention.de/bjcp-styleguide/2015"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    xmlns:math="http://exslt.org/math"
    xmlns:dyn="http://exslt.org/dynamic"
    xmlns:func="http://exslt.org/functions"
    xmlns:b="http://frankensteiner.familie-steinberg.org/bjcp-tools"
    extension-element-prefixes="exsl str math dyn func">



  <xsl:variable name="add-de"></xsl:variable>



  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



  <func:function name="b:srmToEbc">
    <xsl:param name="in"/>
    <!--<func:result select="round($in div 0.508 * 10) div 10"/>-->
    <func:result select="round($in div 0.508)"/>
  </func:function>



  <func:function name="b:sgToPlato">
    <xsl:param name="in"/>
    <!-- https://www.brewersfriend.com/plato-to-sg-conversion-chart/ -->
    <func:result select="round(((-1 * 616.868) + (1111.14 * $in) - (630.272 * math:power($in,2)) + (135.997 * math:power($in,3))) * 10) div 10"/>
  </func:function>



  <xsl:template match="/w:document">
    <xsl:element name="styleguide">
      <!-- TBD: title page -->
      <!-- TBD: toc? -->
      <xsl:apply-templates select=".//w:p[w:pPr/w:pStyle/@w:val='Heading1' and w:r/w:t]" mode="chapter"/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="w:p" mode="chapter">
    <xsl:variable name="s">
      <xsl:for-each select="w:r/w:t">
        <xsl:value-of select="text()"/>
      </xsl:for-each>
    </xsl:variable> 
    <xsl:variable name="title">
      <xsl:value-of select="normalize-space($s)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="substring($title,1,1) > 0">
        <xsl:call-template name="category">
          <xsl:with-param name="title">
            <xsl:value-of select="$title"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="chapter">
          <xsl:with-param name="title">
            <xsl:value-of select="$title"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="chapter">
    <xsl:param name="title"/>
    <xsl:element name="chapter">
      <xsl:attribute name="id">
	<xsl:value-of select="translate($title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ :','abcdefghijklmnopqrstuvwxyz-')"/>
      </xsl:attribute>
      <xsl:element name="h2">
	<xsl:value-of select="$title"/>
      </xsl:element>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-chapter"/>
    </xsl:element>
  </xsl:template>



  <xsl:template name="category">
    <xsl:param name="title"/>
    <xsl:element name="category">
      <xsl:attribute name="id">
        <xsl:value-of select="substring-before($title,'. ')"/>
      </xsl:attribute>
      <xsl:element name="name">
        <xsl:value-of select="substring-after($title,'. ')"/>
      </xsl:element>
      <xsl:if test="add-de">
        <xsl:element name="name">
          <xsl:attribute name="lang">de</xsl:attribute>
          <!-- translation to be entered here --><xsl:text> </xsl:text>
        </xsl:element>
      </xsl:if>

      <xsl:call-template name="style-intro"/>

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Entry Instructions</xsl:with-param>
      </xsl:apply-templates>

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-category"/>

        <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-subcategory">
          <xsl:with-param name="id">
            <xsl:value-of select="substring-before($title,'. ')"/>
          </xsl:with-param>
        </xsl:apply-templates>

    </xsl:element>
  </xsl:template>



  <xsl:template name="subcategory">
    <xsl:param name="id"/>
    <xsl:param name="title"/>
    <xsl:variable name="id0">
      <xsl:choose>
	<xsl:when test="contains($title,'.')">
	  <xsl:value-of select="substring-before($title,'. ')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$id"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="subcategory">
      <xsl:attribute name="id">
	<xsl:value-of select="$id0"/>
      </xsl:attribute>
      <xsl:element name="name">
        <xsl:choose>
          <xsl:when test="contains($title,'.')">
            <xsl:value-of select="substring-after($title,'. ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$title"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:if test="add-de">
        <xsl:element name="name">
          <xsl:attribute name="lang">de</xsl:attribute>
          <!-- translation to be entered here --><xsl:text> </xsl:text>
        </xsl:element>
      </xsl:if>

      <xsl:call-template name="style-intro"/>

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Overall Impression</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Aroma</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Appearance</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Flavor</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Mouthfeel</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Comments</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">History</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Characteristic Ingredients</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Style Comparison</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Commercial Examples</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Entry Instructions</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>

      <!--
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Currently Defined Types</xsl:with-param>
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>
      -->
      <!-- TODO: Currently Defined Types sollte implizit klar sein. -->

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="tags">
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="specs">
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="strengths">
        <xsl:with-param name="id"><xsl:value-of select="$id0"/></xsl:with-param>
      </xsl:apply-templates>

      <xsl:if test="not($id)">
        <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-subcategory">
          <xsl:with-param name="id">
            <xsl:value-of select="substring-before($title,'. ')"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:if>

    </xsl:element>

  </xsl:template>



  <xsl:template match="w:p" mode="attribute">
    <xsl:param name="attribute"/>
    <xsl:param name="id"/>
    <xsl:variable name="n">
      <xsl:value-of select="translate($attribute,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/>
    </xsl:variable>
    <xsl:variable name="p">
      <xsl:text>document('../fix/</xsl:text>
      <xsl:value-of select="$id"/>
      <xsl:text>.xml')/styleguide//*[@id='</xsl:text>
      <xsl:value-of select="$id"/>
      <xsl:text>']/</xsl:text>
      <xsl:value-of select="$n"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="(string-length($id) > 0) and (string-length(dyn:evaluate($p)/text()) > 0)">
	<xsl:apply-templates select="dyn:evaluate($p)" mode="copy"/>
	<xsl:if test="add-de">
	  <xsl:element name="{$n}">
	    <xsl:attribute name="lang">de</xsl:attribute>
	    <!-- translation to be entered here --><xsl:text> </xsl:text>
	  </xsl:element>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1') and not(w:pPr/w:pStyle/@w:val='Heading2') and not(w:pPr/w:pStyle/@w:val='Heading2first') and not(w:pPr/w:pStyle/@w:val='Heading3') and not(w:pPr/w:pStyle/@w:val='TOC2')">
          <xsl:if test="translate(substring(w:r/w:t,1,string-length($attribute)),'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-') = translate($attribute,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')">
            <xsl:element name="{$n}">
              <xsl:apply-templates select="w:r[position() >= 2]"/>
            </xsl:element>
            <xsl:if test="add-de">
              <xsl:element name="{$n}">
                <xsl:attribute name="lang">de</xsl:attribute>
                <!-- translation to be entered here --><xsl:text> </xsl:text>
              </xsl:element>
            </xsl:if>
          </xsl:if>

          <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
            <xsl:with-param name="attribute">
              <xsl:value-of select="$attribute"/>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:if>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 


  <xsl:template match="w:p" mode="specs">
    <xsl:param name="id"/>
    <xsl:variable name="p">
      <xsl:text>document('../fix/</xsl:text>
      <xsl:value-of select="$id"/>
      <xsl:text>.xml')/styleguide//*[@id='</xsl:text>
      <xsl:value-of select="$id"/>
      <xsl:text>']/specs</xsl:text>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="(string-length($id) > 0) and (string-length(dyn:evaluate($p)/text()) > 0)">
	<xsl:apply-templates select="dyn:evaluate($p)" mode="copy"/>
	<xsl:if test="add-de">
	  <xsl:element name="{$n}">
	    <xsl:attribute name="lang">de</xsl:attribute>
	    <!-- translation to be entered here --><xsl:text> </xsl:text>
	  </xsl:element>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="s1">
	  <xsl:apply-templates select="." mode="specs-recur"/>
	</xsl:variable>
	<xsl:variable name="s2">
	  <xsl:value-of select="str:replace($s1,'Vital Statistics:','')"/>
	</xsl:variable>
	<xsl:variable name="s3">
	  <xsl:value-of select="str:replace($s2,'::',':')"/>
	</xsl:variable>
	<xsl:variable name="s4">
	  <xsl:value-of select="str:replace($s3,'%','')"/>
	</xsl:variable>
	<xsl:variable name="s5">
	  <xsl:value-of select="str:replace($s4,'(varies w/ fruit)','')"/>
	</xsl:variable>
	<xsl:variable name="s">
	  <xsl:value-of select="str:replace($s5,' ','')"/>
	</xsl:variable>
	<xsl:if test="string-length($s) > 0">
	  <xsl:choose>
	    <xsl:when test="contains($s,'IBUs:')">
	      <xsl:element name="specs">
		<xsl:if test="contains($s,'IBUs:')">
		  <xsl:element name="ibu">
		    <xsl:choose>
		      <xsl:when test="contains(substring-before(substring-after($s5,'IBUs:'),':'),'–')">
			<xsl:attribute name="min">
			  <xsl:value-of select="substring-before(substring-after($s,'IBUs:'),'–')"/>
			</xsl:attribute>
			<xsl:attribute name="max">
			  <xsl:value-of select="substring-before(substring-after(substring-after($s,'IBUs:'),'–'),':')"/>
			</xsl:attribute>
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="normalize-space(substring-before(substring-after($s5,'IBUs:'),':'))"/>
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:element>
		</xsl:if>
		<xsl:if test="contains($s,'SRM:')">
		  <xsl:element name="srm">
		    <xsl:choose>
		      <xsl:when test="contains(substring-before(substring-after($s5,'SRM:'),':'),'–')">
			<xsl:attribute name="min">
			  <xsl:value-of select="substring-before(substring-after($s,'SRM:'),'–')"/>
			</xsl:attribute>
			<xsl:attribute name="max">
			  <xsl:value-of select="substring-before(substring-after(substring-after($s,'SRM:'),'–'),':')"/>
			</xsl:attribute>
			<xsl:attribute name="ebc-min">
			  <xsl:value-of select="b:srmToEbc(substring-before(substring-after($s,'SRM:'),'–'))"/>
			</xsl:attribute>
			<xsl:attribute name="ebc-max">
			  <xsl:value-of select="b:srmToEbc(substring-before(substring-after(substring-after($s,'SRM:'),'–'),':'))"/>
			</xsl:attribute>
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="normalize-space(substring-before(substring-after($s5,'SRM:'),':'))"/>
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:element>
		</xsl:if>
		<xsl:if test="contains($s,'OG:')">
		  <xsl:element name="og">
		    <xsl:choose>
		      <xsl:when test="contains(substring-before(substring-after($s5,'OG:'),':'),'–')">
			<xsl:attribute name="min">
			  <xsl:value-of select="substring-before(substring-after($s,'OG:'),'–')"/>
			</xsl:attribute>
			<xsl:attribute name="max">
			  <xsl:value-of select="substring-before(substring-after(substring-after($s,'OG:'),'–'),':')"/>
			</xsl:attribute>
			<xsl:attribute name="plato-min">
			  <xsl:value-of select="b:sgToPlato(substring-before(substring-after($s,'OG:'),'–'))"/>
			</xsl:attribute>
			<xsl:attribute name="plato-max">
			  <xsl:value-of select="b:sgToPlato(substring-before(substring-after(substring-after($s,'OG:'),'–'),':'))"/>
			</xsl:attribute>
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="normalize-space(substring-before(substring-after($s5,'OG:'),':'))"/>
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:element>
		</xsl:if>
		<xsl:if test="contains($s,'FG:')">
		  <xsl:element name="fg">
		    <xsl:choose>
		      <xsl:when test="contains(substring-before(substring-after($s5,'FG:'),':'),'–')">
			<xsl:attribute name="min">
			  <xsl:value-of select="substring-before(substring-after($s,'FG:'),'–')"/>
			</xsl:attribute>
			<xsl:attribute name="max">
			  <xsl:value-of select="substring-before(substring-after(substring-after($s,'FG:'),'–'),':')"/>
			</xsl:attribute>
			<xsl:attribute name="plato-min">
			  <xsl:value-of select="b:sgToPlato(substring-before(substring-after($s,'FG:'),'–'))"/>
			</xsl:attribute>
			<xsl:attribute name="plato-max">
			  <xsl:value-of select="b:sgToPlato(substring-before(substring-after(substring-after($s,'FG:'),'–'),':'))"/>
			</xsl:attribute>
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="normalize-space(substring-before(substring-after($s5,'FG:'),':'))"/>
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:element>
		</xsl:if>
		<xsl:if test="contains($s,'ABV:')">
		  <xsl:element name="abv">
		    <xsl:choose>
		      <xsl:when test="contains(substring-before(substring-after($s5,'ABV:'),':'),'–')">
			<xsl:attribute name="min">
			  <xsl:value-of select="substring-before(substring-after($s,'ABV:'),'–')"/>
			</xsl:attribute>
			<xsl:attribute name="max">
			  <xsl:value-of select="substring-before(substring-after(substring-after($s,'ABV:'),'–'),':')"/>
			</xsl:attribute>
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="normalize-space(substring-before(substring-after($s5,'ABV:'),':'))"/>
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:element>
		</xsl:if>
	      </xsl:element>      
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:element name="specs">
		<xsl:value-of select="normalize-space(str:replace($s5,':',''))"/>
	      </xsl:element>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    


  <xsl:template match="w:p" mode="specs-recur">
    <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1') and not(w:pPr/w:pStyle/@w:val='Heading2') and not(w:pPr/w:pStyle/@w:val='Heading2first') and not(w:pPr/w:pStyle/@w:val='Heading3') and not(w:pPr/w:pStyle/@w:val='TOC2') and not(w:r/w:t = 'Strength classifications:')">
      <xsl:if test="w:pPr/w:pStyle/@w:val = 'Specs' or w:pPr/w:pStyle/@w:val = 'SpecsLast' or w:r/w:t = 'SRM:' or w:r/w:t = 'IBUs:' or normalize-space(w:r/w:t) = 'Vital Statistics:'">
        <xsl:variable name="s">
          <xsl:for-each select="w:r/w:t | w:r/w:tab">
            <xsl:if test="local-name() = 'tab'">:</xsl:if>
            <xsl:value-of select="text()"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="shack"> <!-- hack for SRM in 33B -->
	  <xsl:value-of select="str:replace($s,':often','often')"/>
        </xsl:variable>
        <xsl:value-of select="$shack"/>
        <xsl:text>:</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="specs-recur"/>
    </xsl:if>
  </xsl:template>



  <xsl:template match="w:p" mode="strengths">
    <xsl:param name="id"/>
    <xsl:param name="bingo"/>
    <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1') and not(w:pPr/w:pStyle/@w:val='Heading2') and not(w:pPr/w:pStyle/@w:val='Heading2first') and not(w:pPr/w:pStyle/@w:val='Heading3') and not(w:pPr/w:pStyle/@w:val='TOC2')">
      <xsl:choose>
        <xsl:when test="w:r/w:t = 'Strength classifications:'">
          <xsl:element name="strength-classifications">
            <xsl:apply-templates select="following-sibling::w:p[1]" mode="strengths">
              <xsl:with-param name="bingo">yes</xsl:with-param>
            </xsl:apply-templates>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$bingo">
          <xsl:if test="w:pPr/w:pStyle/@w:val = 'Specs' or w:pPr/w:pStyle/@w:val = 'SpecsLast'">
            <xsl:variable name="s">
              <xsl:for-each select="w:r/w:t | w:r/w:tab">
                <xsl:if test="local-name() = 'tab'">:</xsl:if>
                <xsl:value-of select="text()"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:element name="strength">
              <xsl:value-of select="$s"/>
            </xsl:element>
          </xsl:if>
          <xsl:apply-templates select="following-sibling::w:p[1]" mode="strengths">
            <xsl:with-param name="bingo">yes</xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="following-sibling::w:p[1]" mode="strengths"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>



  <xsl:template match="w:p" mode="tags">
    <xsl:param name="id"/>
    <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1') and not(w:pPr/w:pStyle/@w:val='Heading2') and not(w:pPr/w:pStyle/@w:val='Heading2first') and not(w:pPr/w:pStyle/@w:val='Heading3') and not(w:pPr/w:pStyle/@w:val='TOC2')">
      <xsl:if test="substring(w:r/w:t,1,4) = 'Tags'">
        <xsl:element name="tags">
          <xsl:call-template name="tag">
            <xsl:with-param name="tags">
              <xsl:value-of select="normalize-space(translate(w:r[position() >= 2]/w:t/text(),',',''))"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:element>
      </xsl:if>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="tags"/>
    </xsl:if>
  </xsl:template>
 


  <xsl:template name="tag">
    <xsl:param name="tags"/>
    <xsl:choose>
      <xsl:when test="contains($tags, ' ')">
        <xsl:element name="tag">
	  <!-- we have to adjust some tag names -->
          <xsl:value-of select="str:replace(str:replace(str:replace(str:replace(str:replace(str:replace(substring-before($tags, ' '),'fermenting','fermented'),'fermentation','fermented'),'any-fermented','any-fermentation'),'session-beer','session-strength'),'sour-ale-family','sour'),'specialty-family','specialty-beer')"/>
        </xsl:element>
        <xsl:call-template name="tag">
          <xsl:with-param name="tags">
            <xsl:value-of select="substring-after($tags, ' ')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="tag">
          <xsl:value-of select="$tags"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="normalized-w-r">
    <xsl:variable name="t">
      <xsl:apply-templates select="w:r">
	<xsl:with-param name="br">yes</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:value-of select="normalize-space($t)"/>
  </xsl:template>



  <xsl:template match="w:r">
    <xsl:param name="br"/>
    <xsl:variable name="t">
      <xsl:choose>
        <xsl:when test="w:br and $br">
	  <xsl:text> </xsl:text>
        </xsl:when>
        <xsl:when test="(position() = 1) and (substring(w:t,1,1) = ' ') and (position() = last()) and (substring(w:t,string-length(w:t),1) = ' ')">
          <xsl:value-of select="substring(w:t,2,string-length(w:t)-2)"/>
        </xsl:when>
        <xsl:when test="(position() = 1) and (substring(w:t,1,1) = ' ')">
          <xsl:value-of select="substring(w:t,2)"/>
        </xsl:when>
        <xsl:when test="(position() = last()) and (substring(w:t,string-length(w:t),1) = ' ')">
          <xsl:value-of select="substring(w:t,1,string-length(w:t)-1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="w:t"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="string-length($t) > 0">
      <xsl:choose>
        <xsl:when test="w:rPr/w:b[not(@w:val='0')]">
          <xsl:element name="b">
            <xsl:value-of select="$t"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="w:rPr/w:u[not(@w:val='0')]">
          <xsl:element name="u">
            <xsl:value-of select="$t"/>
          </xsl:element>
        </xsl:when>
	<!-- WTF, some ° chars are italic in the original document -->
        <xsl:when test="(w:rPr/w:i) and ($t != '°')">
          <xsl:element name="i">
            <xsl:value-of select="$t"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$t"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>



  <xsl:template match="w:p" mode="in-category">
    <xsl:if test="((w:pPr/w:pStyle/@w:val='Heading2') or (w:pPr/w:pStyle/@w:val='Heading2first')) and (w:r/w:t)">
      <xsl:variable name="s">
        <xsl:for-each select="w:r/w:t">
          <xsl:value-of select="text()"/>
        </xsl:for-each>
      </xsl:variable>  
      <xsl:variable name="title">
        <xsl:value-of select="normalize-space($s)"/>
      </xsl:variable>
      <xsl:call-template name="subcategory">
        <xsl:with-param name="title">
          <xsl:value-of select="$title"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1')">
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-category"/>
    </xsl:if>
  </xsl:template>



  <xsl:template match="w:p" mode="in-subcategory">
    <xsl:param name="id"/>
    <xsl:if test="((w:pPr/w:pStyle/@w:val='Heading3') or (w:pPr/w:pStyle/@w:val='Heading3first')) and (w:r/w:t)">
      <xsl:variable name="s">
        <xsl:for-each select="w:r/w:t">
          <xsl:value-of select="text()"/>
        </xsl:for-each>
      </xsl:variable>  
      <xsl:variable name="title">
        <xsl:value-of select="normalize-space($s)"/>
      </xsl:variable>
      <xsl:call-template name="subcategory">
        <xsl:with-param name="id">
          <xsl:value-of select="$id"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="translate(substring-after($title,': '),'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/>
        </xsl:with-param>
        <xsl:with-param name="title">
          <xsl:value-of select="$title"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1') and not(w:pPr/w:pStyle/@w:val='Heading2')">
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-subcategory">
        <xsl:with-param name="id">
          <xsl:value-of select="$id"/>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>



  <xsl:template name="style-intro">
    <xsl:variable name="nodeset">
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="style-intro-recur"/>
    </xsl:variable>
    <xsl:if test="string-length($nodeset) >= 1">
      <xsl:element name="description">
	<xsl:apply-templates select="following-sibling::w:p[1]" mode="style-intro-recur"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
 


  <xsl:template match="w:p" mode="style-intro-recur">
    <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1') and not(w:pPr/w:pStyle/@w:val='Heading2') and not(w:pPr/w:pStyle/@w:val='Heading2first') and not(w:pPr/w:pStyle/@w:val='Heading3') and not(w:pPr/w:pStyle/@w:val='TOC2')">
      <xsl:if test="((w:pPr/w:pStyle/@w:val = 'StyleIntro') or (w:pPr/w:pStyle/@w:val = 'StyleIntroLast')) and (not(w:r/w:t = 'Entry Instructions:'))">
        <xsl:element name="p">
          <xsl:apply-templates select="w:r"/>
        </xsl:element>
        <xsl:if test="add-de">
          <xsl:element name="p">
            <xsl:attribute name="lang">de</xsl:attribute>
            <!-- translation to be entered here --><xsl:text> </xsl:text>
          </xsl:element>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="style-intro-recur"/>
    </xsl:if>
  </xsl:template>

 

  <xsl:template match="w:p | w:tbl" mode="in-chapter">
    <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1')">
      <xsl:choose>
	<xsl:when test="local-name(.) = 'tbl'">
	  <xsl:element name="div">
	    <xsl:attribute name="class">
	      <xsl:text>table</xsl:text>
	    </xsl:attribute>
	    <xsl:for-each select="w:tr">
	      <xsl:choose>
		<xsl:when test="w:tc/w:tcPr/w:gridSpan">
		  <xsl:element name="div">
		    <xsl:attribute name="class">
		      <xsl:text>table-head</xsl:text>
		    </xsl:attribute>
		    <xsl:value-of select="w:tc/w:p/w:r/w:t"/>
		  </xsl:element>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:element name="div">
		    <xsl:attribute name="class">
		      <xsl:text>table-row</xsl:text>
		    </xsl:attribute>
		    <xsl:for-each select="w:tc[position() != 1]">
		      <xsl:element name="div">
			<xsl:attribute name="class">
			  <xsl:text>table-cell</xsl:text>
			</xsl:attribute>
			<xsl:value-of select="w:p/w:r/w:t"/>
		      </xsl:element>
		    </xsl:for-each>
		  </xsl:element>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:for-each>
	  </xsl:element>
	  <xsl:apply-templates select="following-sibling::*[1]" mode="in-chapter"/>
	</xsl:when>
	<!-- Hack to match Color Reference table -->
	<xsl:when test="w:r[1]/w:t='Straw'">
	  <xsl:element name="div">
	    <xsl:attribute name="class">
	      <xsl:text>table</xsl:text>
	    </xsl:attribute>
	    <xsl:for-each select="w:r[not(w:tab)]">
	      <xsl:element name="div">
		<xsl:attribute name="class">
		  <xsl:text>table-row</xsl:text>
		</xsl:attribute>
		<xsl:element name="div">
		  <xsl:attribute name="class">
		    <xsl:text>table-cell</xsl:text>
		  </xsl:attribute>
		  <xsl:value-of select="w:t"/>
		</xsl:element>
		<xsl:element name="div">
		  <xsl:attribute name="class">
		    <xsl:text>table-cell</xsl:text>
		  </xsl:attribute>
		  <xsl:value-of select="following-sibling::w:r[1]/w:t"/>
		</xsl:element>
	      </xsl:element>
	    </xsl:for-each>
	  </xsl:element>
	  <xsl:apply-templates select="following-sibling::*[1]" mode="in-chapter"/>
	</xsl:when>
	<xsl:when test="w:pPr/w:pStyle/@w:val='ProseListNumbered'">
	  <xsl:element name="ol">
	    <xsl:element name="li">
	      <xsl:apply-templates select="w:r"/>
	    </xsl:element>
	    <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-chapter-list"/>
	  </xsl:element>
	  <xsl:apply-templates select="following-sibling::*[not(w:pPr/w:pStyle/@w:val='ProseListNumbered')][1]" mode="in-chapter"/>
	</xsl:when>	  
	<xsl:when test="w:pPr/w:pStyle/@w:val='ProseList'">
	  <xsl:element name="ul">
	    <xsl:element name="li">
	      <xsl:apply-templates select="w:r"/>
	    </xsl:element>
	    <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-chapter-list"/>
	  </xsl:element>
	  <xsl:apply-templates select="following-sibling::*[not(w:pPr/w:pStyle/@w:val='ProseList')][1]" mode="in-chapter"/>
	</xsl:when>	  
	<xsl:when test="w:pPr/w:pStyle/@w:val='ProseIntro'">
	  <xsl:element name="p">
	    <!--<xsl:attribute name="class">intro</xsl:attribute>-->
	    <xsl:apply-templates select="w:r"/>
	  </xsl:element>
	  <xsl:apply-templates select="following-sibling::*[1]" mode="in-chapter"/>
	</xsl:when>
	<xsl:when test="w:pPr/w:pStyle/@w:val='ProseBody' and w:r">
	  <xsl:element name="p">
	    <!--<xsl:attribute name="class">body</xsl:attribute>-->
	    <xsl:apply-templates select="w:r"/>
	  </xsl:element>
	  <xsl:apply-templates select="following-sibling::*[1]" mode="in-chapter"/>
	</xsl:when>
	<xsl:when test="w:pPr/w:pStyle/@w:val='Heading2first' or w:pPr/w:pStyle/@w:val='Heading2'">
	  <xsl:variable name="label0">
	    <xsl:apply-templates select="w:r"/>
	  </xsl:variable>
	  <xsl:variable name="label">
	    <xsl:value-of select="translate(normalize-space($label0),'ABCDEFGHIJKLMNOPQRSTUVWXYZ :.()','abcdefghijklmnopqrstuvwxyz-')"/>
	  </xsl:variable>
	  <xsl:if test="string-length($label) > 0">
	    <xsl:element name="h3">
	      <xsl:attribute name="id">
		<xsl:value-of select="$label"/>
	      </xsl:attribute>
	      <xsl:call-template name="normalized-w-r"/>
	    </xsl:element>
	  </xsl:if>
	  <xsl:apply-templates select="following-sibling::*[1]" mode="in-chapter"/>
	</xsl:when>
	<xsl:when test="w:pPr/w:pStyle/@w:val='Heading3first' or w:pPr/w:pStyle/@w:val='Heading3'">
	  <xsl:variable name="label0">
	    <xsl:apply-templates select="w:r"/>
	  </xsl:variable>
	  <xsl:variable name="label">
	    <xsl:value-of select="translate(normalize-space($label0),'ABCDEFGHIJKLMNOPQRSTUVWXYZ :.()','abcdefghijklmnopqrstuvwxyz-')"/>
	  </xsl:variable>
	  <xsl:if test="string-length($label) > 0">
	    <xsl:element name="h4">
	      <xsl:attribute name="id">
		<xsl:value-of select="$label"/>
	      </xsl:attribute>
	      <xsl:apply-templates select="w:r"/>
	    </xsl:element>
	  </xsl:if>
	  <xsl:apply-templates select="following-sibling::*[1]" mode="in-chapter"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="following-sibling::*[1]" mode="in-chapter"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="w:p" mode="in-chapter-list">
    <xsl:if test="w:pPr/w:pStyle/@w:val='ProseListNumbered' or w:pPr/w:pStyle/@w:val='ProseList'">
      <xsl:element name="li">
	<xsl:apply-templates select="w:r"/>
      </xsl:element>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-chapter-list"/>
    </xsl:if>	  
  </xsl:template>


  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
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
