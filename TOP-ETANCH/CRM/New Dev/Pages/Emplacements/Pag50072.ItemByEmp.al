namespace PHARMATEC.PHARMATEC;

using Microsoft.Inventory.Item;
using Microsoft.Warehouse.Structure;

page 50072 ItemByEmp
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TOP_ETANCH';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'itemByEmp';
    DelayedInsert = true;
    EntityName = 'ArticleParEmp';
    EntitySetName = 'ItemByEmp';
    PageType = API;
    SourceTable = "Bin Content";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {

                }
                field("No"; Rec."Item No.")
                {
                    Caption = 'Item No';
                }
                field(Description; Description)
                {
                    Caption = 'Description';
                }
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
                field("BarreCode"; Rec."Barre Code")
                {

                }
                field(fournisseur; fournisseur)
                { }




            }
        }
    }



    trigger OnAfterGetRecord()
    var
        item: Record Item;
    begin
        item.get(rec."Item No.");
        fournisseur := item."Vendor No.";
        Description := item.Description;

    end;

    var
        fournisseur: Text;
        Description: Text;
}
