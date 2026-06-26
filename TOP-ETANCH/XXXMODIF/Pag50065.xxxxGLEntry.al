namespace Top.Top;

using Microsoft.Finance.GeneralLedger.Ledger;

page 50065 "xxxxG/L Entry"
{
    ApplicationArea = All;
    Caption = 'xxxxG/L Entry';
    PageType = List;
    SourceTable = "G/L Entry";
    UsageCategory = None;
    Permissions = tabledata "G/L Entry" = rimd;

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
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the amount of the G/L Entry.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the debit amount of the G/L Entry.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the credit amount of the G/L Entry.';
                }
                field("Source Currency Amount"; Rec."Source Currency Amount")
                {
                    ToolTip = 'Specifies the source currency amount of the G/L Entry.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    editable = true;

                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    editable = true;

                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    editable = true;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    editable = true;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    editable = true;

                }
            }
        }
    }
}
