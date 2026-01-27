
namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Item;

page 50080 ListItemByEmp
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'listItemByEmp';
    DelayedInsert = true;
    EntityName = 'entityName';
    EntitySetName = 'entitySetName';
    PageType = API;
    SourceTable = "Bin Content";

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
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Code magasin';
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Code emplacement';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Article';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantité';
                }
                field(Description; Description)
                {
                    Caption = 'Description';
                }
                field("BarreCode"; Rec."Barre Code")
                {

                }

            }
        }
    }
    var
        Description: Text[100];

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        if Item.Get(rec."Item No.") then
            Description := Item.Description;
    end;



}
