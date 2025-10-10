namespace Top.Top;

page 50032 "Lignes préparations List"
{
    ApplicationArea = All;
    Caption = '"Lignes préparations List"';
    PageType = List;
    SourceTable = "Ligne préparation";
    UsageCategory = None;
    
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
                  field("Préparateur"; Rec."Préparateur")
                {
                    ToolTip = 'Specifies the value of the Préparateur field.', Comment = '%';
                }
                   field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.', Comment = '%';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ToolTip = 'Specifies the value of the Bin Code field.', Comment = '%';
                }
                field("item No."; Rec."item No.")
                {
                    ToolTip = 'Specifies the value of the item No. field.', Comment = '%';
                }
                field(description; Rec.description)
                {
                    ToolTip = 'Specifies the value of the description field.', Comment = '%';
                }
             
                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Qty field.', Comment = '%';
                }
                field(Statut; Rec.Statut)
                {
                    ToolTip = 'Specifies the value of the Statut field.', Comment = '%';
                }
                field("Creation date"; Rec."Creation date")
                {
                    ToolTip = 'Specifies the value of the Date de création field.', Comment = '%';
                }
                field("Date début préparation"; Rec."Date début préparation")
                {
                    ToolTip = 'Specifies the value of the Date début préparation field.', Comment = '%';
                }
                field("Date fin préparation"; Rec."Date fin préparation")
                {
                    ToolTip = 'Specifies the value of the Date fin préparation field.', Comment = '%';
                }
              
            }
        }
    }
}
