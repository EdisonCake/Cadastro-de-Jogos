#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} User Function CADJOGO
    Rotina para cadastro em MVC de jogos do usuário
    @type  Function
    @author Edison Cake
    @since 21/03/2023
    /*/
User Function CADJOGO() 
    local cAlias    := 'ZZJ'
    local cTitle    := 'Cadastro de Jogos'
    local oBrowse   := FwmBrowse():New()

    oBrowse:SetAlias(cAlias)
    oBrowse:SetDescription(cTitle)
    
    oBrowse:DisableDetails()
    oBrowse:DisableReport()

    // Primeira Legenda
    oBrowse:AddLegend('ZZJ_PLAT == "001"',  'BLUE',     "Plataforma PlayStation",       '1')
    oBrowse:AddLegend('ZZJ_PLAT == "002"',  'RED',      "Plataforma Nintendo",          '1')  
    oBrowse:AddLegend('ZZJ_PLAT == "003"',  'GREEN',    "Plataforma XBox",              '1')
    oBrowse:AddLegend('ZZJ_PLAT == "004"',  'BLACK',    "Plataforma PC/Computador",     '1')
    oBrowse:AddLegend('ZZJ_PLAT == "005"',  'PINK',     "Plataforma Mobile/Celular",    '1')

    // Segunda Legenda
    oBrowse:AddLegend('ZZJ_JOGADO == "SIM"', "GREEN", "Jogo já jogado",  "2")
    oBrowse:AddLegend('ZZJ_JOGADO == "NÃO"', "RED",   "Jogo não jogado", "2")

    oBrowse:Activate()
Return 

Static Function MenuDef()
    local aRotina := {}

    ADD OPTION aRotina TITLE "Inspect Game" ACTION 'VIEWDEF.CADJOGO' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "New Game"     ACTION 'VIEWDEF.CADJOGO' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Update Game"  ACTION 'VIEWDEF.CADJOGO' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Obliterate"   ACTION 'VIEWDEF.CADJOGO' OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
    local oModel    := MPFormModel():New("CADJOGO_M")
    local oStruZZJ  := FWFormStruct(1, "ZZJ")

    local bMessage  := { |oModel| ActOpt(oModel), .T. }

    oModel:AddFields("ZZJMASTER",,oStruZZJ)
    oModel:SetDescription("Cadastro de Jogos")

    oModel:SetPrimaryKey({"ZZJ_COD"})
    oModel:SetVldActivate(bMessage)
Return oModel

Static Function ViewDef()
    local oModel    := FwLoadModel('CADJOGO')
    local oStruZZJ  := FwFormStruct(2, "ZZJ")
    local oView     := FwFormView():New()

    oView:SetModel(oModel)
    oView:AddField("VIEW_ZZJ",  oStruZZJ,  "ZZJMASTER")

    oView:CreateVerticalBox("JOGOS", 80)
    oView:CreateVerticalBox("BOTOES", 20)

    oView:SetOwnerView("VIEW_ZZJ",  "JOGOS")

    oView:EnableTitleView("VIEW_ZZJ",  "Cadastro de Jogos")

    oView:AddOtherObjects("Motivacional", { |oPanel| Motiv(oPanel) })
    oView:SetOwnerView('Motivacional', 'BOTOES')
Return oView

User Function zOpcoes()
    local aArea     := GetArea() 
    local cOpcao    := ""
    
    cOpcao += "001=PLAYSTATION;"
    cOpcao += "002=NINTENDO;"
    cOpcao += "003=XBOX;"
    cOpcao += "004=PC;"
    cOpcao += "005=CELULAR;"

    RestArea(aArea)
Return cOpcao

Static Function Motiv(oPanel)
    local oButton

    oButton := TButton():New(001, 001, 'Frases Motivacionais...?', oPanel, { || Frase() }, 145, 020)
    oButton:SetCSS("QPushButton {color: #008B8B;}")
Return

Static Function Frase()
    local nCount := Randomize(1, 10)

    local aFrases:= {{1, '<b>"Hmmm..."</b>'                         + CRLF + 'Villager, Minecraft'},;
                     {2, '<b>"Mamma mia!"</b>'                      + CRLF + 'Mario, Super Mario Bros.'},;
                     {3, '<b>"Hey, listen!"</b>'                    + CRLF + 'Navi the fairy, The Legend of Zelda'},;
                     {4, '<b>"HEY YAAA!"</b>'                       + CRLF + 'Fox McCloud (Hey Ya Fox), Star Fox 64'},;
                     {5, '<b>"Leon! HELP!"</b>'                     + CRLF + 'Ashley, Resident Evil 4'},;
                     {6, '<b>"Ah, sh*t, here we go again..."</b>'   + CRLF + 'Carl Johnson, Grand Theft Auto: San Andreas'},;
                     {7, '<b>"Cousin! Lets go bowling!"</b>'        + CRLF + 'Roman, Grand Theft Auto IV'},;
                     {8, '<b>"You tell me exactly what you want, and Ill very careful explain you why it cannot be!"</b>'     + CRLF + 'Simeon Yetarian, Grand Theft Auto V'},;
                     {9, '<b>"Muwahahahaha"</b>'                    + CRLF + 'Bowser, Super Mario Bros.'},;
                     }

    FwAlertSuccess(aFrases[nCount, 2], "A frase do dia é:")
Return

Static Function ActOpt(oModel)
    nOperation := oModel:GetOperation()

    If nOperation == MODEL_OPERATION_INSERT
        MsgAlert("Welcome to game insert!" + CRLF + "You're about to insert a game!", "Insert Coin!")
    elseif nOperation == MODEL_OPERATION_UPDATE
        MsgAlert("You're about to update " + ZZJ_TITULO + ".", "Welcome Stranger!")
    elseif nOperation == MODEL_OPERATION_DELETE
        MsgAlert("This operation cannot be undone!", "Warning!")
    endif

Return 
