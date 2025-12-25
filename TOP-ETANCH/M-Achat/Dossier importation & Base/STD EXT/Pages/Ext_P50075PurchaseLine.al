pageextension 50075 purchaseorderSubFormExtt extends "Purchase Order Subform"
{
    layout
    {
        modify("Line Discount %")
        {
            Visible = true;

        }
        addafter(Description)
        {
            field("Tariff No."; Rec."Tariff No.")
            {
                ApplicationArea = all;
            }
            field("Country region origin code"; Rec."Country region origin code")
            {
                ApplicationArea = all;
            }
        }



    }
    actions
    {

        addafter(BlanketOrder)
        {

            action(Visualiser_Lot)
            {
                //Image = Excel;
                Visible = true;
                ApplicationArea = all;
                Enabled = true;
                Image = ExportDatabase;
                Promoted = true;
                PromotedCategory = Process;


                trigger onaction()
                var
                    RE: record "Reservation Entry";
                    PA: page "Reservation Entries";
                begin
                    RE.setrange("Source ID", rec."Document No.");

                    PA.SetTableView(RE);
                    Pa.Run();

                end;
            }

        }
    }


}