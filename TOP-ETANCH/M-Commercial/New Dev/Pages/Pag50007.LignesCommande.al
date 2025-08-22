namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Document;

page 50007 "Lignes Commande"
{
    ApplicationArea = All;
    Caption = 'Lignes Commande';
    PageType = ListPart;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
        }
    }

}
