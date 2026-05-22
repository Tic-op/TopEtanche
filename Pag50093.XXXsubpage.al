namespace Top.Top;

using Microsoft.Sales.History;

page 50093 "XXX sub page"
{
    ApplicationArea = All;
    Caption = 'XXX sub page';
    PageType = List;
    SourceTable = "Sales Invoice Line";
    UsageCategory = Administration;
    Permissions = tabledata "Sales Invoice Line" = m;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("VAT %"; Rec."VAT %")
                {
                    Editable = true;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    Editable = true;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    Editable = true;
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Line Amount"; Rec."Line Amount")
                {
                }
            }
        }
    }
}
