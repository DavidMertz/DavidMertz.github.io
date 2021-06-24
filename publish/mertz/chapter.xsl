<xsl:stylesheet	version="1.0" 
					xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
					xmlns="http://www.w3.org/TR/xhtml1/strict"> 
 
 <xsl:output 	method="html" 
  				indent="yes" 
				encoding="UTF-8" 
 /> 
 
<xsl:template match="chapter"> 
	<html> 
		<head> 
			<title> 
				<xsl:value-of select="title"/> 
			</title> 
		</head> 
		<body> 
			<xsl:apply-templates/> 
		</body> 
		</html> 
</xsl:template> 
 
<xsl:template match="chapter/title"> 
	<hr></hr> 
	<h1><xsl:apply-templates/></h1> 
</xsl:template> 
 
<xsl:template match="sect1/title"> 
	<hr></hr> 
	<h2><xsl:apply-templates/></h2> 
</xsl:template> 
 
<xsl:template match="sect2/title"> 
	<h3><xsl:apply-templates/></h3> 
</xsl:template> 
 
<xsl:template match="epigraph"> 
	<blockquote> 
		<xsl:for-each select="para"> 
			<xsl:apply-templates/> 
		</xsl:for-each> 
		<xsl:for-each select="attribution"> 
			<p align="right"><u><xsl:apply-templates/></u></p> 
		</xsl:for-each> 
	</blockquote> 
	<hr width="75%"></hr> 
</xsl:template> 
 
<xsl:template match="simplelist"> 
	<ul> 
		<xsl:for-each select="member"> 
			<li><xsl:apply-templates/></li> 
		</xsl:for-each> 
	</ul> 
</xsl:template> 
 
<xsl:template match="para"> 
	<p><xsl:apply-templates/></p> 
</xsl:template> 
 
<xsl:template match="ulink"> 
	<a> 
		<xsl:attribute name="href"> 
			<xsl:value-of select="@url"/> 
	     </xsl:attribute> 
		<xsl:apply-templates/> 
	</a> 
</xsl:template> 
 
 
<xsl:template match="blockquote"> 
	<blockquote><xsl:apply-templates/></blockquote> 
</xsl:template> 
 
<xsl:template match="citetitle"> 
	<cite><xsl:apply-templates/></cite> 
</xsl:template> 
 
<xsl:template match="footnote"> 
	<b><sup>[note]</sup></b> 
	<table border="1" cellpadding="1" bgcolor="#FFFFEE" width="35%" align="right"><tr><td> 
	<small><xsl:apply-templates/></small> 
	</td></tr></table> 
</xsl:template> 
 
 </xsl:stylesheet> 
