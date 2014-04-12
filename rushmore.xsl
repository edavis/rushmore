<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" indent="yes"/>

  <xsl:include href="templates.xsl"/>
  <xsl:include href="rss.xsl"/>

  <!-- Build the collection of indexes and outlines -->
  <xsl:template match="/opml">
    <collection>
      <!-- First, build the index pages. `body' represents the root level index.html. -->
      <xsl:for-each select="body//outline[not(@type)] | body">
	<!-- If the current node has an ancestor with a @type attribute,
             it's a "body" paragraph, so skip it. -->
	<xsl:if test="not(ancestor::outline[@type])">

	  <xsl:variable name="path">
	    <xsl:for-each select="ancestor-or-self::outline">
  	      <xsl:text>/</xsl:text>
  	      <xsl:choose>
  		<xsl:when test="@name">
		  <xsl:value-of select="@name"/>
		</xsl:when>
  		<xsl:otherwise>
		  <xsl:value-of select="@text"/>
		</xsl:otherwise>
  	      </xsl:choose>
	    </xsl:for-each>
	    <xsl:text>/index.html</xsl:text>
	  </xsl:variable>

	  <index path="{$path}">
	    <xsl:call-template name="buildIndex"/>
	  </index>
	</xsl:if>
      </xsl:for-each>

      <!-- Then, build the outline detail pages -->
      <xsl:apply-templates select=".//outline[@type]"/>

      <!-- Build the RSS file -->
      <xsl:call-template name="buildRSS"/>
    </collection>
  </xsl:template>

  <!-- Template for outline detail pages -->
  <xsl:template match="outline[@type='outline']">
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

    <outline path="{$path}">
      <html lang="en-us">
	<head>
	  <xsl:call-template name="buildHead"/>
	  <xsl:if test="@css">
	    <link href="{@css}" rel="stylesheet"/>
	  </xsl:if>
	</head>
	<body>
	  <xsl:call-template name="buildNavbar"/>
	  <div class="container">
	    <xsl:call-template name="buildTitle"/>
	    <ul class="fa-ul root">
	      <xsl:apply-templates select="outline"/>
	    </ul>
	  </div>
	  <xsl:call-template name="buildJS"/>
	</body>
      </html>
    </outline>
  </xsl:template>

  <!-- Applied from the root ul in outline detail pages -->
  <xsl:template match="outline[not(@type)]">
    <xsl:variable name="data-collapse" select="@collapse='true'"/>

    <xsl:variable name="collapse-class">
      <xsl:choose>
	<xsl:when test="@collapse='true'"><xsl:text>fa fa-li fa-caret-right</xsl:text></xsl:when>
	<xsl:otherwise><xsl:text>fa fa-li fa-caret-down</xsl:text></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="count(outline)">
	<li class="has-children" data-collapse="{$data-collapse}">
	  <i class="{$collapse-class}"></i>
	  <xsl:value-of select="@text" disable-output-escaping="yes"/>
	  <ul class="fa-ul">
	    <xsl:apply-templates select="outline"/>
	  </ul>
	</li>
      </xsl:when>
      <xsl:otherwise>
	<li class="no-children">
	  <i class="fa fa-li fa-caret-right"></i>
	  <xsl:value-of select="@text" disable-output-escaping="yes"/>
	</li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
