namespace Top.Top;

using Microsoft.Sales.History;

page 50088 XXXXSalesInvoiceLinesModif
{
    ApplicationArea = All;
    Caption = 'XXXXSalesInvoiceLinesModif';
    PageType = List;
    SourceTable = "Sales Invoice Line";
    UsageCategory = None;
    Permissions = tabledata "Sales Invoice Line" = rm;
    ModifyAllowed = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the customer.';
                }
                field("Document No."; Rec."Document No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the invoice number.';
                }
                field("Line No."; Rec."Line No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the line type.';
                }
                field("No."; Rec."No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the location in which the invoice line was registered.';
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Posting Group field.', Comment = '%';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    editable = true;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
                }
                field(Description; Rec.Description)
                {
                    editable = true;
                    ToolTip = 'Specifies the name of the item or general ledger account, or some descriptive text.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    editable = true;
                    ToolTip = 'Specifies information in addition to the description.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    editable = true;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                }
                field(Quantity; Rec.Quantity)
                {
                    editable = true;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    editable = true;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    editable = true;
                    ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';
                }
                field("VAT %"; Rec."VAT %")
                {
                    editable = true;
                    ToolTip = 'Specifies the VAT %.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    editable = true;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                }
                field(Amount; Rec.Amount)
                {
                    editable = true;
                    ToolTip = 'Specifies the line''s net amount.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    editable = true;
                    ToolTip = 'Specifies the net amount, including VAT, for this line.';
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    editable = true;
                    ToolTip = 'Specifies if the invoice line is included when the invoice discount is calculated.';
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    editable = true;
                    ToolTip = 'Specifies the gross weight of one unit of the item. In the sales statistics window, the gross weight on the line is included in the total gross weight of all the lines for the particular sales document.';
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    editable = true;
                    ToolTip = 'Specifies the net weight of one unit of the item. In the sales statistics window, the net weight on the line is included in the total net weight of all the lines for the particular sales document.';
                }
                field("Units per Parcel"; Rec."Units per Parcel")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of units per parcel of the item. In the sales statistics window, the number of units per parcel on the line helps to determine the total number of units for all the lines for the particular sales document.';
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    editable = true;
                    ToolTip = 'Specifies the volume of one unit of the item. In the sales statistics window, the volume of one unit of the item on the line is included in the total volume of all the lines for the particular sales document.';
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied to.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Customer Price Group field.', Comment = '%';
                }
                field("Job No."; Rec."Job No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the related project.';
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Work Type Code field.', Comment = '%';
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Shipment No. field.', Comment = '%';
                }
                field("Shipment Line No."; Rec."Shipment Line No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Shipment Line No. field.', Comment = '%';
                }
                field("Order No."; Rec."Order No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the order number this line is associated with.';
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Order Line No. field.', Comment = '%';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
                }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the total calculated invoice discount amount for the line.';
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Drop Shipment field.', Comment = '%';
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
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Calculation Type field.', Comment = '%';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Transaction Type field.', Comment = '%';
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Transport Method field.', Comment = '%';
                }
                field("Attached to Line No."; Rec."Attached to Line No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Attached to Line No. field.', Comment = '%';
                }
                field("Exit Point"; Rec."Exit Point")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Exit Point field.', Comment = '%';
                }
                field("Area"; Rec."Area")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Area field.', Comment = '%';
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Transaction Specification field.', Comment = '%';
                }
                field("Tax Category"; Rec."Tax Category")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Tax Category field.', Comment = '%';
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    editable = true;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                }
                field("VAT Clause Code"; Rec."VAT Clause Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Clause Code field.', Comment = '%';
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
                field("Blanket Order No."; Rec."Blanket Order No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the blanket order that the record originates from.';
                }
                field("Blanket Order Line No."; Rec."Blanket Order Line No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the blanket order line that the record originates from.';
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Base Amount field.', Comment = '%';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Unit Cost field.', Comment = '%';
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the System-Created Entry field.', Comment = '%';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Difference field.', Comment = '%';
                }
                field("VAT Identifier"; Rec."VAT Identifier")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Identifier field.', Comment = '%';
                }
                field("IC Partner Ref. Type"; Rec."IC Partner Ref. Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the IC Partner Ref. Type field.', Comment = '%';
                }
                field("IC Partner Reference"; Rec."IC Partner Reference")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the IC Partner Reference field.', Comment = '%';
                }
                field("Prepayment Line"; Rec."Prepayment Line")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Prepayment Line field.', Comment = '%';
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("IC Item Reference No."; Rec."IC Item Reference No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the IC Item Reference No. field.', Comment = '%';
                }
                field("Pmt. Discount Amount"; Rec."Pmt. Discount Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Pmt. Discount Amount field.', Comment = '%';
                }
                field("Line Discount Calculation"; Rec."Line Discount Calculation")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Line Discount Calculation field.', Comment = '%';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the related project task.';
                }
                field("Job Contract Entry No."; Rec."Job Contract Entry No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the entry number of the project planning line that the sales line is linked to.';
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
                }
                field("Allocation Account No."; Rec."Allocation Account No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Allocation Account No. field.', Comment = '%';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Qty. per Unit of Measure field.', Comment = '%';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    editable = true;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Quantity (Base) field.', Comment = '%';
                }
                field("FA Posting Date"; Rec."FA Posting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the FA Posting Date field.', Comment = '%';
                }
                field("Depreciation Book Code"; Rec."Depreciation Book Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Depreciation Book Code field.', Comment = '%';
                }
                field("Depr. until FA Posting Date"; Rec."Depr. until FA Posting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Depr. until FA Posting Date field.', Comment = '%';
                }
                field("Duplicate in Depreciation Book"; Rec."Duplicate in Depreciation Book")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Duplicate in Depreciation Book field.', Comment = '%';
                }
                field("Use Duplication List"; Rec."Use Duplication List")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Use Duplication List field.', Comment = '%';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Responsibility Center field.', Comment = '%';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Item Category Code field.', Comment = '%';
                }
                field(Nonstock; Rec.Nonstock)
                {
                    editable = true;
                    ToolTip = 'Specifies that this item is a catalog item.';
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Purchasing Code field.', Comment = '%';
                }
                field("Item Reference No."; Rec."Item Reference No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the referenced item number.';
                }
                field("Item Reference Unit of Measure"; Rec."Item Reference Unit of Measure")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Unit of Measure (Item Ref.) field.', Comment = '%';
                }
                field("Item Reference Type"; Rec."Item Reference Type")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Item Reference Type field.', Comment = '%';
                }
                field("Item Reference Type No."; Rec."Item Reference Type No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Item Reference Type No. field.', Comment = '%';
                }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied from.';
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    editable = true;
                    ToolTip = 'Specifies the code explaining why the item was returned.';
                }
                field("Price Calculation Method"; Rec."Price Calculation Method")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Price Calculation Method field.', Comment = '%';
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Allow Line Disc. field.', Comment = '%';
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Customer Disc. Group field.', Comment = '%';
                }
                field("Price description"; Rec."Price description")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Price description field.', Comment = '%';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    editable = true;
                    ToolTip = 'Specifies the name of the customer.';
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
