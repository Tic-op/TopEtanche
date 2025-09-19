namespace Top.Top;

using Microsoft.Inventory.Location;
using Microsoft.Inventory.Item;

page 50028 LocationPart
{
    ApplicationArea = All;
    Caption = 'LocationPart';
    PageType = ListPart;
    SourceTable = Location;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.';
                }
                field(Stock; item.CalcStock(item."No.", rec.Code, ''))
                {
                    DecimalPlaces = 0 : 3;
                }
                field(Disponibilité; item."CalcDisponibilité"(rec.Code, ''))
                {
                    DecimalPlaces = 0 : 3;
                }

            }
        }
    }
    Procedure SetItem(item0: record item)
    var

    begin

        item := item0;
    end;

    Var
        item: Record Item;

}
