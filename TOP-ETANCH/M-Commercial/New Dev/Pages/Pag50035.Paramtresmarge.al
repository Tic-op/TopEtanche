namespace Top.Top;

page 50035 "Paramêtres marge"
{
    ApplicationArea = All;
    Caption = 'Paramêtres marge';
    PageType = List;
    SourceTable = "Paramêtre marge";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Type articles"; Rec."Type articles")
                {
                    ToolTip = 'Specifies the value of the Type articles field.', Comment = '%';
                }
                field("Groupe prix client"; Rec."Groupe prix client")
                {
                    ToolTip = 'Specifies the value of the Groupe prix client field.', Comment = '%';
                }
                field(Marge; Rec.Marge)
                {
                    ToolTip = 'Specifies the value of the Marge field.', Comment = '%';
                }
            }
        }
    }
}
