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
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                { }

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
                    Caption = 'Quantité';
                }

                field(LocationCode; Rec."Location Code")
                {
                    Caption = 'Magasin';
                }

                field(BinCode; Rec."Bin Code")
                {
                    Caption = 'Emplacement';
                }

                field("BarreCode"; BarreCode) //BarreCode de l'article n'est pas filterable donc j'ai crée api finditem pour permettre la recherche avec BarreCode
                {
                    Caption = 'Code Barre';
                }

                field(fournisseur; fournisseur)
                {
                    Caption = 'Fournisseur';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        item: Record Item;
        itemIdentifier: Record "Item Identifier TICOP";
    begin
        if item.Get(Rec."Item No.") then begin
            fournisseur := item."Vendor No.";
            Description := item.Description;

            itemIdentifier.SetRange("Item No.", Rec."Item No.");
            if itemIdentifier.FindFirst() then
                BarreCode := itemIdentifier.Code
            else
                BarreCode := '';
        end;
    end;

    var
        fournisseur: Text;
        Description: Text;
        BarreCode: Text;
}
