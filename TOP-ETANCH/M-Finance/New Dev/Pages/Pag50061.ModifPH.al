namespace Top.Top;

using Microsoft.Bank.Payment;

page 50061 "Modif PH"
{
    ApplicationArea = All;
    Caption = 'Modif PH';
    PageType = List;
    SourceTable = "Payment Header";
    UsageCategory = Lists;
    Permissions = tabledata "Payment Header" = rimd;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the payment header.';
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ToolTip = 'Specifies the payment class used when creating this payment slip.';
                }
                field("Status No."; Rec."Status No.")
                {
                    ToolTip = 'Specifies the value of the Status No. field.', Comment = '%';
                }
                field("Status Name"; Rec."Status Name")
                {
                    ToolTip = 'Specifies the status the payment is in.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the number of the account that the payments will be transferred to/from.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
            }
        }
    }
}
