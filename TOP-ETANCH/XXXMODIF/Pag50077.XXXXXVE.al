namespace Top.Top;

using Microsoft.Inventory.Ledger;

page 50077 XXXXXVE
{
    ApplicationArea = All;
    Caption = 'XXXXXVE';
    PageType = List;
    SourceTable = "Value Entry";
    UsageCategory = none;
    Permissions = tabledata "Value Entry" = rimd;

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
