namespace Top.Top;

using Microsoft.Finance.VAT.Ledger;

page 50066 "xxxxxVAT Entry"
{
    ApplicationArea = All;
    Caption = 'xxxxxVAT Entry';
    PageType = List;
    SourceTable = "VAT Entry";
    UsageCategory = None;
    Permissions = tabledata "VAT Entry" = rimd;

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
                    editable = true;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the date on the invoice document.';
                    editable = true;
                }
            }
        }
    }
}
