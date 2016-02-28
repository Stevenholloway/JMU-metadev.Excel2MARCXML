<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/TR/REC-html40"
    xmlns:marc="http://www.loc.gov/MARC21/slim">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- Expects results from Excel2NamedXML.xsl, available at http://www.codeproject.com/Tips/780861/XSLT-to-transform-Excel-XML-worksheet-to-named-nod under a CPOL license. 
    Script designed to create RDA person authority records from JMU ETD submission dissertant metadata 
    Gender is supposed to be determined on the basis of the name and inserted in a 375, but omit the field if unclear or troubling 
    First pass made at Staunton Open Source coding night, 3/3/2015 
    Modification date 2/03/2016 
    Created by Steven W. Holloway, Metadata Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License -->
    <xsl:template match="/">
        <xsl:comment>Transformed by NamedXML2MARC_AUTHORITY.xsl
    Expects results from Excel2NamedXML.xsl, available at http://www.codeproject.com/Tips/780861/XSLT-to-transform-Excel-XML-worksheet-to-named-nod under a CPOL license. 
    Script designed to create RDA person authority records from JMU ETD submission metadata
    Created by Steven W. Holloway, Metadata Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License</xsl:comment>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="table">
        <marc:collection
            xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">

            <xsl:apply-templates/>

        </marc:collection>
    </xsl:template>
    <xsl:template match="row">
        <marc:record>
            <!-- leader authority record boilerplate for new records -->
            <marc:leader>     nz  a22     n  4500</marc:leader>
            <marc:controlfield tag="005">
                <!-- date/time stamp in MARC format -->
                <xsl:value-of
                    select="format-dateTime(current-dateTime(),'[Y][M01][D01][H][m][s].[f,1-1]')"/>
            </marc:controlfield>
            <!-- inserts date stamp; the rest of the 008 is static -->
            <marc:controlfield tag="008"><xsl:value-of
                select="format-date(current-date(),'[Y,2-2][M01][D01]')"/>n| azannaabn           a aaa     c</marc:controlfield>
            <xsl:choose>
                <!-- selects and inserts orcid in 024 if available, otherwise skips this step -->
                <xsl:when test="orcid/text()">
                    <marc:datafield tag="024" ind1="7" ind2=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="orcid"/>
                        </marc:subfield>
                        <marc:subfield code="2">orcid</marc:subfield>
                    </marc:datafield>
                </xsl:when>
            </xsl:choose>
            <marc:datafield tag="040" ind1=" " ind2=" ">
                <!-- inserts 040 JMU boilerplate -->
                <marc:subfield code="a">ViHarT</marc:subfield>
                <marc:subfield code="b">eng</marc:subfield>
                <marc:subfield code="e">rda</marc:subfield>
                <marc:subfield code="c">ViHarT</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="100" ind1="1" ind2=" ">
                <!-- Main entry: chooses "preferred_name" if available, otherwise, selects the fullest form of the author's name entered in "author1" tags -->
                <!-- may add an unwanted space between the given name(s) and punctuation; "fixes" lead to deleted middle initials -->
                <marc:subfield code="a">
                    <xsl:choose>
                        <xsl:when test="preferred_name/text()[contains(.,'.')]">
                            <xsl:analyze-string select="preferred_name" regex="^[A-z].*\s">
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="."/>, </xsl:non-matching-substring>
                            </xsl:analyze-string>
                            <xsl:analyze-string select="preferred_name" regex="^[A-z].*\.">
                                <xsl:matching-substring>
                                    <xsl:value-of select="."/></xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                        <xsl:when test="preferred_name/text()">
                            <xsl:analyze-string select="preferred_name" regex="^[A-z].*\s">
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="."/>, </xsl:non-matching-substring>
                            </xsl:analyze-string>
                            <xsl:analyze-string select="preferred_name" regex="^[A-z].*\s"><xsl:matching-substring><xsl:value-of select="."/></xsl:matching-substring></xsl:analyze-string>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="author1_mname/text()">
                                    <xsl:value-of select="author1_lname"></xsl:value-of>,<xsl:text> </xsl:text>
                                    <xsl:value-of
                                        select="author1_fname">
                                        
                                    </xsl:value-of><xsl:text> </xsl:text>
                                    <xsl:value-of select="author1_mname"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="author1_lname"/>, <xsl:value-of
                                    select="author1_fname"/></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>
                </marc:subfield>
            </marc:datafield>
            <marc:datafield tag="370" ind1=" " ind2=" ">
                <!-- inserts associated place boilerplate -->
                <marc:subfield code="e">Harrisonburg (Va.)</marc:subfield>
                <marc:subfield code="2">naf</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="373" ind1=" " ind2=" ">
                <!-- inserts associated group (James Madison University), with value of "department" -->
                <!-- Until ETD submission form supports a dropdown menu for the names, the value will need to be checked against JMU department authority records-->
                <marc:subfield code="a">James Madison University. <xsl:value-of select="department"/></marc:subfield>
                <marc:subfield code="2">naf</marc:subfield>
            </marc:datafield>
            <!-- commented out 02/03/2016 -->
