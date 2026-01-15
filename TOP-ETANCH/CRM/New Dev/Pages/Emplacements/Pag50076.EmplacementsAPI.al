namespace TopEtanch.TopEtanch;


using Microsoft.Warehouse.Structure;

page 50076 EmplacementsAPI
{
    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'emplacementsAPI';
    DelayedInsert = true;
    EntityName = 'emplacement';
    EntitySetName = 'emplacements';
    PageType = API;
    SourceTable = "Bin Content";


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId) { }
                field("Item"; Rec."Item No.") { }
                field(Qty; Rec.Quantity)
                {
                    caption = 'Quantité';
                }
                field(LocationCode; Rec."Location Code")
                {
                    Caption = 'Magasin';
                }
                field(BinCode; rec."Bin Code")
                {
                    Caption = 'Emplacement';
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Quantity);
    end;
}


