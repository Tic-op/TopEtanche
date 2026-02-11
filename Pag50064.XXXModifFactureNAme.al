namespace Top.Top;

using Microsoft.Sales.History;

page 50064 XXXModifFactureNAme
{
    ApplicationArea = All;
    Caption = 'XXXModifFactureNAme';
    PageType = List;
    SourceTable = "Sales Invoice Header";
    UsageCategory = None;
    Permissions = tabledata "Sales Invoice Header" = RM;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the posted invoice number.';
                    Editable = false;
                }
                Field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    editable = false;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ToolTip = 'Specifies the name of the customer that the invoice was sent to.';
                }

                Field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }

                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ToolTip = 'Specifies the name of the customer that the items were shipped to.';
                }
            }
        }
    }
}
