namespace Top.Top;

using Microsoft.Sales.Receivables;

page 50062 ModifCLE
{
    ApplicationArea = All;
    Caption = 'ModifCLE';
    PageType = List;
    SourceTable = "Cust. Ledger Entry";
    UsageCategory = Lists;
    Permissions = tabledata "Cust. Ledger Entry" = rimd;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the sales document number.';
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                { }
            }
        }
    }
}
