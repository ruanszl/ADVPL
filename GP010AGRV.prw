#Include 'Protheus.ch'
#INCLUDE "restful.ch"

User Function GP010AGRV()
    Local nOparamixbB   := Paramixb[1]
    Local aObutton      := {"Sim","Não"}
    Local cTit          := "Reenvio"
    Local cMsgReenvio   := "Deseja reenviar a Assinatura de e-mail?"
    Local cMsgInclusao  := "Enviar Assinatura de e-mail?"
    Local nOp           := 0

    //verifica se a ação foi de incluir = 3, alterar = 4, excluir = 5
    if nOparamixbB == 3
        //verifica se deseja enviar a assinatura
        nOp := Aviso(cTit,cMsgInclusao,aObutton)
        if nOp == 1
            assinDigital()
        elseIf nOp == 2
            return
        endif
    elseIf nOparamixbB == 4
        nOp := Aviso(cTit,cMsgReenvio,aObutton)
        //verifica se deseja reenviar a assinatura 
        if nOp == 1
            assinDigital()
        elseIf nOp == 2
            return
        endif
    endIf
Return

static Function assinDigital()
    Local cUrl := "http://192.168.1.238:4001/novo-funcionario"

    Local cNomeCmp  := ""
    Local cDepart   := ""
    Local cFullname := ""
    Local cPhone1   := ""
    Local cPhone2   := ""
    Local cEmail    := ""

    Local nTimeOut    := 120
    Local aHeadOut    := {}
    Local oJson       := ""
    Local cJsonString := ""
    Local sPostRet    := ""
    Local cHeaderRet  := ""

    //Verifia se a empresa é a granfinale, pois nela o departamento esta correto, nas demais empresas usasse o campo centro custo
    if cCodEmp = 12
        cDepart   := alltrim(SRA->RA_DEPTO)
    else
        cDepart   := alltrim(SRA->RA_CC)
    endIf

    cNomeCmp  := alltrim(SRA->RA_NOMECMP)
    cFullname := FWSM0Util():getSM0FullName(cCodEmp, SRA->RA_FILIAL)
    cPhone1   := alltrim(SM0->M0_TEL)
    cPhone2   := alltrim(left(SM0->M0_TEL, 13)+"2") //Às vezes, é necessário fornecer dois números de telefone, mas só temos um deles registrado. Para resolver isso, foi desenvolvido um método que consiste em acrescentar o dígito "2" ao final do número de telefone existente, criando assim um número de telefone com ramal. Isso é possível porque os números de telefone seguem um padrão em que o último dígito é usado para identificar o ramal
    cEmail    := "ruancalpar@gmail.com"

    //cria um objeto json e inicia ele com as variaveis buscadas na criação do funcionario
    oJson := JsonObject():New()

    oJson[ 'name' ]           := cNomeCmp
    oJson[ 'role' ]           := cDepart
    oJson[ 'company' ]        := cFullname
    oJson[ 'phone1' ]         := cPhone1
    oJson[ 'phone2' ]         := cPhone2
    oJson[ 'recipientEmail' ] := cEmail

    // converte o objeto criado em uma variavel do tipo string que contem o json, pois o metodo HttpPost envia necessáriamente no terceiro  parametro um tipo json sendo uma string
    cJsonString := oJson:toJson()
    AAdd( aHeadOut, 'Content-Type: application/json' )

    //metodo post enviando uma string contendo um json
    sPostRet := HttpPost(cUrl,/*cGetParms*/,cJsonString,nTimeOut,aHeadOut,cHeaderRet)
    varinfo( "Header", cHeadRet )

    //veifica se o retorno foi OK
    if !empty(sPostRet)
		conout("HttpPost Ok")
		varinfo("WebPage", sPostRet)
	else
		conout("HttpPost Failed.")
	Endif

return 
