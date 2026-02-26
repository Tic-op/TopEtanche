namespace Top.Top;

using Microsoft.Purchases.Payables;

page 50069 XXXXDVLE
{
    ApplicationArea = All;
    Caption = 'XXXXDVLE';
    PageType = List;
    SourceTable = "Detailed Vendor Ledg. Entry";
    UsageCategory = Lists;
    Permissions = tabledata "Detailed Vendor Ledg. Entry" = rimd;

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

            }
        }
    }
}
