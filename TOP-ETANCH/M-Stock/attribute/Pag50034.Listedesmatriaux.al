namespace Top.Top;

page 50034 "Liste des matériaux"
{
    ApplicationArea = All;
    Caption = 'Liste des matériaux';
    PageType = List;
    SourceTable = "Fiche matériaux";
    UsageCategory = Lists;
    CardPageId= "Fiche matériaux";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    Editable= false ;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
