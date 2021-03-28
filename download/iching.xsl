<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:template match="IChing">
      <html>
        <head><title><xsl:value-of select="title"/></title></head>
        <body><table border="1"><xsl:apply-templates/></table></body>
      </html>
    </xsl:template>
    <xsl:template match="hexagram">
        <tr><xsl:apply-templates/></tr>
    </xsl:template>
    <xsl:template match="number">
        <td><xsl:apply-templates/></td>
    </xsl:template>
    <xsl:template match="name">
        <td><xsl:apply-templates/></td>
    </xsl:template>
    <xsl:template match="judgement">
        <td><xsl:apply-templates/></td>
    </xsl:template>
    <xsl:template match="*"></xsl:template>
</xsl:stylesheet>

