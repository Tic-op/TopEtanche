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
                  trigger OnDrillDown()
                 var
                 begin

                   //  rec.CalcCostWithCharges();
                 end;
  
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