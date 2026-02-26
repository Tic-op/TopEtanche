namespace Top.Top;

page 50083 "Marque List"
{
    ApplicationArea = All;
    Caption = 'Liste des marques';
    PageType = List;
    SourceTable = Marque;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
