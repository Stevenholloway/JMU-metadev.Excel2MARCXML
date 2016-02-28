<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/TR/REC-html40"
    xmlns:marc="http://www.loc.gov/MARC21/slim">
    <xsl:output encoding="UTF-8" method="text"/>
    <xsl:strip-space elements="*"/>
    <!-- Created by Steven W. Holloway, Metadata Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License 
    modification date 02/03/2016-->
    <xsl:template match="/">
        <xsl:text>
    Script designed to create "explode" text files for MARC variable fields from JMU ETD submission metadata, to assist in proofing the creation of MARCXML bibliographic records from ETD Excel
    Created by Steven W. Holloway, Metadata Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License</xsl:text>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>ARKs: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='024']/marc:subfield[@code='a']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Dissertants: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='100']/marc:subfield[@code='a']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Titles: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='245']/marc:subfield">
            <xsl:text>&#xa;</xsl:text><xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Copyright dates: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='264' and  @ind2='4']/marc:subfield[@code='c']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Degree names and dates: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='502']/marc:subfield">
            <xsl:text>&#xa;</xsl:text><xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Embargo dates: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='506']/marc:subfield[@code='a']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>dissertant-supplied keywords and disciplines: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='590']/marc:subfield[@code='a']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Thesis advisors: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='700']/marc:subfield[@code='a']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>JMU departments: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='710']/marc:subfield[@code='b']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>URLs: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='856']/marc:subfield[@code='u']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Abstracts: </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='520']/marc:subfield[@code='a']">
            <xsl:text>&#xa;</xsl:text><xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>