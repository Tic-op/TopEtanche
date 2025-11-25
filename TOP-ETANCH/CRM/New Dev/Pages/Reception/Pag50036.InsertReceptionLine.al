namespace TopAPI.TopAPI;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;

page 50036 InsertReceptionLine
{
    APIGroup = 'InsertRece';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'insertPurchLine';
    DelayedInsert = true;
    EntityName = 'insertPurchLine';
    EntitySetName = 'insertPurchLines';
    PageType = API;
    SourceTable = "Purchase Line";
    ODataKeyFields = SystemId;


    layout
    {
        area(Content)
        {

            repeater(General)
            {

                field(SystemId; Rec.SystemId) { }
                field("Document_No"; Rec."Document No.") { }
                field("No"; Rec."No.") { }
                field(Description; Rec.Description) { }
                field(Quantity; Rec.Quantity) { }



            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;
}


