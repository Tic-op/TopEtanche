namespace CPAIBC.CPAIBC;

page 50305 xxxdeleteItem
{
    ApplicationArea = All;
    Caption = 'xxxdeleteItem';
    PageType = List;
    SourceTable = "Détails Article";
    UsageCategory = Lists;
    Permissions = tabledata "Détails Article" = rimd;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No"; Rec."Item No")
                {
                    ToolTip = 'Specifies the value of the No. article field.', Comment = '%';
                }
                field("Document No"; Rec."Document No")
                {
                    ToolTip = 'Specifies the value of the No. document field.', Comment = '%';
                }

                field("Source No"; Rec."Source No")
                {
                    ToolTip = 'Specifies the value of the No source field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Article Description field.', Comment = '%';
                }

            }
        }
    }
}
