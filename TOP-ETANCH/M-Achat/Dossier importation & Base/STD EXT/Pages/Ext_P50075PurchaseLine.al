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
            Action(Recherche_Ticop)

            {
                ShortcutKey = 'Alt+W';
                ApplicationArea = all;
                Image = AddWatch;
                trigger OnAction()
                var
                    RS: Page "Usual search Purchase";
                    PurchaseHeader: record "Purchase Header";
                begin
                    PurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
                    PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);
                    RS.initvarPurch(PurchaseHeader."Document Type", PurchaseHeader."No.");
                    //RS.Run();
                    rs.RunModal();

                    // Page.RunModal(50029);
                    CurrPage.Update();



                end;
            }


        }
    }


}