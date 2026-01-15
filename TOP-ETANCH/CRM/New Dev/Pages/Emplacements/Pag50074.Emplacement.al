namespace TopEtanch.TopEtanch;


using Microsoft.Warehouse.Structure;
using Microsoft.Sales.Document;

page 50074 Emplacement
{
    ApplicationArea = All;
    Caption = 'Emplacement';
    PageType = ListPart;
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
                /* field(Description; Rec.Description)
                {
                    Caption = 'Description';
                } */
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
