namespace Top.Top;

using Microsoft.Finance.VAT.Ledger;
using Microsoft.Inventory.Ledger;

page 50089 XXXVat_entry_Modif
{
    ApplicationArea = All;
    Caption = 'XXXVat_entry_Modif';
    PageType = List;
    SourceTable = "VAT Entry";
    UsageCategory = None;
    Permissions = tabledata "VAT Entry" = rm;
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
                field("Posting Date"; Rec."Posting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the date the purchase header was posted.';
                }
                field("Document No."; Rec."Document No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field(Base; Rec.Base)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Base field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Calculation Type field.', Comment = '%';
                }
                field("Bill-to/Pay-to No."; Rec."Bill-to/Pay-to No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Bill-to/Pay-to No. field.', Comment = '%';
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the EU 3-Party Trade field.', Comment = '%';
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
                field("Reason Code"; Rec."Reason Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                }
                field("Closed by Entry No."; Rec."Closed by Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Closed by Entry No. field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Country/Region Code field.', Comment = '%';
                }
                field("Internal Ref. No."; Rec."Internal Ref. No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Internal Ref. No. field.', Comment = '%';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Transaction No. field.', Comment = '%';
                }
                field("Unrealized Amount"; Rec."Unrealized Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Unrealized Amount field.', Comment = '%';
                }
                field("Unrealized Base"; Rec."Unrealized Base")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Unrealized Base field.', Comment = '%';
                }
                field("Remaining Unrealized Amount"; Rec."Remaining Unrealized Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Remaining Unrealized Amount field.', Comment = '%';
                }
                field("Remaining Unrealized Base"; Rec."Remaining Unrealized Base")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Remaining Unrealized Base field.', Comment = '%';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
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
                field("Tax Jurisdiction Code"; Rec."Tax Jurisdiction Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Tax Jurisdiction Code field.', Comment = '%';
                }
                field("Tax Group Used"; Rec."Tax Group Used")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Tax Group Used field.', Comment = '%';
                }
                field("Tax Type"; Rec."Tax Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Tax Type field.', Comment = '%';
                }
                field("Tax on Tax"; Rec."Tax on Tax")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Tax on Tax field.', Comment = '%';
                }
                field("Sales Tax Connection No."; Rec."Sales Tax Connection No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Sales Tax Connection No. field.', Comment = '%';
                }
                field("Unrealized VAT Entry No."; Rec."Unrealized VAT Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Unrealized VAT Entry No. field.', Comment = '%';
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
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Additional-Currency Amount field.', Comment = '%';
                }
                field("Additional-Currency Base"; Rec."Additional-Currency Base")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Additional-Currency Base field.', Comment = '%';
                }
                field("Add.-Currency Unrealized Amt."; Rec."Add.-Currency Unrealized Amt.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Add.-Currency Unrealized Amt. field.', Comment = '%';
                }
                field("Add.-Currency Unrealized Base"; Rec."Add.-Currency Unrealized Base")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Add.-Currency Unrealized Base field.', Comment = '%';
                }
                field("VAT Base Discount %"; Rec."VAT Base Discount %")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Base Discount % field.', Comment = '%';
                }
                field("Add.-Curr. Rem. Unreal. Amount"; Rec."Add.-Curr. Rem. Unreal. Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Add.-Curr. Rem. Unreal. Amount field.', Comment = '%';
                }
                field("Add.-Curr. Rem. Unreal. Base"; Rec."Add.-Curr. Rem. Unreal. Base")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Add.-Curr. Rem. Unreal. Base field.', Comment = '%';
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Difference field.', Comment = '%';
                }
                field("Add.-Curr. VAT Difference"; Rec."Add.-Curr. VAT Difference")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Add.-Curr. VAT Difference field.', Comment = '%';
                }
                field("Ship-to/Order Address Code"; Rec."Ship-to/Order Address Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Ship-to/Order Address Code field.', Comment = '%';
                }
                field("Document Date"; Rec."Document Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the date on the invoice document.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.', Comment = '%';
                }
                field(Reversed; Rec.Reversed)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Reversed by Entry No. field.', Comment = '%';
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Reversed Entry No. field.', Comment = '%';
                }
                field("EU Service"; Rec."EU Service")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the EU Service field.', Comment = '%';
                }
                field("Base Before Pmt. Disc."; Rec."Base Before Pmt. Disc.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Base Before Pmt. Disc. field.', Comment = '%';
                }
                field("Source Currency VAT Amount"; Rec."Source Currency VAT Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Source Currency VAT Amount field.', Comment = '%';
                }
                field("Source Currency VAT Base"; Rec."Source Currency VAT Base")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Source Currency VAT Base field.', Comment = '%';
                }
                field("Source Currency Code"; Rec."Source Currency Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Source Currency Code field.', Comment = '%';
                }
                field("Source Currency Factor"; Rec."Source Currency Factor")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Source Currency Factor field.', Comment = '%';
                }
                field("Journal Templ. Name"; Rec."Journal Templ. Name")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Realized Amount"; Rec."Realized Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Realized Amount field.', Comment = '%';
                }
                field("Realized Base"; Rec."Realized Base")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Realized Base field.', Comment = '%';
                }
                field("Add.-Curr. Realized Amount"; Rec."Add.-Curr. Realized Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Add.-Curr. Realized Amount field.', Comment = '%';
                }
                field("Add.-Curr. Realized Base"; Rec."Add.-Curr. Realized Base")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Add.-Curr. Realized Base field.', Comment = '%';
                }
                field("G/L Acc. No."; Rec."G/L Acc. No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the G/L Account No. field.', Comment = '%';
                }
                field("VAT Reporting Date"; Rec."VAT Reporting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Date field.', Comment = '%';
                }
                field("Non-Deductible VAT %"; Rec."Non-Deductible VAT %")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Non-Deductible VAT % field.', Comment = '%';
                }
                field("Non-Deductible VAT Base"; Rec."Non-Deductible VAT Base")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Non-Deductible VAT Base field.', Comment = '%';
                }
                field("Non-Deductible VAT Amount"; Rec."Non-Deductible VAT Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Non-Deductible VAT Amount field.', Comment = '%';
                }
                field("Non-Deductible VAT Base ACY"; Rec."Non-Deductible VAT Base ACY")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Non-Deductible VAT Base ACY field.', Comment = '%';
                }
                field("Non-Deductible VAT Amount ACY"; Rec."Non-Deductible VAT Amount ACY")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Non-Deductible VAT Amount ACY field.', Comment = '%';
                }
                field("Non-Deductible VAT Diff."; Rec."Non-Deductible VAT Diff.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Non-Deductible VAT Difference field.', Comment = '%';
                }
                field("Non-Deductible VAT Diff. ACY"; Rec."Non-Deductible VAT Diff. ACY")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Non-Deductible VAT Difference ACY field.', Comment = '%';
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