<!--            <marc:datafield tag="375" ind1=" " ind2=" ">
                <!-\- inserts empty 375, male or female value, to be guessed at by the cataloger -\->
                <marc:subfield code="a">[DELETE IF UNSURE]</marc:subfield>
            </marc:datafield>-->
            <marc:datafield tag="377" ind1=" " ind2=" ">
                <!-- inserts language of expression with set value "eng" -->
                <!-- if thesis in not in English, cataloger should insert another subfield a with appropriate MARC language code -->
                <marc:subfield code="a">eng</marc:subfield>
            </marc:datafield>
            <xsl:choose>
                <xsl:when test="(preferred_name/text()) and (author1_lname/text())">
            <marc:datafield tag="400" ind1="1" ind2=" ">
                <!-- creates 400 using fuller form of author name if both preferred_name & author1_lname is present -->
                <marc:subfield code="a">
                        <xsl:choose>
                            <xsl:when test="author1_mname/text()">
                                <xsl:value-of select="author1_lname"/>,<xsl:text> </xsl:text><xsl:value-of
                                    select="author1_fname"/><xsl:text> </xsl:text><xsl:value-of
                                        select="author1_mname"/></xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="author1_lname"/>,<xsl:text> </xsl:text><xsl:value-of
                                    select="author1_fname"/></xsl:otherwise>
                        </xsl:choose></marc:subfield>
            </marc:datafield>
                </xsl:when>
            </xsl:choose>
            <marc:datafield tag="510" ind1="2" ind2=" ">
                <!-- 510 boilerplate establishing student's relationship with JMU -->
                <marc:subfield code="i">Corporate body: </marc:subfield>
                <marc:subfield code="a">James Madison University</marc:subfield>
                <marc:subfield code="w">r</marc:subfield>
            </marc:datafield>

            <marc:datafield tag="670" ind1=" " ind2=" ">
                <!-- converts "degree" string into abbreviation for subfield "a" -->
                <marc:subfield code="a"><xsl:value-of select="title"/>, James Madison University<!-- inserts degree abbreviation --> <xsl:choose><xsl:when test="degree_name='Master of Science (MS)'">M.S.</xsl:when>
                    <xsl:when test="degree_name='Doctor of Musical Arts (DMA)'">D.M.A.</xsl:when>
                    <xsl:when test="degree_name='Educational Specialist (EdS)'">Ed.S.</xsl:when>
                    <xsl:when test="degree_name='Doctor of Philosophy (PhD)'">Ph.D.</xsl:when>
                    <xsl:when test="degree_name='Master of Arts (MA)'">M.A.</xsl:when>
                    <xsl:when test="degree_name='Master of Science in Education (MSEd)'">M.S.Ed.</xsl:when>
                    <xsl:when test="degree_name='Master of Fine Arts (MFA)'">M.F.A.</xsl:when>
                    <xsl:when test="degree_name='Doctor of Audiology (AuD)'">Au.D.</xsl:when>
                    <xsl:when test="degree_name='Doctor of Psychology (PsyD)'">Psy.D.</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="degree_name"/>
                    </xsl:otherwise>
                </xsl:choose> thesis,<!-- inserts publication date into subfield "a"--> <xsl:analyze-string select="publication_date"
                    regex="(^\d{{4}})">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                </xsl:analyze-string>:</marc:subfield>
                <xsl:choose>
                    <xsl:when test="(preferred_name/text()) and (author1_lname/text())">
                        <!-- 670 that inserts preferred_name in uninverted order, if available, and full form of name, if available, into subfield "b" -->
                        <marc:subfield code="b">ETD online submission form <xsl:choose>
                            <xsl:when test="author1_mname/text()">(<xsl:value-of select="author1_fname"></xsl:value-of><xsl:text> </xsl:text><xsl:value-of select="author1_mname"></xsl:value-of><xsl:text> </xsl:text><xsl:value-of select="author1_lname"/>,<xsl:text> </xsl:text><xsl:value-of select="preferred_name"/>)</xsl:when>
                            <xsl:when test="author1_lname">(<xsl:value-of select="author1_fname"/><xsl:text> </xsl:text><xsl:value-of select="author1_lname"/>,<xsl:text> </xsl:text><xsl:value-of select="preferred_name"/>)</xsl:when>
                            <xsl:otherwise>(<xsl:value-of select="preferred_name"/>)</xsl:otherwise>
                        </xsl:choose>
                        </marc:subfield>
                    </xsl:when>
                    <xsl:when test="preferred_name/text()"><marc:subfield code="b">ETD online submission form (<xsl:value-of select="preferred_name"></xsl:value-of>)</marc:subfield></xsl:when>
                    <xsl:when test="author1_lname/text()"><marc:subfield code="b">ETD online submission form (<!-- inserts full name in uninverted order --><xsl:choose>
                        <xsl:when test="author1_mname/text()">
                            <xsl:value-of select="author1_fname"/><xsl:text> </xsl:text><xsl:value-of select="author1_mname"/><xsl:text> </xsl:text><xsl:value-of select="author1_lname"/>)</xsl:when>
                        <xsl:otherwise><xsl:value-of select="author1_fname"/><xsl:text> </xsl:text><xsl:value-of select="author1_lname"/>)</xsl:otherwise>
                    </xsl:choose>
                    </marc:subfield></xsl:when>
                </xsl:choose>
            </marc:datafield>
        </marc:record>
    </xsl:template>
</xsl:stylesheet>
