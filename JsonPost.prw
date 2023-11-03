#include "PROTHEUS.CH"
#include "TOTVS.CH"
#INCLUDE "restful.ch"

user Function jsonPost()
    Local cTitulo := "Json Teste"
    Local nTimeOut := 120
    Local aHeadOut := {}
    Local oJson := ""
    Local cJsonString := ""

    Local cUrl := "http://192.168.2.212:4001/novo-funcionario"
    oJanela := TDialog():New(0, 0, 600, 600, cTitulo, , , , , CLR_WHITE, CLR_MAGENTA, , , .T.)

    oJson := JsonObject():New()

    oJson["name"] := "Enzo"
    oJson["role"] := "006"
    oJson["company"] := "Calpar"
    oJson["phone1"] := "(42)999064350"
    oJson["phone2"] := "(42)999064351"
    oJson["recipientEmail"] := "ruancalpar@gmail.com"

    cJsonString := oJson:toJson()
    
    AAdd( aHeadOut, 'Content-Type: application/json')
    
    HttpPost(cUrl,/*cGetParms*/,cJsonString,nTimeOut,aHeadOut,/*cHeaderGet*/)

    oSay := TSay():New(1, 20 , { ||cTitulo}  , oJanela, , , , , , .T., , , 400, 300, , , , , ,)
    
    oJanela:Activate(,,,.T.) 
return
