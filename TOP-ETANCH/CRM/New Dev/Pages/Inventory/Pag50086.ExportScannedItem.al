namespace TopEtanch.TopEtanch;
using Microsoft.Warehouse.ADCS;

page 50086 ExportScannedItem
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'exportScannedItem';
    DelayedInsert = true;
    EntityName = 'ExportScannedItem';
    EntitySetName = 'ExportScannedItems';
    PageType = API;
    SourceTable = "Inventory Entry";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId) { }
                field(inventoryNo; Rec."Inventory No.")
                {
                    Caption = 'N° inventaire';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'N° article';
                }
                field(itemBarCode; Rec."Item Bar Code")
                {
                    Caption = 'CAB article';
                }

                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantité';
                }
                field(countNo; Rec."Count No.")
                {
                    Caption = 'N° comptage';
                }
                field(terminalID; Rec."Terminal ID")
                {
                    Caption = 'Terminal ID';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        BarreCode: Record "Item Identifier TICOP";
    begin

    end;
}
