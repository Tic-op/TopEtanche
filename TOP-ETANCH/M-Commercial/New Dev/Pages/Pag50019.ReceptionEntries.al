namespace TopEtanch.TopEtanch;

page 50019 ReceptionEntries
{
    ApplicationArea = All;
    Caption = 'ReceptionEntries';
    PageType = Card;
    SourceTable = "Reception Entry";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Customer No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the N° client field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the N° article field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Item Bar Code"; Rec."Item Bar Code")
                {
                    ToolTip = 'Specifies the value of the CAB article field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantité field.', Comment = '%';
                }
                field("Sales Order No."; Rec."Purchase Order No.")
                {
                    ToolTip = 'Specifies the value of the N° commande vente field.', Comment = '%';
                }
                field("Scan Date"; Rec."Scan Date")
                {
                    ToolTip = 'Specifies the value of the Date lecture field.', Comment = '%';
                }
                field("Terminal ID"; Rec."Terminal ID")
                {
                    ToolTip = 'Specifies the value of the ID Terminal field.', Comment = '%';
                }
            }
        }
    }
}
