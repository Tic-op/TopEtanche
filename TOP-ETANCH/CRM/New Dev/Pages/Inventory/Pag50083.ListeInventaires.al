namespace TopEtanch.TopEtanch;

page 50083 ListeInventaires
{
    APIGroup = 'TopEtanch';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'listeInventaires';
    DelayedInsert = true;
    EntityName = 'ListeInventaires';
    EntitySetName = 'ListeInventaire';
    PageType = API;
    SourceTable = "Inventory header";
    ODataKeyFields = SystemId;
    SourceTableView = where(Status = const(Lancé));
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SystemId; Rec.SystemId) { }
                field(No; Rec."No") { }
                field(Type; Rec.Type) { }
                field("LocationCode"; Rec."Location code") { }
                field("CreationDate"; Rec."Creation Date") { }
                field("ReleaseDate"; Rec."Release Date") { }
                field("UserCreator"; Rec.UserCreator) { }
                field("SujetInventaire"; Rec."Sujet inventaire") { }
                field("CountNo"; Rec."Count No.") { }
                //field("ValeurAInventorier"; Rec."Valeur art. à inventorier") { }
                //field("ValeurInventories"; Rec."Valeur art. inventoriés") { }
            }
        }
    }
    var
        InvLine: Record "Inventroy Line";



}
