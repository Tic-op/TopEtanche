namespace TOPETANCH.TOPETANCH;

page 50104 "Liste des inventaires"
{
    ApplicationArea = All;
    Caption = 'Liste des inventaires';
    PageType = List;
    SourceTable = "Inventory header";
    CardPageId = "Inventory Header Card";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                    ApplicationArea = all;
                }

                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Location code"; Rec."Location code")
                {
                    ToolTip = 'Specifies the value of the Location code field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Count No."; Rec."Count No.")
                {
                    ToolTip = 'Specifies the value of the N° Comptage field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.', Comment = '%';
                    ApplicationArea = all;
                }


                field("Release Date"; Rec."Release Date")
                {
                    ToolTip = 'Specifies the value of the Release Date field.', Comment = '%';
                    ApplicationArea = all;
                }

                field("Code utilisateur"; Rec.UserCreator)
                {
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                    ApplicationArea = all;
                }

            }
        }
    }
}
