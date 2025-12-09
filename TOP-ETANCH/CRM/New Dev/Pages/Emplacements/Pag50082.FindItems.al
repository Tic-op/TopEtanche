namespace TOPETANCH.TOPETANCH;

using Microsoft.Warehouse.ADCS;
using Microsoft.Inventory.Item;

page 50082 FindItems
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'findItems';
    DelayedInsert = true;
    EntityName = 'FindItems';
    EntitySetName = 'FindItems';
    PageType = API;
    SourceTable = "Item Identifier TICOP";

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
                /* field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                } */
                field(uniteDeVente; unit)
                {
                    Caption = 'Unité de vente';
                }

            }
        }
    }
    var
        Unit: Text[100];

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        if Item.Get(rec."Item No.") then
            Unit := Item."Sales Unit of Measure";
    end;
}
