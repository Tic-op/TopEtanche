namespace Top.Top;

using Microsoft.Sales.History;

pageextension 50079 "Posted Sales Shipments Ext" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("Posting Date "; Rec."Posting Date")
            {
                ApplicationArea = all;
                Caption = 'Date BL';
            }
            field(Invoiced; rec.Invoiced)
            {
                ApplicationArea = all;
                Visible = true;

            }

        }
        addafter("Sell-to Customer Name")
        {

            field(TTC; TTC_BL())
            {
                ApplicationArea = all;
                Caption = 'TTC';
                Editable = false;
                ToolTip = 'Specifies the total amount including tax for the sales shipment.';
            }
            field("Règlement en cours"; Rec."Règlement en cours")
            {
                ApplicationArea = all;
                Style = Favorable;
                BlankZero = true;
            }

        }
    }

    local procedure TTC_BL() Mttc: Decimal
    var
        LigBL: Record "Sales Shipment Line";
    begin
        LigBL.SetRange("Document No.", rec."No.");
        if not LigBL.FindSet() then
            exit(0);

        repeat
            Mttc += round((LigBL."Quantity" * LigBL."Unit Price") * (1 - LigBL."Line Discount %" / 100) * (1 + LigBL."VAT %" / 100));
        until LigBL.Next() = 0;
    end;
}
