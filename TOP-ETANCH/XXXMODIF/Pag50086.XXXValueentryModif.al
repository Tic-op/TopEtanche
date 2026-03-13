namespace Top.Top;

using Microsoft.Inventory.Ledger;

page 50086 XXXValueentryModif
{
    ApplicationArea = All;
    Caption = 'XXXValueentryModif';
    PageType = List;
    SourceTable = "Value Entry";
    UsageCategory = None;
    Permissions = tabledata "Value Entry" = rm;
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
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("Item No."; Rec."Item No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the item that this value entry is linked to.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the date the purchase header was posted.';
                }
                field("Item Ledger Entry Type"; Rec."Item Ledger Entry Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the type of item ledger entry that caused this value entry.';
                }
                field("Source No."; Rec."Source No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the source document that the entry originates from.';
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
                field("Location Code"; Rec."Location Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for the location of the item that the entry is linked to.';
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Inventory Posting Group field.', Comment = '%';
                }
                field("Source Posting Group"; Rec."Source Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the posting group for the item, customer, or vendor for the item entry that this value entry is linked to.';
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the item ledger entry that this value entry is linked to.';
                }
                field("Valued Quantity"; Rec."Valued Quantity")
                {
                    editable = true;
                    ToolTip = 'Specifies the quantity that the adjusted cost and the amount of the entry belongs to.';
                }
                field("Item Ledger Entry Quantity"; Rec."Item Ledger Entry Quantity")
                {
                    editable = true;
                    ToolTip = 'Specifies the average cost calculation.';
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    editable = true;
                    ToolTip = 'Specifies how many units of the item are invoiced by the posting that the value entry line represents.';
                }
                field("Cost per Unit"; Rec."Cost per Unit")
                {
                    editable = true;
                    ToolTip = 'Specifies the cost for one base unit of the item in the entry.';
                }
                field("Sales Amount (Actual)"; Rec."Sales Amount (Actual)")
                {
                    editable = true;
                    ToolTip = 'Specifies the price of the item for a sales entry.';
                }
                field("Item Register No."; Rec."Item Register No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Item Register No. field.', Comment = '%';
                }
                field("SIFT Bucket No."; Rec."SIFT Bucket No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the SIFT Bucket No. field.', Comment = '%';
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    editable = true;
                    ToolTip = 'Specifies which salesperson or purchaser is linked to the entry.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the total discount amount of this value entry.';
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
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Applies-to Entry field.', Comment = '%';
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
                field("Source Type"; Rec."Source Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the source type that applies to the source number that is shown in the Source No. field.';
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                    editable = true;
                    ToolTip = 'Specifies the cost of invoiced items.';
                }
                field("Cost Posted to G/L"; Rec."Cost Posted to G/L")
                {
                    editable = true;
                    ToolTip = 'Specifies the amount that has been posted to the general ledger.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Drop Shipment field.', Comment = '%';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the date on the invoice document.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    editable = true;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Cost Amount (Actual) (ACY)"; Rec."Cost Amount (Actual) (ACY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the cost of the items that have been invoiced, if you post in an additional reporting currency.';
                }
                field("Cost Posted to G/L (ACY)"; Rec."Cost Posted to G/L (ACY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the amount that has been posted to the general ledger if you post in an additional reporting currency.';
                }
                field("Cost per Unit (ACY)"; Rec."Cost per Unit (ACY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the cost of one unit of the item in the entry.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    editable = true;
                    ToolTip = 'Specifies what type of document was posted to create the value entry.';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the line number of the line on the posted document that corresponds to the value entry.';
                }
                field("VAT Reporting Date"; Rec."VAT Reporting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Date field.', Comment = '%';
                }
                field("Order Type"; Rec."Order Type")
                {
                    editable = true;
                    ToolTip = 'Specifies which type of order that the entry was created in.';
                }
                field("Order No."; Rec."Order No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the order that created the entry.';
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Order Line No. field.', Comment = '%';
                }
                field("Expected Cost"; Rec."Expected Cost")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Expected Cost field.', Comment = '%';
                }
                field("Item Charge No."; Rec."Item Charge No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the item charge number of the value entry.';
                }
                field("Valued By Average Cost"; Rec."Valued By Average Cost")
                {
                    editable = true;
                    ToolTip = 'Specifies if the adjusted cost for the inventory decrease is calculated by the average cost of the item at the valuation date.';
                }
                field("Partial Revaluation"; Rec."Partial Revaluation")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Partial Revaluation field.', Comment = '%';
                }
                field(Inventoriable; Rec.Inventoriable)
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Inventoriable field.', Comment = '%';
                }
                field("Valuation Date"; Rec."Valuation Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the valuation date from which the entry is included in the average cost calculation.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the type of value described in this entry.';
                }
                field("Variance Type"; Rec."Variance Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the type of variance described in this entry.';
                }
                field("Purchase Amount (Actual)"; Rec."Purchase Amount (Actual)")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Purchase Amount (Actual) field.', Comment = '%';
                }
                field("Purchase Amount (Expected)"; Rec."Purchase Amount (Expected)")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Purchase Amount (Expected) field.', Comment = '%';
                }
                field("Sales Amount (Expected)"; Rec."Sales Amount (Expected)")
                {
                    editable = true;
                    ToolTip = 'Specifies the expected price of the item for a sales entry, which means that it has not been invoiced yet.';
                }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)")
                {
                    editable = true;
                    ToolTip = 'Specifies the expected cost of the items, which is calculated by multiplying the Cost per Unit by the Valued Quantity.';
                }
                field("Cost Amount (Non-Invtbl.)"; Rec."Cost Amount (Non-Invtbl.)")
                {
                    editable = true;
                    ToolTip = 'Specifies the non-inventoriable cost, that is an item charge assigned to an outbound entry.';
                }
                field("Cost Amount (Expected) (ACY)"; Rec."Cost Amount (Expected) (ACY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the expected cost of the items in the additional reporting currency.';
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; Rec."Cost Amount (Non-Invtbl.)(ACY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the non-inventoriable cost, that is an item charge assigned to an outbound entry in the additional reporting currency.';
                }
                field("Expected Cost Posted to G/L"; Rec."Expected Cost Posted to G/L")
                {
                    editable = true;
                    ToolTip = 'Specifies the expected cost amount that has been posted to the interim account in the general ledger.';
                }
                field("Exp. Cost Posted to G/L (ACY)"; Rec."Exp. Cost Posted to G/L (ACY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Exp. Cost Posted to G/L (ACY) field.', Comment = '%';
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
                field("Job No."; Rec."Job No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the project that the value entry relates to.';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the related project task.';
                }
                field("Job Ledger Entry No."; Rec."Job Ledger Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the project ledger entry that the value entry relates to.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Variant Code field.', Comment = '%';
                }
                field(Adjustment; Rec.Adjustment)
                {
                    editable = true;
                    ToolTip = 'Specifies this field was inserted by the Adjust Cost - Item Entries batch job, if it contains a check mark.';
                }
                field("Average Cost Exception"; Rec."Average Cost Exception")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Average Cost Exception field.', Comment = '%';
                }
                field("Capacity Ledger Entry No."; Rec."Capacity Ledger Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the entry number of the item ledger entry that this value entry is linked to.';
                }
                field("Type"; Rec."Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the type of value entry when it relates to a capacity entry.';
                }
                field("No."; Rec."No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code explaining why the item was returned.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    editable = true;
                    ToolTip = 'Specifies the description of the item that this value entry is linked to.  Analysis mode must be used for sorting and filtering on this field.';
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
