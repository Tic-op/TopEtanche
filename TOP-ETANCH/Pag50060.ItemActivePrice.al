namespace Top.Top;

using Microsoft.Pricing.PriceList;

page 50060 "Item Active Price "
{
    ApplicationArea = All;
    Caption = 'Item Active Price ';
    PageType = ListPart;
    SourceTable = "Price List Line";
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Price List Code"; rec."Price List Code") { StyleExpr = StyleLine; Editable = false; ApplicationArea = All; }
                field("Source Type"; rec."Source Type") { StyleExpr = StyleLine; Editable = false; ApplicationArea = All; }
                field("Source No."; rec."Source No.") { StyleExpr = StyleLine; Editable = false; ApplicationArea = All; }


                field("Market Price"; rec."Prix marché")
                {
                    Caption = 'Marché';
                    Style = Ambiguous;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;

                }
                field("%Mrg "; Rec."MrgMarché")

                {
                    Caption = '%';
                    Style = Ambiguous;
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        //       CurrPage.Update();
                    end;

                }


                field("Standard Sales Price"; rec."Prix standard")
                {
                    Caption = 'Standard';
                    Style = StrongAccent;
                    ApplicationArea = All;
                    Editable = false;


                }
                field("%Mrg"; Rec.MrgStd)
                {
                    Caption = '%';
                    Style = StrongAccent;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        //    CurrPage.Update();
                    end;

                }
                field("Unit Price"; rec."Unit Price") { Style = Strong; Editable = false; ApplicationArea = All; }

                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleLine;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.SetRange("Asset Type", rec."Asset Type"::Item);
        rec.SetFilter(Status, '%1|%2', rec.Status::Active, rec.Status::Draft);
    end;

    trigger OnAfterGetRecord()
    begin
        IF rec.Status = rec.Status::Active then
            StyleLine := 'Favorable'
        else
            StyleLine := 'Unfavorable';
    end;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if rec.findfirst then
            repeat
                if rec.Status <> Rec.Status::Active then
                    Error('Impossible de quitter cette page. Vous devez activer certains prix...');
            until rec.next = 0;


    end;

    var
        StyleLine: Text;
}
