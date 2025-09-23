namespace BSPCloud.BSPCloud;

page 50039 "Offre de prix"
{
    ApplicationArea = All;
    Caption = 'Offre de prix';
    PageType = List;
    SourceTable = "Offre de prix ";
    UsageCategory = Lists;
    ModifyAllowed = false;
    InsertAllowed = false;
    ShowFilter = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("Vendor Name"; rec."Vendor Name")
                {

                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("item description"; rec."item description")
                {
                    ApplicationArea = all;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Price; Rec.Price)
                {
                    ToolTip = 'Specifies the value of the Price field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
}
