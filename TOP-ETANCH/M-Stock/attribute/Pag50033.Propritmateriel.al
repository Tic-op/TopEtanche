namespace Top.Top;

page 50033 "Propriété matériaux"
{
    ApplicationArea = All;
    Caption = 'Propriété matériaux';
    PageType = ListPart;
    SourceTable = "Propriété matériaux";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code matériaux"; Rec."Code matériaux")
                {
                    ToolTip = 'Specifies the value of the Code matériaux field.', Comment = '%';
                    Visible= false ;
                }
                field("Propriété"; Rec."Propriété")
                {
                    ToolTip = 'Specifies the value of the Propriété field.', Comment = '%';
                }
                field("Valeur par défaut"; Rec."Valeur par défaut")
                {
                    ToolTip = 'Specifies the value of the Valeur par défaut field.', Comment = '%';
                }
            }
        }
    }
}
