namespace Top.Top;

using Microsoft.Purchases.History;

page 50111 "xxxxxxPurch. Inv. Header"
{
    ApplicationArea = All;
    Caption = 'xxxxxxPurch. Inv. Header';
    PageType = List;
    SourceTable = "Purch. Inv. Header";
    UsageCategory = Lists;
    Permissions = tabledata "Purch. Inv. Header" = rimd;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the date the purchase header was posted.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the date on the invoice document.';
                }
            }
        }
    }
}
