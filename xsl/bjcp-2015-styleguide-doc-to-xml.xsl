<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="exsl str">



  <xsl:variable name="add-de"></xsl:variable>



  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



  <xsl:template match="/w:document">
    <xsl:element name="styleguide">
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
      <xsl:value-of select="$title"/>
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

<!--
      <xsl:if test="not($id)">
        <xsl:apply-templates select="following-sibling::w:p[1]" mode="in-subcategory">
          <xsl:with-param name="id">
            <xsl:value-of select="substring-before($title,'. ')"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:if>
-->
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
    <xsl:element name="subcategory">
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="contains($title,'.')">
            <xsl:value-of select="substring-before($title,'. ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$id"/>
          </xsl:otherwise>
        </xsl:choose>
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
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Aroma</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Appearance</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Flavor</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Mouthfeel</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Comments</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">History</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Characteristic Ingredients</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Style Comparison</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Entry Instructions</xsl:with-param>
      </xsl:apply-templates>

      <!--
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Currently Defined Types</xsl:with-param>
      </xsl:apply-templates>
      -->
      <!-- TODO: Currently Defined Types sollte implizit klar sein. -->

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="specs"/>

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="strengths"/>

      <xsl:apply-templates select="following-sibling::w:p[1]" mode="attribute">
        <xsl:with-param name="attribute">Commercial Examples</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="tags"/>

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
    <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1') and not(w:pPr/w:pStyle/@w:val='Heading2') and not(w:pPr/w:pStyle/@w:val='Heading2first') and not(w:pPr/w:pStyle/@w:val='Heading3') and not(w:pPr/w:pStyle/@w:val='TOC2')">
      <xsl:if test="translate(substring(w:r/w:t,1,string-length($attribute)),'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-') = translate($attribute,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')">
        <xsl:variable name="n">
          <xsl:value-of select="translate($attribute,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz-')"/>
        </xsl:variable>
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
  </xsl:template>
 


  <xsl:template match="w:p" mode="specs">
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
      <xsl:value-of select="str:replace($s3,' ','')"/>
    </xsl:variable>
    <xsl:variable name="s5">
      <xsl:value-of select="str:replace($s4,'%','')"/>
    </xsl:variable>
    <xsl:variable name="s">
      <xsl:value-of select="str:replace($s5,'(variesw/fruit)','')"/>
    </xsl:variable>
    <xsl:if test="(string-length($s) > 0) and (contains($s,'IBU'))">
      <xsl:element name="specs">

        <xsl:if test="contains($s,'IBUs:')">
          <xsl:element name="ibu">
            <xsl:attribute name="min">
              <xsl:value-of select="substring-before(substring-after($s,'IBUs:'),'–')"/>
            </xsl:attribute>
            <xsl:attribute name="max">
              <xsl:value-of select="substring-before(substring-after(substring-after($s,'IBUs:'),'–'),':')"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>

        <xsl:if test="contains($s,'SRM:')">
          <xsl:element name="srm">
            <xsl:attribute name="min">
              <xsl:value-of select="substring-before(substring-after($s,'SRM:'),'–')"/>
            </xsl:attribute>
            <xsl:attribute name="max">
              <xsl:value-of select="substring-before(substring-after(substring-after($s,'SRM:'),'–'),':')"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>

        <xsl:if test="contains($s,'OG:')">
          <xsl:element name="og">
            <xsl:attribute name="min">
              <xsl:value-of select="substring-before(substring-after($s,'OG:'),'–')"/>
            </xsl:attribute>
            <xsl:attribute name="max">
              <xsl:value-of select="substring-before(substring-after(substring-after($s,'OG:'),'–'),':')"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>

        <xsl:if test="contains($s,'FG:')">
          <xsl:element name="fg">
            <xsl:attribute name="min">
              <xsl:value-of select="substring-before(substring-after($s,'FG:'),'–')"/>
            </xsl:attribute>
            <xsl:attribute name="max">
              <xsl:value-of select="substring-before(substring-after(substring-after($s,'FG:'),'–'),':')"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>

        <xsl:if test="contains($s,'ABV:')">
          <xsl:element name="abv">
            <xsl:attribute name="min">
              <xsl:value-of select="substring-before(substring-after($s,'ABV:'),'–')"/>
            </xsl:attribute>
            <xsl:attribute name="max">
              <xsl:value-of select="substring-before(substring-after(substring-after($s,'ABV:'),'–'),':')"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>

      </xsl:element>
    </xsl:if>
  </xsl:template>



  <xsl:template match="w:p" mode="specs-recur">
    <xsl:if test="not(w:pPr/w:pStyle/@w:val='Heading1') and not(w:pPr/w:pStyle/@w:val='Heading2') and not(w:pPr/w:pStyle/@w:val='Heading2first') and not(w:pPr/w:pStyle/@w:val='Heading3') and not(w:pPr/w:pStyle/@w:val='TOC2')">
      <xsl:if test="w:pPr/w:pStyle/@w:val = 'Specs' or w:pPr/w:pStyle/@w:val = 'SpecsLast' or w:r/w:t = 'SRM:'">
        <xsl:variable name="s">
          <xsl:for-each select="w:r/w:t | w:r/w:tab">
            <xsl:if test="local-name() = 'tab'">:</xsl:if>
            <xsl:value-of select="text()"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$s"/>
        <xsl:text>:</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="following-sibling::w:p[1]" mode="specs-recur"/>
    </xsl:if>
  </xsl:template>



  <xsl:template match="w:p" mode="strengths">
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
          <xsl:value-of select="substring-before($tags, ' ')"/>
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



  <xsl:template match="w:r">
    <xsl:variable name="t">
      <xsl:choose>
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
    <xsl:choose>
      <xsl:when test="w:rPr/w:b[not(@w:val='0')]">
        <xsl:element name="span">
          <xsl:attribute name="class">bold</xsl:attribute>
          <xsl:value-of select="$t"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="w:rPr/w:i">
        <xsl:element name="span">
          <xsl:attribute name="class">italic</xsl:attribute>
          <xsl:value-of select="$t"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$t"/>
      </xsl:otherwise>
    </xsl:choose>
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
 


  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>



</xsl:stylesheet>
