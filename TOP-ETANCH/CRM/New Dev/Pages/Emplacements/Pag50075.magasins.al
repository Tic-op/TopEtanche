namespace TopEtanch.TopEtanch;


using Microsoft.Inventory.Location;
using Microsoft.Sales.Document;

page 50075 magasins
{
    ApplicationArea = All;
    Caption = 'magasins';
    PageType = Card;
    SourceTable = Location;
    // UsageCategory = Administration;


    layout
    {
        area(Content)
        {

            field(SystemId; Rec.SystemId)
            { }
            field("Stock"; Rec."Valeur Stock")
            {
                /* Trigger OnValidate()
                  begin
                      Rec.CalcFields("Valeur Stock");
                  end; */
            }
            field(Code; Rec.Code)
            { }


            part(emplacement; Emplacement)
            {
                ApplicationArea = all;
                //EntitySetName = 'emplacement';
                //EntityName = 'emplacement';
                SubPageLink = "Location Code" = field("Code");
                UpdatePropagation = Both;

            }

        }
    }

    var
        article: code[20];

    Trigger OnAfterGetRecord()

    begin
        Rec.CalcFields("Valeur Stock");
    end;
}
