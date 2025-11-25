namespace TopEtanch.TopEtanch;
using Microsoft.Inventory.Item;

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
                field("Article"; Rec."Item No.") { }
                field("Description"; Rec."Item Description") { }
                field("Unite"; Rec."Unité") { }
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


        if item.Get(Rec."Item No.") then begin
            Rec."Item Description" := item."Description";
            rec."Unité" := item."Base Unit of Measure";
        end;
        exit(true);
    end;

    trigger OnAfterGetRecord()

    begin
        if item.Get(Rec."Item No.") then begin
            Rec."Item Description" := item."Description";
            rec."Unité" := item."Base Unit of Measure";
        end;
    end;

    var
        item: Record Item;

}



