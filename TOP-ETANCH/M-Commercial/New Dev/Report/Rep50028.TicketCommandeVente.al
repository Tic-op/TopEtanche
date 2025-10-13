report 50028 TicketCommandeVente
{
    ApplicationArea = All;
    Caption = 'Tickets commande vente';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Tickets.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {

            RequestFilterFields = "No.";

            dataitem(SL; "Sales Line")
            {
                // RequestFilterFields = "Document No.", "Location Code";


                column(No_Article; "No.") { }
                column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
                column(Document_No_; "Document No.") { }
                column(Description; Description) { }
                column(Quantity; "Qty. to Ship") { }
                column(Location_Code; "Location Code") { }
                column(Bin_Code; "Bin Code") { }
                column(DD; DD) { }
                column(DF; DF) { }




                trigger OnPreDataItem()
                var
                    SL0: Record "Sales Line";
                    Loc0: Code[20];
                begin
                    Loc0 := '';



                    SL.SetRange("Document Type", "Sales Header"."Document Type");
                    SL.SetRange("Document No.", "Sales Header"."No.");

                    SL.SetFilter("Qty. to Ship", '<>%1', 0);
                    if LocationCode <> '' then begin
                        SL.SetCurrentKey("Location Code");
                        SL.SetFilter("Location Code", LocationCode);
                    end;

                    if NotPrinted = true
                    then;
                    // SL.SetRange(SL.Print, false);
                end;

                trigger OnPostDataItem()
                begin
                    //  sl.ModifyAll(SL.Print, true);
                end;

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(NotPrinted; NotPrinted)
                    {
                        ApplicationArea = All;
                        Caption = 'Jamais imprimé';
                    }
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Magasin';
                        TableRelation = Location;
                    }
                    /*  field(NumCommande; NumCommande)
                     {
                         ApplicationArea = All;
                         Caption = 'N° commande';
                         //TableRelation = "Sales Header";// where("Document type" = const(order));
                     } */


                }

            }
        }
        /*  actions
         {
             area(Processing)
             {
                 action(Imprimé)
                 {
                     Caption = 'Imprimé';
                     ApplicationArea = All;

                 }
             }

         } */



    }
    var
        DD: Date;
        DF: Date;
        NotPrinted: Boolean;
        LocationCode: code[25];
        NumCommande: code[20];
}
