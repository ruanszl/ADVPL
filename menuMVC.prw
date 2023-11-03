#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#include "fwmbrowse.ch"

/*/
     Gera um menu em MVC, possiblita fazer o crud na tabela szu, facilmente customizavel para qualquer tabela
     Mostra exemplos de validação de usuário
     
/*/
User Function menuMVC()
    Local oBrowse := FwLoadBrw("menuMVC")
    oBrowse:Activate()
Return

//Esta função basicamente cria uma tela e seta um alias, coloca uma descrição e diz os campos que serão utilizadas, neste exemplo estou usando a tabela SZU 
Static Function BrowseDef()
    Local oBrowse := FwmBrowse():New()

    oBrowse:SetAlias("SZU")
    oBrowse:SetDescription("Tela MVC - Modelo 1 - Cadastro Tabela SZU")
    oBrowse:SetOnlyFields({"ZU_FILIAL", "ZU_CODIGO", "ZU_FORMULA"})
return oBrowse

// Função que cria o menu com as opções de vizualizar, incluir e etc.
Static Function MenuDef()
     Local aMenu := {}

     ADD OPTION aMenu Title 'Visualizar' Action 'VIEWDEF.menuMVC' OPERATION 2 ACCESS 0
     ADD OPTION aMenu Title 'Incluir'    Action 'VIEWDEF.menuMVC' OPERATION 3 ACCESS 0
     ADD OPTION aMenu Title 'Alterar'    Action 'VIEWDEF.menuMVC' OPERATION 4 ACCESS 0
     ADD OPTION aMenu Title 'Imprimir'   Action 'VIEWDEF.menuMVC' OPERATION 8 ACCESS 0
    
Return aMenu
    
Static Function ModelDef()
     Local oModel := NIL
     Local oStructSZU := FWFormStruct( 1, "SZU" )

     oModel := MPFormModel():New("form")
     oModel:AddFields("FORMSZU",,oStructSZU)
     oModel:SetPrimarykey({"ZU_FILIAL" , "ZU_CODIGO"})
     oModel:SetDescription("Modelo de dados MVC")
     oModel:GetModel("FORMSZU"):SetDescription("Formulario de Cadastro SZU")

Return oModel 

Static Function ViewDef()
     Local oView := NIL
     Local oModel := FWLoadModel( "menuMVC" )
     Local oStructSZU := FWFormStruct( 2, "SZU" )
                                                         
     if (!(FWIsAdmin( __cUserID ) .or. __cUserID == "000052") .and. (INCLUI == .T. .or. ALTERA == .T.))
          Help(NIL, NIL,"Sem permissão", NIL, "Usuário sem autorização para a rotina [menuMVC]", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Entre em contato com o administrador do sistema"})
          return NIL 
     endIf

     oView := FwFormView():New()
     oView:SetModel( oModel )
     oView:AddField("VIEWSZU", oStructSZU, "FORMSZU")
     oView:CreateHorizontalbox("TELASZU", 100)
     oView:EnableTitleView("VIEWSZU","VIZUALIZAÇÃO DAS menuMVC")
     oView:SetCloseOnOk({|| .T.})
     oView:SetOwnerView("VIEWSZU","TELASZU")
Return oView
