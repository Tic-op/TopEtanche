namespace Top.Top;

using Microsoft.Sales.History;

page 50085 XXXXSalesInvoiceLine
{
    ApplicationArea = All;
    Caption = 'XXXXSalesInvoiceLine';
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
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
                }
                field("Document No."; Rec."Document No.")
                {

                }
                field("No."; Rec."No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    editable = true;
                    ToolTip = 'Specifies the name of the item or general ledger account, or some descriptive text.';
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
                field("Line Discount %"; Rec."Line Discount %")
                {
                    editable = true;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
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
                field("Line Amount"; Rec."Line Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }

                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                }
                field("Line Discount Calculation"; Rec."Line Discount Calculation")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Line Discount Calculation field.', Comment = '%';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }

                field("Shipment No."; Rec."Shipment No.")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Shipment No. field.', Comment = '%';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the Unit Cost field.', Comment = '%';
                }

                field("VAT %"; Rec."VAT %")
                {
                    editable = true;
                    ToolTip = 'Specifies the VAT %.';
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    editable = true;
                    ToolTip = 'Specifies the value of the VAT Base Amount field.', Comment = '%';
                }
            }
        }
    }
}
