namespace PHARMATEC.PHARMATEC;

using Microsoft.Inventory.Location;

page 50050 "Valeur Stock"
{
    ApplicationArea = All;
    Caption = 'Valeur Stock';
    PageType = List;
    SourceTable = location;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the name or address of the location.';
                }
                field("Valeur Stock"; Rec."Valeur Stock")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Stock field.', Comment = '%';
                }
            }
        }
    }
}
