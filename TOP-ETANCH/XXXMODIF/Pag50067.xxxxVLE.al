namespace Top.Top;

using Microsoft.Purchases.Payables;

page 50067 xxxxVLE
{
    ApplicationArea = All;
    Caption = 'xxxxVLE';
    PageType = List;
    SourceTable = "Vendor Ledger Entry";
    UsageCategory = None;
    Permissions = tabledata "Vendor Ledger Entry" = rimd;

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
