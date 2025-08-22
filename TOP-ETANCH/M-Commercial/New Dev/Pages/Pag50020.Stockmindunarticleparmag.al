namespace TopEtanch.TopEtanch;
using Microsoft.Warehouse.Structure;

page 50020 "Stock min d'un article par mag"
{
    ApplicationArea = All;
    Caption = 'Stock min d''un article par mag';
    PageType = List;
    SourceTable = "Item stock min by location";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Item; Rec.Item)
                {
                    ToolTip = 'Specifies the value of the Item field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.', Comment = '%';
                    ApplicationArea = all;
                }

                field("Stock min"; Rec."Stock min")
                {
                    ToolTip = 'Specifies the value of the Stock min field.', Comment = '%';
                    ApplicationArea = all;

                }

            }
        }
    }

}
