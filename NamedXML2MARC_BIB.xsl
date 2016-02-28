<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/TR/REC-html40"
    xmlns:marc="http://www.loc.gov/MARC21/slim">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- Expects results from Excel2NamedXML.xsl, available at http://www.codeproject.com/Tips/780861/XSLT-to-transform-Excel-XML-worksheet-to-named-nod under a CPOL license. 
    Script is designed to create RDA bibliographic records from JMU ETD metadata 
    Modification date 02/08/2016 
    Created by Steven W. Holloway, Metadata Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License -->
    <xsl:template match="/">
        <xsl:comment>Transformed by NamedXML2MARC_BIB.xsl
    Expects results from Excel2NamedXML.xsl, available at http://www.codeproject.com/Tips/780861/XSLT-to-transform-Excel-XML-worksheet-to-named-nod under a CPOL license.
    Script is designed to create RDA bibliographic records from JMU ETD metadata
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
        <!-- inserts leader boilerplate -->
        <marc:record>
            <marc:leader>     nam a22     Ii 4500</marc:leader>
            <marc:controlfield tag="005">
                <!-- date/time stamp in MARC format -->
                <xsl:value-of
                    select="format-dateTime(current-dateTime(),'[Y][M01][D01][H][m][s].[f,1-1]')"/>
            </marc:controlfield>
            <!-- 007 boilerplate -->
            <marc:controlfield tag="007">cr</marc:controlfield>
            <!-- creates date stamp in YYMMDD format, with "t" dates derived from embargo_date and publication_date -->
            <marc:controlfield tag="008"><xsl:value-of
                    select="format-date(current-date(),'[Y,2-2][M01][D01]')"/>t<xsl:analyze-string
                        select="embargo_date" regex="(^\d{{4}})">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
                <xsl:analyze-string select="publication_date" regex="(^\d{{4}})">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                    <!-- 008 boilerplate with "vau" MARC geographic code and "bm" (bibliography, thesis) posiition 24-25 -->
                </xsl:analyze-string>vau       bm  000 0 eng d</marc:controlfield>
            <xsl:choose>
                <!-- selects and inserts ARK identifier in 024 if available, strips out .pdf extension,otherwise skips this step -->
                <xsl:when test="arks/text()">
                    <marc:datafield tag="024" ind1="8" ind2=" ">
                        <marc:subfield code="a">
                            <xsl:analyze-string select="arks" regex="\.pdf$"><xsl:non-matching-substring><xsl:value-of select="."></xsl:value-of></xsl:non-matching-substring></xsl:analyze-string> 
                        </marc:subfield>
                    </marc:datafield>
                </xsl:when>
            </xsl:choose>
            <marc:datafield tag="040" ind1=" " ind2=" ">
                <!-- 040 JMU boilerplate -->
                <marc:subfield code="a">VMC</marc:subfield>
                <marc:subfield code="b">eng</marc:subfield>
                <marc:subfield code="e">rda</marc:subfield>
                <marc:subfield code="c">VMC</marc:subfield>
            </marc:datafield>
            <!-- 049 boilerplate -->
            <marc:datafield tag="049" ind1=" " ind2=" ">
                <marc:subfield code="a">VMCI</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="090" ind1=" " ind2=" ">
                <!-- 090 Local Call number must be added manually -->
                <marc:subfield code="a">[TODO]</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="100" ind1="1" ind2=" ">
                <!-- selects preferred_name if available, or assembles author1 elements in inverted form, with "dissertant" relator -->
                <!-- adds an unwanted space between the first name and punctuation; "fixes" lead to deleted middle initials -->
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
                            <xsl:analyze-string select="preferred_name" regex="^[A-z].*\s"><xsl:matching-substring><xsl:value-of select="."/>.</xsl:matching-substring></xsl:analyze-string>
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
                                        select="author1_fname"/>,</xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>
                </marc:subfield>
                <marc:subfield code="e">dissertant.</marc:subfield>
            </marc:datafield>
            <!-- generates 245 from "title" with 2nd indicator set by "the" "an" or "a" -->
            <xsl:variable name="indicator2" as="xs:integer">
                <xsl:choose>
                    <xsl:when test="title[starts-with(.,'The ')]">4</xsl:when>
                    <xsl:when test="title[starts-with(.,'An ')]">3</xsl:when>
                    <xsl:when test="title[starts-with(.,'A ')]">2</xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <marc:datafield tag="245" ind1="1" ind2="{$indicator2}"><!-- creates subfield "b" upon encountering a colon; otherwise generates subfield "a"-->
                <xsl:choose>
                <xsl:when test="title[contains(.,':')]"><marc:subfield code="a"><xsl:analyze-string select="title" regex=":.*$"><xsl:non-matching-substring><xsl:value-of select="."/> : </xsl:non-matching-substring></xsl:analyze-string></marc:subfield>
                    <marc:subfield code="b"><xsl:analyze-string select="title" regex="^.*:\s"><xsl:non-matching-substring><xsl:value-of select="."></xsl:value-of> /</xsl:non-matching-substring></xsl:analyze-string></marc:subfield></xsl:when><xsl:otherwise><marc:subfield code="a">
                        <xsl:value-of select="title"/> /</marc:subfield></xsl:otherwise>
            </xsl:choose>
                <!-- use preferred_name for statement of responsibility or assembles elements from author1 in uninverted order -->
                <marc:subfield code="c"><xsl:choose>
                        <xsl:when test="preferred_name/text()">
                            <xsl:value-of select="preferred_name"/>.</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="author1_mname/text()"><xsl:value-of select="author1_fname"></xsl:value-of><xsl:text> </xsl:text><xsl:value-of
                                        select="author1_mname"></xsl:value-of><xsl:text> </xsl:text><xsl:value-of
                                        select="author1_lname"/>.</xsl:when><xsl:otherwise><xsl:value-of select="author1_fname"></xsl:value-of><xsl:text> </xsl:text><xsl:value-of
                                        select="author1_lname"></xsl:value-of>.</xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></marc:subfield>
            </marc:datafield>
            <marc:datafield tag="264" ind1=" " ind2="1">
                <!-- 264 boilerplate, with subfield c date derived from publication_date -->
                <marc:subfield code="a">[Harrisonburg, Virginia] : </marc:subfield>
                <marc:subfield code="b">James Madison University,</marc:subfield>
                <marc:subfield code="c">
                    <xsl:analyze-string select="publication_date" regex="(^\d{{4}})">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>.</xsl:matching-substring></xsl:analyze-string></marc:subfield>
            </marc:datafield>
            <marc:datafield tag="264" ind1=" " ind2="4">
                <!-- 264 copyright derived from embargo_date, with copyright symbol -->
                <marc:subfield code="c">&#xa9;<xsl:analyze-string select="embargo_date"
                        regex="(^\d{{4}})">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </marc:subfield>
            </marc:datafield>
            <marc:datafield tag="300" ind1=" " ind2=" ">
                <!-- 300 template; complete when thesis is available -->
                <marc:subfield code="a">1 online resource [TODO]</marc:subfield>
                <marc:subfield code="b"></marc:subfield>
                <marc:subfield code="c"></marc:subfield>
            </marc:datafield>
            <!-- RDA content, media and carrier boilerplate -->
            <marc:datafield tag="336" ind1=" " ind2=" ">
                <marc:subfield code="a">text</marc:subfield>
                <marc:subfield code="b">txt</marc:subfield>
                <marc:subfield code="2">rdacontent</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="337" ind1=" " ind2=" ">
                <marc:subfield code="a">computer</marc:subfield>
                <marc:subfield code="b">c</marc:subfield>
                <marc:subfield code="2">rdamedia</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="a">online resource</marc:subfield>
                <marc:subfield code="b">cr</marc:subfield>
                <marc:subfield code="2">rdacarrier</marc:subfield>
            </marc:datafield>
            <!-- RDA digital file boilerplate for PDF -->
            <marc:datafield tag="347" ind1=" " ind2=" ">
                <marc:subfield code="a">text file</marc:subfield>
                <marc:subfield code="b">pdf</marc:subfield>
                <marc:subfield code="2">rda</marc:subfield>
            </marc:datafield>
            <!-- language of expression - default "eng" needs to be changed if thesis is not in English -->
            <marc:datafield tag="377" ind1=" " ind2=" ">
                <marc:subfield code="a">eng</marc:subfield>
            </marc:datafield>
            <!-- genre boilerplate -->
            <marc:datafield tag="380" ind1=" " ind2=" ">
                <marc:subfield code="a">Dissertations, Academic</marc:subfield>
                <marc:subfield code="2">fast</marc:subfield>
            </marc:datafield>
            <!-- converts "degree" string into abbreviation for subfield b -->
            <marc:datafield tag="502" ind1=" " ind2=" ">
                <marc:subfield code="b">
                    <xsl:choose>
                        <xsl:when test="degree_name='Master of Science (MS)'">M.S.</xsl:when>
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
                    </xsl:choose>
                </marc:subfield>
                <marc:subfield code="c">James Madison University</marc:subfield>
                <!-- publication_date -->
                <marc:subfield code="d">
                    <xsl:analyze-string select="publication_date" regex="(^\d{{4}})">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>.</xsl:matching-substring></xsl:analyze-string></marc:subfield>
            </marc:datafield>
            <!-- bibliographic boilerplate - should be removed if no bibliography present -->
            <marc:datafield tag="504" ind1=" " ind2=" ">
                <marc:subfield code="a">Includes bibliographic references.</marc:subfield>
            </marc:datafield>
            <!-- embargo date inserted in YYYY-MM-DD format -->
            <marc:datafield tag="506" ind1="1" ind2=" ">
                <marc:subfield code="a">Embargo date: <xsl:analyze-string select="embargo_date"
                        regex="(^\d{{4}}-\d{{2}}-\d{{2}})">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>.</xsl:matching-substring></xsl:analyze-string></marc:subfield>
            </marc:datafield>
            <marc:datafield tag="516" ind1=" " ind2=" ">
                <marc:subfield code="a">Electronic text.</marc:subfield>
            </marc:datafield>
            <!-- inserts abstract, catches strings of HTML coding -->
            <marc:datafield tag="520" ind1=" " ind2=" ">
                <marc:subfield code="a"><xsl:analyze-string select="abstract" regex="&lt;p&gt;">
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="&lt;/p&gt;">
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="&lt;em&gt;">
                                    <xsl:non-matching-substring>
                                        <xsl:analyze-string select="." regex="&lt;/em&gt;">
                                            <xsl:non-matching-substring>
                                                <xsl:analyze-string select="." regex="&lt;strong&gt;">
                                                    <xsl:non-matching-substring>
                                                        <xsl:analyze-string select="." regex="&lt;/strong&gt;">
                                                            <xsl:non-matching-substring>
                                                                <xsl:analyze-string select="." regex="&#xD;">
                                                                    <xsl:non-matching-substring>
                                                                        <xsl:analyze-string select="." regex="&lt;br /&gt;">
                                                                            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
                                                                        </xsl:analyze-string>
                                                                    </xsl:non-matching-substring>
                                                                </xsl:analyze-string>
                                                            </xsl:non-matching-substring>
                                                        </xsl:analyze-string>
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
                </marc:subfield>
            </marc:datafield>
            <marc:datafield tag="538" ind1=" " ind2=" ">
                <marc:subfield code="a">System requirements: PDF reader.</marc:subfield>
            </marc:datafield>
            <!-- inserts dissertant-supplied keywords into 590 local note -->
            <marc:datafield tag="590" ind1=" " ind2=" ">
                <marc:subfield code="a">Dissertant-supplied keywords: <xsl:value-of
                        select="keywords"/></marc:subfield>
            </marc:datafield>
            <!-- inserts dissertant-supplied disciplines (required by bepress) into 590 local note -->
            <marc:datafield tag="590" ind1=" " ind2=" ">
                <marc:subfield code="a">Dissertant-supplied disciplines: <xsl:value-of
                        select="disciplines"/></marc:subfield>
            </marc:datafield>
            <!-- genre boilerplate -->
            <marc:datafield tag="655" ind1=" " ind2="4">
                <marc:subfield code="a">E-theses.</marc:subfield>
            </marc:datafield>
            <!-- format boilerplate -->
            <marc:datafield tag="655" ind1=" " ind2="7">
                <marc:subfield code="a">E-books.</marc:subfield>
                <marc:subfield code="2">aat</marc:subfield>
            </marc:datafield>
            <!-- genre boilerplate -->
            <marc:datafield tag="655" ind1=" " ind2="7">
                <marc:subfield code="a">Dissertations, Academic.</marc:subfield>
                <marc:subfield code="2">fast</marc:subfield>
            </marc:datafield>
            <!-- inserts inverted name of advisor1 with honorifics stripped out -->
            <!-- adds an unwanted space between the given name(s) and punctuation; "fixes" lead to deleted middle initials -->
            <marc:datafield tag="700" ind1="1" ind2=" ">
                <marc:subfield code="a">
                                    <xsl:choose><xsl:when test="advisor1/text()">
                        <xsl:analyze-string select="advisor1" regex="((^Dr\.\s)|(^Dr\s)|(^Prof\.\s)|(,\sPhD))">
                        <xsl:non-matching-substring>
                            <xsl:analyze-string select="." regex="^[A-z].*\s">
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="."/>, </xsl:non-matching-substring></xsl:analyze-string>
                            <xsl:analyze-string select="." regex="^[A-z].*\s">
                                <xsl:matching-substring>
                                    <xsl:value-of select="."/>,</xsl:matching-substring></xsl:analyze-string></xsl:non-matching-substring>
                            </xsl:analyze-string></xsl:when></xsl:choose>
                            </marc:subfield>
                <marc:subfield code="e">thesis advisor.</marc:subfield>
            </marc:datafield>
            <!-- inserts inverted name of advisor2, if present, with honorifics stripped out -->
            <!-- adds an unwanted space between the given name(s) and punctuation; "fixes" lead to deleted middle initials -->
            <xsl:choose>
                <xsl:when test="advisor2/text()">
                    <marc:datafield tag="700" ind1="1" ind2=" ">
                        <marc:subfield code="a">
                            <xsl:analyze-string select="advisor2" regex="((^Dr\.\s)|(^Dr\s)|(^Prof\.\s)|(,\sPhD))">
                                <xsl:non-matching-substring>
                                    <xsl:analyze-string select="." regex="^[A-z].*\s">
                                        <xsl:non-matching-substring>
                                            <xsl:value-of select="."/>, </xsl:non-matching-substring></xsl:analyze-string>
                                    <xsl:analyze-string select="." regex="^[A-z].*\s">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="."/>,</xsl:matching-substring></xsl:analyze-string></xsl:non-matching-substring>
                            </xsl:analyze-string></marc:subfield>
                        <marc:subfield code="e">thesis advisor.</marc:subfield>
                    </marc:datafield>
                </xsl:when>
            </xsl:choose>
            <!-- 710 boilerplate with degree-granting institution MARC relator term -->
            <marc:datafield tag="710" ind1="2" ind2=" ">
                <marc:subfield code="a">James Madison University,</marc:subfield>
                <marc:subfield code="e">degree granting institution.</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="710" ind1="2" ind2=" ">
                <marc:subfield code="a">James Madison University.</marc:subfield>
                <!-- department name, which will need to be checked against JMU authority files -->
                <marc:subfield code="b">
                    <xsl:value-of select="department"/>.</marc:subfield>
            </marc:datafield>
            <xsl:choose>
                <xsl:when test="calc_url/text()">
            <marc:datafield tag="856" ind1="4" ind2="0">
                <!-- inserts JMU Scholarly Commons URL, with boilerplate message, when calc_url is present -->
                <marc:subfield code="z">Full-text of dissertation on the Internet (JMU users only)</marc:subfield>
                <marc:subfield code="u">
                    <xsl:value-of select="calc_url"/>
                </marc:subfield>
            </marc:datafield>
                </xsl:when>
            </xsl:choose>
        </marc:record>
    </xsl:template>
</xsl:stylesheet>
