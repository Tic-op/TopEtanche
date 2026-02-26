namespace Top.Top;

using Microsoft.Purchases.Document;

page 50084 Purchaselinexx
{
    ApplicationArea = All;
    Caption = 'Purchaselinexx';
    PageType = List;
    SourceTable = "Purchase Line";
    Permissions = tabledata "Purchase Line" = Rimd;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the type of document that you are about to create.';
                    editable = true;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                    editable = true;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number.';
                    editable = true;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the line''s number.';
                    editable = true;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the line type.';
                    editable = true;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    editable = true;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.';
                    editable = true;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ToolTip = 'Specifies the value of the Posting Group field.', Comment = '%';
                    editable = true;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                    editable = true;
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ToolTip = 'Specifies the quantity of items that remains to be received.';
                    editable = true;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                    editable = true;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';
                    editable = true;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ToolTip = 'Specifies the value of the VAT % field.', Comment = '%';
                    editable = true;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
                    editable = true;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                    editable = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the sum of amounts in the Line Amount field on the purchase order lines.';
                    editable = true;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ToolTip = 'Specifies the value of the Amount Including VAT field.', Comment = '%';
                    editable = true;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ToolTip = 'Specifies how many units of the item on the line have been posted as received.';
                    editable = true;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
                    editable = true;
                }
                field("Qty. Received (Base)"; Rec."Qty. Received (Base)")
                {
                    ToolTip = 'Specifies the value of the Qty. Received (Base) field.', Comment = '%';
                    editable = true;
                }
                field("Qty. Rcd. Not Invoiced (Base)"; Rec."Qty. Rcd. Not Invoiced (Base)")
                {
                    ToolTip = 'Specifies the value of the Qty. Rcd. Not Invoiced (Base) field.', Comment = '%';
                    editable = true;
                }
                field("Qty. Invoiced (Base)"; Rec."Qty. Invoiced (Base)")
                {
                    ToolTip = 'Specifies the value of the Qty. Invoiced (Base) field.', Comment = '%';
                    editable = true;
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ToolTip = 'Specifies the value of the Qty. Rcd. Not Invoiced field.', Comment = '%';
                    editable = true;
                }
            }
        }
    }
}
