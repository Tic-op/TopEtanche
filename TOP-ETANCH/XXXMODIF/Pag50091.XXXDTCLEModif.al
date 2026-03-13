namespace Top.Top;

using Microsoft.Sales.Receivables;

page 50090 XXXDTCLEModif
{
    ApplicationArea = All;
    Caption = 'XXXDTCLEModif';
    PageType = List;
    SourceTable = "Detailed Cust. Ledg. Entry";
    UsageCategory = None;

    Permissions = tabledata "Detailed Cust. Ledg. Entry" = rm;
    ModifyAllowed = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Cust. Ledger Entry No. field.', Comment = '%';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                }
                field("User ID"; Rec."User ID")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                }
                field("Source Code"; Rec."Source Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Transaction No. field.', Comment = '%';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Debit Amount (LCY) field.', Comment = '%';
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Credit Amount (LCY) field.', Comment = '%';
                }
                field("Initial Entry Due Date"; Rec."Initial Entry Due Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Initial Entry Due Date field.', Comment = '%';
                }
                field("Initial Entry Global Dim. 1"; Rec."Initial Entry Global Dim. 1")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Initial Entry Global Dim. 1 field.', Comment = '%';
                }
                field("Initial Entry Global Dim. 2"; Rec."Initial Entry Global Dim. 2")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Initial Entry Global Dim. 2 field.', Comment = '%';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.', Comment = '%';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.', Comment = '%';
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Use Tax field.', Comment = '%';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.', Comment = '%';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.', Comment = '%';
                }
                field("Initial Document Type"; Rec."Initial Document Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Initial Document Type field.', Comment = '%';
                }
                field("Applied Cust. Ledger Entry No."; Rec."Applied Cust. Ledger Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Applied Cust. Ledger Entry No. field.', Comment = '%';
                }
                field(Unapplied; Rec.Unapplied)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Unapplied field.', Comment = '%';
                }
                field("Unapplied by Entry No."; Rec."Unapplied by Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Unapplied by Entry No. field.', Comment = '%';
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Remaining Pmt. Disc. Possible field.', Comment = '%';
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Max. Payment Tolerance field.', Comment = '%';
                }
                field("Tax Jurisdiction Code"; Rec."Tax Jurisdiction Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Tax Jurisdiction Code field.', Comment = '%';
                }
                field("Application No."; Rec."Application No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Application No. field.', Comment = '%';
                }
                field("Ledger Entry Amount"; Rec."Ledger Entry Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Ledger Entry Amount field.', Comment = '%';
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Customer Posting Group field.', Comment = '%';
                }
                field("Exch. Rate Adjmt. Reg. No."; Rec."Exch. Rate Adjmt. Reg. No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Exch. Rate Adjmt. Reg. No. field.', Comment = '%';
                }
                field("Curr. Adjmt. G/L Account No."; Rec."Curr. Adjmt. G/L Account No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Curr. Adjmt. G/L Account No. field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
            }
        }
    }
}
