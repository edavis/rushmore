<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" indent="yes"/>

  <xsl:param name="lastBuildDate"/>

  <xsl:template mode="rss" match="outline[not(@type)]">
    <xsl:choose>
      <xsl:when test="count(outline) and ../@type">
	<p>
	  <xsl:value-of select="@text" disable-output-escaping="yes"/>
	  <ul>
	    <xsl:apply-templates mode="rss" select="outline"/>
	  </ul>
	</p>
      </xsl:when>

      <xsl:when test="count(outline) and not(../@type)">
	<li>
	  <xsl:value-of select="@text" disable-output-escaping="yes"/>
	  <ul>
	    <xsl:apply-templates mode="rss" select="outline"/>
	  </ul>
	</li>
      </xsl:when>

      <xsl:when test="../@type">
	<p>
	  <xsl:value-of select="@text" disable-output-escaping="yes"/>
	</p>
      </xsl:when>

      <xsl:otherwise>
	<li>
	  <xsl:value-of select="@text" disable-output-escaping="yes"/>
	</li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="buildRSS">
    <syndication path="/rss.xml">
      <rss version="2.0">
	<channel>
	  <title><xsl:value-of select="head/title/text()"/></title>
	  <link><xsl:text>http://ericdavis.org/</xsl:text></link>
	  <description><xsl:text>Updates from ericdavis.org</xsl:text></description>
	  <webMaster>
	    <xsl:value-of select="head/ownerEmail/text()"/>
	    <xsl:text> (</xsl:text>
	    <xsl:value-of select="head/ownerName/text()"/>
	    <xsl:text>)</xsl:text>
	  </webMaster>
	  <lastBuildDate><xsl:value-of select="$lastBuildDate"/></lastBuildDate>
	  <docs><xsl:text>http://cyber.law.harvard.edu/rss/rss.html</xsl:text></docs>

	  <xsl:for-each select="body//outline[@type][@isFeedItem!='false' or not(@isFeedItem)]">
	    <xsl:variable name="path">
	      <xsl:for-each select="ancestor-or-self::outline">
  		<xsl:text>/</xsl:text>
  		<xsl:choose>
  		  <xsl:when test="@name"> <xsl:value-of select="@name"/> </xsl:when>
  		  <xsl:otherwise> <xsl:value-of select="@text"/> </xsl:otherwise>
  		</xsl:choose>
	      </xsl:for-each>
	      <xsl:text>.html</xsl:text>
	    </xsl:variable>

	    <item>
	      <!-- title -->
	      <xsl:if test="@title">
		<title><xsl:value-of select="@title"/></title>
	      </xsl:if>

	      <!-- description -->
	      <xsl:if test="count(outline)">
		<description>
		  <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
		  <xsl:apply-templates mode="rss" select="outline"/>
		  <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
		</description>
	      </xsl:if>

	      <!-- pubDate -->
	      <xsl:if test="@created">
		<pubDate><xsl:value-of select="@created"/></pubDate>
	      </xsl:if>

	      <!-- link -->
	      <link><xsl:text>http://ericdavis.org</xsl:text><xsl:value-of select="$path"/></link>

	      <!-- guid -->
	      <guid isPermalink="true"><xsl:text>http://ericdavis.org</xsl:text><xsl:value-of select="$path"/></guid>
	    </item>
	  </xsl:for-each>
	</channel>
      </rss>
    </syndication>
  </xsl:template>

</xsl:stylesheet>
