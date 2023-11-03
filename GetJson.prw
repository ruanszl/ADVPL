#include "PROTHEUS.CH"
#include "TOTVS.CH"
#INCLUDE "restful.ch"

user Function jsonGet()
    Local cTitulo := "Json Teste"
    Local cUrl := "https://jsonplaceholder.typicode.com/todos/10"
    Local cJson := ""
    Local oJson := ""
    Local cId := ""
    Local cTitle := ""

    oJanela := TDialog():New(0, 0, 600, 600, cTitulo, , , , , CLR_WHITE, CLR_MAGENTA, , , .T.)
    
    cJson := HttpGet(cUrl,/*cGetParms*/,/*nTimeOut*/,/*aHeadStr*/,/*cHeaderGet*/)
    oJson := JsonObject():New() // é criado um novo objeto Json 
    
    oJson:FromJson(cJson) // converte  a string recebida em json. O retorno do metodo HttpGet traz uma string, por isso é necessario transformar em um objeto Json

    if ! Empty(oJson:getJsonObject('id')) // É necessário passar o campo do Json exatamente como esta, Letra maiuscula também da problema
        cId := oJson:getJsonObject('id')
    endIf
    if ! Empty(oJson:getJsonObject('title'))
        cTitle := oJson:getJsonObject('title')
    endIf

    oSay := TSay():New(1, 20 , { ||cId}  , oJanela, , , , , , .T., , , 400, 300, , , , , ,)
    oSay := TSay():New(10, 20 , { ||cTitle}  , oJanela, , , , , , .T., , , 400, 300, , , , , ,)
    
    oJanela:Activate(,,,.T.) 
return
