<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="buildHead">
    <meta charset="utf-8"/>
    <title><xsl:value-of select="@title"/></title>
    <link href="//cdnjs.cloudflare.com/ajax/libs/normalize/3.0.1/normalize.min.css" rel="stylesheet"/>
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css" rel="stylesheet"/>
    <link href="//brick.a.ssl.fastly.net/Alegreya:400,700" rel="stylesheet"/>
    <link href="//files.davising.com/opml/base.css" rel="stylesheet"/>
  </xsl:template>

  <xsl:template name="buildJS">
    <script src="//code.jquery.com/jquery-2.1.0.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.5.1/moment.min.js"></script>
    <script src="//files.davising.com/opml/outline.js"></script>
  </xsl:template>

  <xsl:template name="buildTitle">
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

    <header>
      <h1 class="title">
	<a href="{$path}">
	<xsl:choose>
	  <xsl:when test="@title"> <xsl:value-of select="@title"/> </xsl:when>
	  <xsl:otherwise> <xsl:value-of select="@text"/> </xsl:otherwise>
	</xsl:choose>
	</a>
      </h1>
      <xsl:if test="@subtitle">
	<h2 class="subtitle"><xsl:value-of select="@subtitle"/></h2>
      </xsl:if>
      <xsl:if test="@created">
	<section>
	  <small class="created"><xsl:value-of select="@created"/></small>
	</section>
      </xsl:if>
    </header>    
  </xsl:template>

  <xsl:template name="buildNavbar">
    <div id="navbar">
      <ul>
	<li class="name"><a href="/">Eric Davis</a></li>
	<li><a href="/about.html">About</a></li>
	<!-- <li><a href="/colophon.html">Colophon</a></li> -->
	<li><a href="mailto:eric@davising.com"><i style="color:#66757f;" class="fa fa-envelope"></i></a></li>
	<li><a href="https://twitter.com/ejd791"><i style="color:#55ACEE;" class="fa fa-twitter"></i></a></li>
	<li><a href="https://www.facebook.com/circa1979"><i style="color:#3B5998;" class="fa fa-facebook-square"></i></a></li>
	<li><a href="https://github.com/edavis"><i class="fa fa-github"></i></a></li>
	<li><a href="https://www.linkedin.com/pub/eric-davis/55/127/b0a"><i style="color:#007bb6;" class="fa fa-linkedin-square"></i></a></li>
	<li><a href="/rss.xml"><i style="color:#ff6600;" class="fa fa-rss"></i></a></li>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="buildIndex">
    <html lang="en-us">
      <head>
	<xsl:call-template name="buildHead"/>
      </head>
      <body id="index">
	<xsl:call-template name="buildNavbar"/>
	<div class="container">
	  <xsl:for-each select=".//outline[@type]">
	    <xsl:call-template name="buildTitle"/>
	    <ul class="fa-ul root">
	      <xsl:apply-templates select="outline"/>
	    </ul>
	  </xsl:for-each>
	  <xsl:call-template name="buildJS"/>
	</div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
