namespace Top.Top;

using Microsoft.Finance.GeneralLedger.Ledger;

page 50087 XXXGL_Entry_Modif
{
    ApplicationArea = All;
    Caption = 'XXXGL_Entry_Modif';
    PageType = List;
    SourceTable = "G/L Entry";
    UsageCategory = None;
    Permissions = tabledata "G/L Entry" = RM;
    ModifyAllowed = true;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the account that the entry has been posted to.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the date the purchase header was posted.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the document type that the entry belongs to.';
                }
                field("Document No."; Rec."Document No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field(Description; Rec.Description)
                {
                    editable = true;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.';
                }
                field(Amount; Rec.Amount)
                {
                    editable = true;
                    ToolTip = 'Specifies the Amount of the entry.';
                }
                field("Source Currency Amount"; Rec."Source Currency Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the source currency amount for general ledger entries.';
                }
                field("Source Currency VAT Amount"; Rec."Source Currency VAT Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the source currency VAT amount for general ledger entries.';
                }
                field("Source Currency Code"; Rec."Source Currency Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the source currency code for general ledger entries.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field("User ID"; Rec."User ID")
                {
                    editable = true;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the System-Created Entry field.', Comment = '%';
                }
                field("Prior-Year Entry"; Rec."Prior-Year Entry")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Prior-Year Entry field.', Comment = '%';
                }
                field("Job No."; Rec."Job No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the related project.';
                }
                field(Quantity; Rec.Quantity)
                {
                    editable = true;
                    ToolTip = 'Specifies the quantity that was posted on the entry.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the amount of VAT that is included in the total amount.';
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the Business Unit code of the company from which the entry was consolidated.';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the type of transaction.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate ledger account according to the general posting setup.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate ledger account according to the general posting setup.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Transaction No. field.', Comment = '%';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the date on the invoice document.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the entry''s external document number, such as a vendor''s invoice number.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the source type that applies to the source number that is shown in the Source No. field.';
                }
                field("Source No."; Rec."Source No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the source document that the entry originates from.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Tax Area Code field.', Comment = '%';
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Tax Liable field.', Comment = '%';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Tax Group Code field.', Comment = '%';
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Use Tax field.', Comment = '%';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the general ledger entry that is posted if you post in an additional reporting currency.';
                }
                field("Add.-Currency Debit Amount"; Rec."Add.-Currency Debit Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Add.-Currency Debit Amount field.', Comment = '%';
                }
                field("Add.-Currency Credit Amount"; Rec."Add.-Currency Credit Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Add.-Currency Credit Amount field.', Comment = '%';
                }
                field("Close Income Statement Dim. ID"; Rec."Close Income Statement Dim. ID")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Close Income Statement Dim. ID field.', Comment = '%';
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.';
                }
                field(Reversed; Rec.Reversed)
                {
                    editable = true;
                    ToolTip = 'Specifies if the entry has been part of a reverse transaction (correction) made by the Reverse function.';
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the correcting entry. If the field Specifies a number, the entry cannot be reversed again.';
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the original entry that was undone by the reverse transaction.';
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    editable = true;
                    ToolTip = 'Specifies the name of the account that the entry has been posted to.';
                }
                field("Journal Templ. Name"; Rec."Journal Templ. Name")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
                }
                field("VAT Reporting Date"; Rec."VAT Reporting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the VAT date on the VAT entry. This is either the date that the document was created or posted, depending on your setting on the General Ledger Setup page.';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    editable = true;
                    ToolTip = 'Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for Shortcut Dimension 3, which is one of dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for Shortcut Dimension 4, which is one of dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for Shortcut Dimension 5, which is one of dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for Shortcut Dimension 6, which is one of dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for Shortcut Dimension 7, which is one of dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for Shortcut Dimension 8, which is one of dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Last Dim. Correction Entry No."; Rec."Last Dim. Correction Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Last Dim. Correction Entry No. field.', Comment = '%';
                }
                field("Last Dim. Correction Node"; Rec."Last Dim. Correction Node")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Last Dim. Correction Node field.', Comment = '%';
                }
                field("Dimension Changes Count"; Rec."Dimension Changes Count")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Count of Dimension Changes field.', Comment = '%';
                }
                field("Allocation Account No."; Rec."Allocation Account No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Allocation Account No. field.', Comment = '%';
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Prod. Order No. field.', Comment = '%';
                }
                field("FA Entry Type"; Rec."FA Entry Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the fixed asset entry.';
                }
                field("FA Entry No."; Rec."FA Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the fixed asset entry.';
                }
                field(Comment; Rec.Comment)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                }
                field("Non-Deductible VAT Amount"; Rec."Non-Deductible VAT Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the amount of the transaction for which VAT is not applied, due to the type of goods or services purchased.';
                }
                field("Non-Deductible VAT Amount ACY"; Rec."Non-Deductible VAT Amount ACY")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Non-Deductible VAT Amount ACY field.', Comment = '%';
                }
                field("Src. Curr. Non-Ded. VAT Amount"; Rec."Src. Curr. Non-Ded. VAT Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the amount in source currency of the transaction for which VAT is not applied, due to the type of goods or services purchased.';
                }
                field("Account Id"; Rec."Account Id")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Account Id field.', Comment = '%';
                }
                field("Last Modified DateTime"; Rec."Last Modified DateTime")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Last Modified DateTime field.', Comment = '%';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Applies-to ID field.', Comment = '%';
                }
                field(Letter; Rec.Letter)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Letter field.', Comment = '%';
                }
                field("Letter Date"; Rec."Letter Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Letter Date field.', Comment = '%';
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
