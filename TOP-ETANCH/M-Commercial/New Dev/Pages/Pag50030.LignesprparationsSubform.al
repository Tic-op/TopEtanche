namespace Top.Top;

page 50030 "Lignes préparations Subform"
{
    ApplicationArea = All;
    Caption = 'Lignes préparations Subform';
    PageType = ListPart;
    SourceTable = "Ligne préparation";
    ModifyAllowed = false ;
    InsertAllowed = false ;
    DeleteAllowed = false ;
    
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Source type."; Rec."Source type.")
                {
                    ToolTip = 'Specifies the value of the Source type. field.', Comment = '%';
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.', Comment = '%';
                }
                field("Source line No."; Rec."Source line No.")
                {
                    ToolTip = 'Specifies the value of the Source line No. field.', Comment = '%';
                }
                field("item No."; Rec."item No.")
                {
                    ToolTip = 'Specifies the value of the item No. field.', Comment = '%';
                }
                field(description; Rec.description)
                {
                    ToolTip = 'Specifies the value of the description field.', Comment = '%';
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.', Comment = '%';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ToolTip = 'Specifies the value of the Bin Code field.', Comment = '%';
                }
                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Qty field.', Comment = '%';
                }
            }
        }
    }
}
