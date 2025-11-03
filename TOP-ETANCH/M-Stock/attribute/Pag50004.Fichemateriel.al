namespace Top.Top;

page 50004 "Fiche matériaux"
{
    ApplicationArea = All;
    Caption = 'Fiche matériaux';
    PageType = Card;
    SourceTable = "Fiche matériaux";
    //UsageCategory = Documents ;
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
            part(Propriété;"Propriété matériaux")
            {
                SubPageLink = "Code matériaux" = field(Code);
            }
        }
    }
}
