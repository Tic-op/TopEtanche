namespace Top.Top;

using Microsoft.Purchases.History;

page 50002 "xxxxPurch. Inv. Line"
{
    ApplicationArea = All;
    Caption = 'xxxxPurch. Inv. Line';
    PageType = List;
    SourceTable = "Purch. Inv. Line";
    UsageCategory = Lists;
    Permissions = tabledata "Purch. Inv. Line" = rimd;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the line number of the posted invoice.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the date the purchase header was posted.';
                }

            }
        }
    }
}
