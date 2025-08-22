namespace TopEtanch.TopEtanch;

page 50084 InsertInvLine
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'InsertLigneInventaire';
    DelayedInsert = true;
    EntityName = 'LigneInventaire';
    EntitySetName = 'LigneInventaires';
    PageType = API;
    SourceTable = "Inventroy Line";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(SystemId; Rec.SystemId) { }
                field("Inventaire"; Rec."Inventory No.") { }
                field("Artcile"; Rec."Item No.") { }
                field("Description"; Rec."Item Description") { }
                field("Magasin"; Rec."Location Code") { }
                field("Emplacement"; Rec."Bin code") { }
                field(Inventory; Rec.Inventory) { }


            }
        }

    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        InvHeader: Record "Inventory Header";
    begin
        if not InvHeader.Get(Rec."Inventory No.") then
            Error('Inventaire introuvable pour le numéro : %1', Rec."Inventory No.");
        Rec."Count Num" := InvHeader."Count No.";
        Rec."Location Code" := InvHeader."Location Code";
        Rec."Bin Code" := InvHeader.Bin;

        exit(true);
    end;


}



