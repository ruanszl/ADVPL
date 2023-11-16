#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/
    gsaRelVen
    description: Geração de Relatorio de tabela de preços
    author: RUAN.LIMA
    since: 11/09/2023
    version: 1.0
    /*/
User Function gsaRelVen()
    Private oReport  := Nil
    Private oSecCab	 := Nil
    Private oItens   := Nil

    //Apenas a empresa 12 filial 00 terá acesso
    if cEmpAnt == "12" .and. cFilAnt == "00"
        Pergunte("GSARELVEN",.T.)

        cDe  := MV_PAR01
        cAte := MV_PAR02
        
        ReportDef()
        oReport:PrintDialog() // exibe a tela de configuração para impressão do relatorio
    else
        MSGINFO( "Empresa ou filial sem acesso ao relatorio", "Permissão negada" )
    endif

Return
/*/
    Função responsavel por criar o cabeçalho da impressão em duas sections
    /*/
Static Function ReportDef()
    oReport := TReport():New("gsaRelVen","Relatorio tabela de preço","",{|oReport| PrintReport()},"Relatorio tabela de preço")
    oSecCab := TRSection():New( oReport ,"tabela de preço")
	
	oSecCab:SetHeaderPage(.T.) //Define que imprime cabeçalho das células no topo da página
	oSecCab:SetHeaderSection(.F.) //Define que imprime cabeçalho das células na quebra de seção
    
 // TRCell():New( oParent, cName         ,cAlias,cTitle                     ,cPicture         ,nSize
	TRCell():New( oSecCab, "DA0_CODTAB"	 ,      ,"Cod. Tabela"	            ,"@!"             )
	TRCell():New( oSecCab, "DA0_DESCRI"	 ,      ,"Desc. Tabela"	            ,"@!"             )
    
    oItens := TRSection():New(oReport,"itens")

    TRCell():New( oItens, "DA1_CODPRO"	 ,      ,"Codigo do Produto"	                ,"@!"             )
    TRCell():New( oItens, "B1_DESC"	 ,          ,"Descrição Produto"	                ,"@!"             )
    TRCell():New( oItens, "DA1_PRCVEN"	 ,      ,"Preço de venda"	                    ,PesqPict("DA1","DA1_PRCVEN"))
    
    oItens :SetHeaderSection(.F.)
    oSecCab:SetPageBreak(.T.)
	oSecCab:SetTotalText(" ")	
Return
/*/
    Função responsavel por fazer as querys, 
    /*/
Static Function PrintReport()
    Local cQuery := ""
    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)	

    cQuery := "SELECT " + CRLF
    cQuery += " DA0.DA0_CODTAB " + CRLF
    cQuery += " ,DA0.DA0_DESCRI " + CRLF
    cQuery += " ,DA1.DA1_CODPRO " + CRLF
    cQuery += " ,SB1.B1_DESC" + CRLF
    cQuery += " ,DA1.DA1_PRCVEN" + CRLF
    
    cQuery += " FROM " + RetSQLName("DA0") + " DA0 " + CRLF
    cQuery += " INNER JOIN " + RetSQLName("DA1") + " DA1 ON DA1.DA1_FILIAL = DA0.DA0_FILIAL AND DA1.DA1_CODTAB = DA0.DA0_CODTAB AND DA1.D_E_L_E_T_ = '' "  + CRLF
    cQuery += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.B1_FILIAL = DA1.DA1_FILIAL AND SB1.B1_COD = DA1.DA1_CODPRO AND SB1.D_E_L_E_T_ = '' "  + CRLF
    cQuery += " WHERE DA0.D_E_L_E_T_ = '' AND DA0.DA0_CODTAB BETWEEN '"+cDe+"' AND '"+cAte+"' " + CRLF
    cQuery += " ORDER BY DA0_CODTAB "

    //MemoWrit("c:\RELATO\teste.sql",cQuery)
    //DbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"relatoriovendasgsa",.T.,.F.)

    TCQUERY cQuery NEW ALIAS "QRY"
    
    //seleciona o alias de uma area de trabalho
    DbSelectArea("QRY")
    QRY->(DbGoTop())
    
    while QRY->(!Eof())
	    cCodTabela := QRY->DA0_CODTAB //Variável para controla a tabela e gerar o section1

        oReport:SkipLine(1)
        oSection1:Init()
        oSection1:Cell("DA0_CODTAB") :SetValue(QRY->DA0_CODTAB)
	    oSection1:Cell("DA0_DESCRI") :SetValue(QRY->DA0_DESCRI)
        oSection1:Printline() //Imprime a celula por linha
        
        while QRY->DA0_CODTAB == cCodTabela //enquanto for a mesma tabela, gera section2
            oSection2:Init()
            oSection2:Cell("DA1_CODPRO") :SetValue(QRY->DA1_CODPRO)
            oSection2:Cell("B1_DESC")    :SetValue(QRY->B1_DESC)
            oSection2:Cell("DA1_PRCVEN") :SetValue(QRY->DA1_PRCVEN)
            oSection2:Printline() //Imprime a celula por linha
            QRY->(DbSkip()) // Pula pára  proxima linha
        endDo
        oSection2:Finish()
        oSection1:Finish()
  
    endDo

return
