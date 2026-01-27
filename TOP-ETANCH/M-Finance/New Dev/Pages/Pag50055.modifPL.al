namespace Top.Top;

using Microsoft.Bank.Payment;

page 50055 "modif PL"
{
    ApplicationArea = All;
    Caption = 'modif PL';
    PageType = List;
    SourceTable = "Payment Line";
    UsageCategory = Lists;
    Permissions = tabledata "Payment Line" = rimd;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the payment.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the payment line''s entry number.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the total amount (including VAT) of the payment line.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the number of the account that the entry on the journal line will be posted to.';
                }
                field("Copied To No."; Rec."Copied To No.")
                {
                    ToolTip = 'Specifies the value of the Copied To No. field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the due date on the entry.';
                }
                field("Status No."; Rec."Status No.")
                {
                    ToolTip = 'Specifies the status line entry number.';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ToolTip = 'Specifies the value of the Applies-to ID field.', Comment = '%';
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ToolTip = 'Specifies the value of the Applies-to Doc. No. field.', Comment = '%';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Drawee Reference"; Rec."Drawee Reference")
                {
                    ToolTip = 'Specifies the file reference which will be used in the electronic payment (ETEBAC) file.';
                }
                field(Posted; Rec.Posted)
                { }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Modify)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Refresh the page to show the latest data.';
                trigger OnAction()
                var
                    PL: Record "Payment Line";

                begin
                    pl.SetFilter(PL."No.", 'CC2600017');

                    if pl.FindFirst() then begin

                        repeat
                            pl.Posted := true;
                            pl.Modify(false);
                            Commit();
                        until pl.Next() = 0;
                        Message('Payment Line modified successfully.');

                    end
                    else
                        Message('Payment Line not found.');

                end;
            }
        }
    }

}
