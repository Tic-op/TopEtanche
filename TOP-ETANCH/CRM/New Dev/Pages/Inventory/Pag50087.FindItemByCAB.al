namespace TopEtanch.TopEtanch;
using Microsoft.Warehouse.ADCS;
using Microsoft.Inventory.Item;
using Microsoft.Warehouse.Structure;

page 50087 FindItemByCAB
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'findItemByCAB';
    DelayedInsert = true;
    EntityName = 'FindItemInv';
    EntitySetName = 'FindItemInvs';
    PageType = API;
    SourceTable = "Item Identifier TICOP";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId) { }
                field(BarreCode; Rec.Code) { }
                field("ItemNo"; Rec."Item No.") { }
                field(Description; Description) { }
                field("Unit"; Rec."Unit of Measure Code") { }
                field(Qty; Qty) { }

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
        ItemUnit: Record "Item Unit of Measure";
        InventoryHeader: Record "Inventory Header";
        InventoryLine: Record "Inventroy Line";
    begin

        if Item.Get(Rec."Item No.") then
            Description := Item.Description;

        if ItemUnit.Get(Rec."Item No.", Rec."Unit of Measure Code") then
            Qty := ItemUnit."Qty. per Unit of Measure";

    end;

    var
        Description: Text[100];
        Qty: Decimal;
        InventoryNo: Code[20];
}