namespace TopEtanch.TopEtanch;
using Microsoft.Sales.Document;

page 50003 ContactApprobation
{
    ApplicationArea = All;
    Caption = 'ContactApprobation';
    PageType = List;
    SourceTable = ContactApprobation;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Specifies the value of the Order No. field.', Comment = '%';

                    Editable = false;
                    Enabled = not Shipped;
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';

                    Editable = false;
                    Enabled = not Shipped;
                }
                field("Organizational Level Code"; Rec."Organizational Level Code")
                {
                    ToolTip = 'Specifies the value of the Organizational Level Code field.', Comment = '%';
                    Editable = false;
                    Enabled = not Shipped;

                }
                field("Contact "; Rec."Contact ")
                {
                    ToolTip = 'Specifies the value of the Contact field.', Comment = '%';
                    Enabled = not Shipped;

                }


                field(Via; Rec.Via)
                {
                    ToolTip = 'Specifies the value of the Via field.', Comment = '%';
                    Enabled = not Shipped;
                }
                field("Approbation Date"; Rec."Approbation Date")
                {
                    ToolTip = 'Specifies the value of the Approbation Date field.', Comment = '%';
                    Enabled = not Shipped;
                    //Editable = false;
                    Caption = 'Date d''approbation Client';
                }

            }
        }
    }
    var
        Shipped: Boolean;

    /*  trigger OnAfterGetRecord()
     var
         SalesH: record "Sales Header";
     begin
         SalesH.get("Sales Document Type"::order, rec."Order No.");
         Shipped := SalesH."Completely Shipped";

     end; */
    procedure getShipped(isShipped: Boolean)
    begin
        Shipped := isshipped;

    end;
}
