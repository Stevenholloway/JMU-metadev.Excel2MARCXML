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
    Script designed to create "explode" text files for MARC variable fields from JMU ETD submission metadata, to assist in proofing the creation of MARCXML NACO records from ETD Excel
    Created by Steven W. Holloway, Metadata Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License</xsl:text>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>ORCIDs (024): </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='024']/marc:subfield[@code='a']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Preferred name (100): </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='100']/marc:subfield[@code='a']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Other form of name (400): </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='400']/marc:subfield[@code='a']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>JMU departments (373): </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='373']/marc:subfield[@code='a']">
            <xsl:text>&#xa;</xsl:text><xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Gender (375): </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='375']/marc:subfield[@code='a']">
            <xsl:text>&#xa;</xsl:text><xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Language (377): </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='377']/marc:subfield[@code='a']">
            <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Dissertation title, degree and date (670 $a): </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='670']/marc:subfield[@code='a']">
            <xsl:text>&#xa;</xsl:text><xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;++++++++++++++++++</xsl:text>
        <xsl:text>Dissertant names (670 $b): </xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="//marc:datafield[@tag='670']/marc:subfield[@code='b']">
            <xsl:text>&#xa;</xsl:text><xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>