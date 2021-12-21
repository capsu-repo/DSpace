<xsl:stylesheet
        xmlns="http://di.tamu.edu/DRI/1.0/"
        xmlns:dri="http://di.tamu.edu/DRI/1.0/"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
        xmlns:str="http://exslt.org/strings"
        exclude-result-prefixes="xsl dri i18n dim">

    <xsl:output indent="yes"/>

    <xsl:template name="journalCitation">
        <div class="simple-item-view-description item-page-field-wrapper table">
            <h5>
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-citation</i18n:text>
            </h5>
            <xsl:choose>
                <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                    <span>
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:variable name="firstname">
                                <xsl:value-of select="substring-after(., ', ')"/>
                            </xsl:variable>
                            <xsl:if test="position() = last() and position() != 1 and position() &lt; 8">
                                <xsl:text disable-output-escaping="yes">&amp;amp; </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() &lt;=6 or position() = last()">
                                <xsl:choose>
                                    <xsl:when test="substring($firstname,2,1) = '.'">
                                        <xsl:value-of select="concat(str:tokenize(.,','), ', ')"/>
                                        <xsl:for-each select="str:tokenize($firstname,'.')">
                                            <xsl:value-of select="concat(.,'.')"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains($firstname, '-')">
                                        <xsl:value-of select="concat(str:tokenize(.,','), ', ')"/>
                                        <xsl:for-each select="str:tokenize($firstname,'-')">
                                            <xsl:if test="position() = 1">
                                                <xsl:value-of select="concat(substring(.,1,1),'.')"/>
                                            </xsl:if>
                                            <xsl:if test="position() = last()">
                                                <xsl:value-of select="concat('-',substring(.,1,1),'.')"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat(str:tokenize(.,','), ', ')"/>
                                        <xsl:for-each select="str:tokenize($firstname,' ')">
                                            <xsl:choose>
                                                <xsl:when
                                                        test="contains($firstname,'Jr.') or contains($firstname,'III')">
                                                    <xsl:choose>
                                                        <xsl:when test="position() = last()">
                                                            <xsl:value-of select="substring(.,1,3)"/>
                                                        </xsl:when>
                                                        <xsl:when test="position() != 1">
                                                            <xsl:value-of select="concat(substring(.,1,1),'.,')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="concat(substring(.,1,1),'.')"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat(substring(.,1,1),'.')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="position() = 7 and position() != last()">
                                <xsl:text disable-output-escaping="yes">... &amp;amp; </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() != last() and position() &lt; 7">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </span>
                </xsl:when>
                <xsl:when test="dim:field[@element='contributor'][@qualifier='corporateauthor']">
                    <xsl:for-each select="dim:field[@element='contributor'][@qualifier='corporateauthor']">
                        <xsl:if test="position() = last() and position() != 1 and position() &lt; 8">
                            <xsl:text>&amp;amp;amp; </xsl:text>
                        </xsl:if>
                        <span>
                            <xsl:copy-of select="node()"/>
                        </span>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Anon.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <span class="date">
                <xsl:value-of
                        select="concat(' (',substring(dim:field[@element='date' and @qualifier='issued']/node(),1,4),').')"/>
                <xsl:text> </xsl:text>
            </span>
            <span>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='title']">
                        <xsl:variable name="item-title">
                            <xsl:value-of select="dim:field[@element='title'][1]/node()"/>
                            <xsl:text>. </xsl:text>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="contains($item-title,'..')">
                                <xsl:value-of select="substring-before($item-title,'..')"/>
                                <xsl:text>. </xsl:text>
                            </xsl:when>
                            <xsl:when test="contains($item-title,'?.')">
                                <xsl:value-of select="substring-before($item-title,'?.')"/>
                                <xsl:text>? </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$item-title"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:call-template name="journal"/>
        </div>
    </xsl:template>

    <xsl:template name="journal">
        <xsl:if test="dim:field[@element='citation' and @qualifier='journaltitle']">
            <span>
                <xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
                <xsl:copy-of select="dim:field[@element='citation' and @qualifier='journaltitle']"/>
                <xsl:text disable-output-escaping="yes">&lt;/i&gt;</xsl:text>
                <xsl:text>, </xsl:text>
                <xsl:if test="dim:field[@element='citation' and @qualifier='volume']">
                    <xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
                    <xsl:value-of select="dim:field[@element='citation' and @qualifier='volume']"/>
                    <xsl:text disable-output-escaping="yes">&lt;/i&gt;</xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='citation' and @qualifier='issue']">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="dim:field[@element='citation' and @qualifier='issue']"/>
                        <xsl:text>), </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>, </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="dim:field[@element='citation' and @qualifier='firstpage']">
                    <xsl:value-of select="dim:field[@element='citation' and @qualifier='firstpage']"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='citation' and @qualifier='lastpage']">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="dim:field[@element='citation' and @qualifier='lastpage']"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>
            </span>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>