namespace CPAIBC.CPAIBC;
using Microsoft.Purchases.History;
using Top.Top;
using BCSPAREPARTS.BCSPAREPARTS;
using Microsoft.Inventory.Journal;

page 50180 "Purch Rcpt Pricing Worksheet"
{
    ApplicationArea = All;
    Caption = 'Calcul des prix de vente';
    PageType = Worksheet;
    SourceTable = "Purch. Rcpt. Line";
    Permissions = tabledata "Purch. Rcpt. Line" = m;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Réception)
            {
                Caption = 'Réception';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(VendorNo; VendorNo)
                {
                    Caption = 'Fournisseur';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(VendorName; VendorName)
                {
                    Caption = 'Nom fournisseur';
                    ApplicationArea = All;
                    Editable = false;
                }
                group(Coûts)
                {


                    field(GlobalPurchCost; GlobalPurchCost)
                    {
                        Caption = 'Total achat';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(GlobalPurchCostTND; GlobalPurchCostTND)
                    {
                        Caption = 'Total achat TND';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(GlobalPR; GlobalPR)
                    {
                        Caption = 'Total PR';
                        ApplicationArea = All;
                        Editable = false;
                    }
                }



                field(GlobalCalcBase; GlobalCalcBase)
                {
                    Caption = 'Base de calcul';
                    ApplicationArea = All;
                }

                field(OtherCharges; OtherCharges)
                {
                    Caption = 'Autres frais à affecter';
                    ApplicationArea = All;
                }

                field(Filtre_Description; FiltreDescription)
                {
                    Caption = 'Appliquer %Marge sur Désignation';
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    var
                    begin
                        rec.SetFilter(Description, FiltreDescription);
                        CurrPage.update();
                    end;
                }
                group("Marge de description")
                {
                    Editable = FiltreDescription <> '';
                    field(MargeStdToapply; MargeStdToapply)
                    {
                        Style = Attention;
                        Caption = '%M Std à appliquer ';
                        ApplicationArea = All;
                        Editable = true;
                        MinValue = 1;


                    }
                    field(MargeGrosToAPPLY; MargeGrosToAPPLY)
                    {
                        Style = Strong;
                        Caption = '%M Gros à appliquer';
                        ApplicationArea = All;
                        Editable = true;
                        MinValue = 1;

                    }

                }

            }


            repeater(Lines)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field(PRCost; rec.PRCost)
                {
                    Caption = 'Coût de revient (PR)';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = PRCostStyle;
                }

                field(PMPCost; rec.PMPCost)
                {
                    Caption = 'Coût moyen pondéré';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(OtherUnitCost; Rec.OtherUnitCost)
                {
                    Caption = 'Autres charges';
                    ApplicationArea = All;
                    Editable = true;


                }
                field(CalcBase; Rec.CalcBase)
                {
                    Caption = 'Base';
                    ApplicationArea = All;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    Caption = 'Prix initial';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Subordinate;
                }


                field(PrixStd; rec."Prix Std")
                {
                    Editable = false;
                    Style = Strong;
                    Caption = 'Prix Std';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ;

                }

                field(MargeStd; rec."% Marge Std")
                {
                    Style = Strong;
                    Caption = '%M Std';
                    ApplicationArea = All;
                    Editable = true;
                    BlankZero = true;

                }
                field("P. Marché"; Rec."P. Marché")
                {

                    ApplicationArea = all;
                    BlankZero = true;
                    Style = Unfavorable;

                }
                field("Ecart Marché"; Rec."Ecart Marché")
                {
                    Style = Unfavorable;
                    ApplicationArea = all;
                    BlankZero = true;

                }
                field("% Ecart Marché"; Rec."% Ecart Marché")
                {
                    Style = Unfavorable;
                    caption = '%';
                    ApplicationArea = all;
                    BlankZero = true;
                }
                field(PrixGros; rec."Prix Gros")
                {
                    Style = Strong;
                    Caption = 'Prix Gros';
                    ApplicationArea = All;
                    Editable = false;
                    BlankZero = true;
                    ShowMandatory = true;

                }
                field(MargeGros; rec."% Marge Gros")
                {
                    Style = Strong;
                    Caption = '%M Gros';
                    ApplicationArea = All;
                    Editable = true;
                    BlankZero = true;

                }

                field("P. Marché Gros"; Rec."P. Marché Gros")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Style = StandardAccent;

                }
                field("Ecart Marché Gros"; Rec."Ecart Marché Gros")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Style = StrongAccent;
                }
                field("% Ecart Marché Gros"; Rec."% Ecart Marché Gros")
                {
                    caption = '%';
                    ApplicationArea = all;
                    BlankZero = true;
                    Style = StrongAccent;

                }


            }


        }
        area(FactBoxes)
        {
            part(itemSalesPrices; "Item Sales Price FactBox")
            {
                Caption = 'Prix actuels';
                ApplicationArea = all;
                SubPageLink = "No." = field("No.");
            }
        }





    }
    actions
    {
        area(Processing)
        {


            action("Calculer les coûts")
            {
                Caption = 'Calculer les Coûts';
                Image = Cost;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ProgressDlg: Dialog;
                    TotalCount: Integer;
                    CurrentCount: Integer;
                begin
                    IF Confirm('Vous êtes sur le point de calculer les coûts ..', false) then begin
                        rec.findset(true);

                        TotalCount := Rec.Count;
                        CurrentCount := 0;

                        // Ouverture de la progress bar
                        ProgressDlg.Open(
                            'Calcul des coûts...\#1#########################\@2@@@@@@@@@@@@@@@@@@@@@');
                        repeat

                            CurrentCount += 1;

                            // Mise à jour de la progress bar
                            ProgressDlg.Update(1, StrSubstNo('%1 / %2', CurrentCount, TotalCount));
                            ProgressDlg.Update(2, Round(CurrentCount / TotalCount * 10000, 1));


                            // Rec.OtherUnitCost := 0;
                            //if OtherCharges <> 0 then
                            PricingMgt.AssignAdditionnalCharges(Rec."Document No.", OtherCharges);

                            PricingMgt.CalcCostAmountFromILE(Rec."Document No.", rec."No.", GlobalCalcBase); // Prix de revient
                            PricingMgt.CalcPurchaseAmount(Rec."Document No.", rec."No.", ''); // prix d'achat en tnd
                        until Rec.next = 0;

                        ProgressDlg.Close();

                        rec.FindFirst();


                        Message('Coûts calculés avec succès');
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("Calculer les prix théoriques")
            {
                Caption = 'Calculer les prix théoriques';
                Image = UpdateUnitCost;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF Confirm('Vous êtes sur le point de calculer les PV thèoriques ..', false) then begin
                        If rec.getfilter(Description) = '' then begin

                            If not Confirm('Filtre description vide. Cette action va calculer les prix théorique selon les valeurs des marges pas défaut dans les articles, Voulez vous continuer ou arrêter l''execution?', False, false)
                            then
                                exit;
                        end;
                        rec.findset();
                        repeat
                            PricingMgt.CalcTheoreticalSalesPrice(Rec."Document No.", rec."No.", MargeStdToapply, MargeGrosToAPPLY, rec.getfilter(Description));

                        until Rec.next = 0;
                        rec.FindFirst();


                        Message('Prix de vente calculés avec succès');
                        CurrPage.Update(false);
                    end;
                end;
            }



            action("Calculer les écarts")
            {
                Caption = 'Calculer les écarts';
                Image = ManualExchangeRate;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    PricingMgt.GapCalc(Rec."Document No.");
                    message('Ecarts calculés');
                    CurrPage.Update(false);


                end;


            }




            action("Appliquer les prix")
            {
                Caption = 'Appliquer les prix';
                Image = ApplicationWorksheet;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF Confirm('Vous êtes sur le point d''appliquer les PV définitifs ..', false) then begin
                        IF NOT Confirm('Cette action est irréversible. Continuez-vous ..', false) then
                            exit;
                        PricingMgt.ApplyUnitPrice(Rec."Document No.");
                        message('La mise à jour des prix effectuée');
                        CurrPage.Update(false);

                    end
                end;


            }


            action(ReleaseToSalesLocation)
            {
                Caption = 'Libérer vers magasin de vente';
                Image = TransferReceipt;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemReclassPage: Page "Item Reclass. Journal";
                    ItemJnlLine: Record "Item Journal Line";


                begin
                    if not Confirm(
                        'Cette action va créer une feuille de reclassement et transférer le stock vers le magasin de vente. Continuer ?',
                        false)
                    then
                        exit;

                    PricingMgt.CreateReclassJournalFromReceipt(
                        Rec."Document No.",
                        'TRANSFERT',
                        'VENTE',
                         'CPAI');// a remplacer par un magasin de vente par défaut

                    Message('Feuille de reclassement créée avec succès.');
                    Commit();

                    //NE FONCTIONNE PAS ENCORE
                    ItemJnlLine.SetRange("Journal Template Name", 'TRANSFERT');
                    ItemJnlLine.SetRange("Journal Batch Name", 'VENTE');

                    ItemReclassPage.SetTableView(ItemJnlLine);
                    ItemReclassPage.Run();
                end;

            }

        }

    }
    trigger OnAfterGetRecord()
    var
        RcpHeader: Record "Purch. Rcpt. Header";
    begin
        if (rec."Document No." <> '') and (VendorNo = '') then begin
            RcpHeader.get(Rec."Document No.");
            PricingMgt.GetVendorFromReceipt(rec."Document No.", VendorNo, VendorName);
            GlobalPurchCost := PricingMgt.CalcPurchaseAmount(Rec."Document No.", '', RcpHeader."Currency Code");
            GlobalPurchCostTND := PricingMgt.CalcPurchaseAmount(Rec."Document No.", '', '');
            GlobalPR := PricingMgt.CalcCostAmountFromILE(rec."Document No.", '', GlobalCalcBase);

        end;

        if rec.PRCost <= rec.PMPCost then
            PRCostStyle := 'Favorable'
        else
            PRCostStyle := 'Normal';
    end;

    var
        PricingMgt: Codeunit "Purch Rcpt Pricing Mgt";
        PurchEvent: Codeunit PurchaseEvents;

        VendorNo: Code[20];
        VendorName: Text[100];

        // GlobalMargin: Decimal;
        GlobalPR, GlobalPurchCost, GlobalPurchCostTND : decimal;
        GlobalCalcBase: Option PR,PMP;
        OtherCharges: Decimal;
        MargeStdToapply, MargeGrosToAPPLY : decimal;

        //    MethodeCalcul: Option "Marge sur Net","Marge sur Brut";
        FiltreDescription, PRCostStyle : text;


}
