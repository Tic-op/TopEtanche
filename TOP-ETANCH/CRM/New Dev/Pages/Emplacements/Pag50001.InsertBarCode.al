namespace Top.Top;
using Microsoft.Inventory.Item;

page 50001 "Insert BarCode"
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'insertBarCode';
    DelayedInsert = true;
    EntityName = 'Barcode';
    EntitySetName = 'Barcodes';
    PageType = API;
    SourceTable = "Item Identifier TICOP";

    ODataKeyFields = SystemId;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        item: Record Item;
    begin
        if item.get(rec."Item No.") then
            rec."Unit of Measure Code" := item."Base Unit of Measure";
    end;
}
