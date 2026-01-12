namespace PHARMATECCLOUD.PHARMATECCLOUD;
using Microsoft.Inventory.Ledger;
using Microsoft.Sales.Receivables;
using Microsoft.Purchases.Payables;
using Pharmatec.Pharmatec;
using System.Security.User;
using TopEtanch.TopEtanch;

page 70001 "Manager Activities"
{

    SourceTable = "Indicateur TICOP";
    PageType = CardPart;

    RefreshOnActivate = true;

    ApplicationArea = All;
    Caption = 'Indicateur';

    Editable = true;




    layout
    {

        area(content)
        {
            cuegroup("Commercial")
            {
                Visible = TB;
                CueGroupLayout = Wide;
                // ShowCaption = false;
                field("Ventes du jour"; Rec."Ventes")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Item Ledger Entries";
                    DecimalPlaces = 0;
                    Style = StrongAccent;

                }
                field("Marge du jour"; Rec."Marge")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Item Ledger Entries";
                    DecimalPlaces = 0;

                }
                field("% Mg/Vte "; tauxdemargejour)
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 2;
                }
                /*     field("Préparation en cours"; Rec."Préparation en cours")
                    {
                        ApplicationArea = Basic, Suite;
                        //   DrillDownPageId = "Bon de Preparation";
                        DecimalPlaces = 0;
                        trigger OnDrillDown()
                        begin
                            Page.RunModal(Page::"Bon de preparation");
                        end;
                    } */
                field("Ventes du mois"; Rec."Ventes du mois")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Item Ledger Entries";
                    DecimalPlaces = 0;



                }

                field("Marge du mois"; Rec."Marge du mois")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Item Ledger Entries";
                    DecimalPlaces = 0;





                }
                field("% Marge M"; tauxdemargemois)
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 2;
                }
                field("Valeur Stock"; Rec."Valeur Stock")//Rec."Valeur Stock"
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0;
                    trigger OnDrillDown()
                    begin
                        page.RunModal(50050)//50050
                      ;
                    end;
                }
                field("Commande en cours"; Rec."Commande en cours")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0;

                }


            }

            cuegroup("Finance")
            {
                Visible = TB;
                CueGroupLayout = Wide;
                // ShowCaption = false;

                field("Solde clients"; Rec."Solde clients")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0;
                    trigger OnDrillDown()
                    var
                        CLE: Record "Cust. Ledger Entry";
                    begin
                        CLE.SetCurrentKey(Open, "Due Date");
                        CLE.SetRange(Open, true);
                        CLE.SetFilter("Customer Posting Group", '<>%1', 'IMP');
                        Page.RunModal(25, CLE);

                    end;
                }
                field("Impayé Client"; Rec."Impayé")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0;
                    trigger OnDrillDown()
                    var
                        CLE: Record "Cust. Ledger Entry";
                    begin
                        CLE.SetCurrentKey(Open, "Due Date");
                        CLE.SetRange(Open, true);
                        CLE.SetFilter("Customer Posting Group", 'IMP');
                        Page.RunModal(25, CLE);
                    end;
                }

                field(Portefeuille; Rec.Portefeuille)
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0;
                }
                field("Caisse en cours"; Rec."Caisse en cours")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0;
                }



                field("Solde fournisseurs Locaux"; Rec."Solde fournisseurs Locaux")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0;
                    trigger OnDrillDown()
                    var
                        VLE: Record "Vendor Ledger Entry";
                    begin
                        VLE.SetCurrentKey(Open, "Due Date");
                        VLE.SetRange(Open, true);
                        VLE.SetFilter("Currency Code", '=%1', '');
                        Page.RunModal(29, VLE);
                    end;
                }
                field("Solde fournisseurs Etrangers"; Rec."Solde fournisseurs Etranger")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0;
                    trigger OnDrillDown()
                    var
                        VLE: Record "Vendor Ledger Entry";
                    begin
                        VLE.SetCurrentKey(Open, "Due Date");
                        VLE.SetRange(Open, true);
                        VLE.SetFilter("Currency Code", '<>%1', '');
                        Page.RunModal(29, VLE);
                    end;
                }
                field("Total Eng. financier"; Rec."Engagement financier")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0;
                }
                /*       field("Eng. Etranger"; rec."Engagement Etranger")
                      {
                          ApplicationArea = Basic, Suite;
                          DecimalPlaces = 0;
                      } */

            }

        }
    }
    trigger OnOpenPage()
    var
        userSetup: Record "User Setup";

    begin

        if userSetup.get(UserId) then begin
            TB := userSetup."TB DIR";
        end;
        if TB then begin
            Rec.Reset();
            if not Rec.Get() then begin
                Rec.Init();
                Rec.Insert();
            end;

            rec.setrange("Filtre date jour", today());

            rec.setrange("Filtre date mois", DMY2Date(1, Date2DMY(today(), 2), Date2DMY(today(), 3)), today());
        end;

    end;

    trigger OnAfterGetRecord()
    begin
        if TB then begin
            if rec."Ventes du mois" = 0 then
                tauxdemargemois := 0
            else
                tauxdemargemois := rec."Marge du mois" * 100 / rec."Ventes du mois";

            if rec."Ventes" = 0 then
                tauxdemargejour := 0
            else
                tauxdemargejour := rec."Marge" * 100 / rec."Ventes";
        end;


    end;

    var
        tauxdemargemois: Decimal;
        tauxdemargejour: Decimal;

    var
        TB: Boolean;


}
