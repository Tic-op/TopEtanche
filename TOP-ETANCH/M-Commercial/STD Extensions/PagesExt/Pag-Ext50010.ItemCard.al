namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;
using BSPCloud.BSPCloud;
using Microsoft.Inventory.Item.Attribute;

pageextension 50010 "Item Card" extends "Item Card"
{
    layout

    {   
        addlast(InventoryGrp)
        {
            field("Unité de Dépot"; Rec."Unité de Dépot")
            {
                ApplicationArea = all;
            }
            field("Default depot"; Rec."Default depot")
            {
                ApplicationArea = all;
                Caption = 'Dépot par défaut';
            }
        }
        addafter(InventoryGrp)
        {
            group("Statistique Avancé")
            {
                group(Achat)
                {
                    field("Purchases (Nbr)"; Rec."Purchases (Nbr)")
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'Nombre d''achat';
                    }
                    field("Purchases Receipt (Qty.)"; Rec."Purchases Receipt (Qty.)")
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }

                    field(QtyAN; QAchatN)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'Qté d''achats (Année en cours)';
                        DecimalPlaces = 0 : 3;
                    }
                    field(NbAchatN; NbAchatN)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'Nbre d''achats (Année en cours)';
                    }
                    field("QtyAN-1"; "QAchatN-1")
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'Qté d''achats (Année précédente)';
                        DecimalPlaces = 0 : 3;
                    }
                    field("NbAchatN-1"; "NbAchatN-1")
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'Nbre d''achats (Année précédente)';
                    }
                    field("QtyAN-2"; "QAchatN-2")
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'Qté d''achats (2 ans en arrière)';
                        DecimalPlaces = 0 : 3;
                    }
                    field("NbAchatN-2"; "NbAchatN-2")
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'Nbre d''achats (2 ans en arrière)';
                    }
                }
                group(Vente)
                {

                    field("Qty vendue"; Rec."Qty vendue")
                    {
                        ApplicationArea = all;
                        Editable = false;
                        DecimalPlaces = 0 : 3;
                    }
                    field(VLY; VLY)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'Qté de ventes (Année précédente)';
                        DecimalPlaces = 0 : 3;
                    }
                    field(VCY; VCY)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        DecimalPlaces = 0 : 3;
                        Caption = 'Qté de ventes (Année en cours)';
                    }
                    field(VLY2; VLY2)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        DecimalPlaces = 0 : 3;
                        Caption = 'Qté de ventes (2 ans en arrière)';
                    }
                    field(VenteAnnéeRoulante; VenteAnnéeRoulante)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        DecimalPlaces = 0 : 3;
                        Caption = 'Qté de ventes (Année roulante)';
                    }
                }
            }

        }
         modify(Inventory)
        { trigger OnAssistEdit() begin 
            exit;
        end;
           
        }
        addafter("Unit Price") {
            field("Prix minimal";Rec."Prix minimal")
            {ApplicationArea = all ;}
        }
 
    }

    actions
    {  

        addbefore(Navigation_Item)
        {



            action(Identifiers_Ticop)
            {
                ApplicationArea = Warehouse;
                Caption = 'Code Bar';
                Image = BarCode;
                RunObject = Page "Item identifier Ticop List";
                RunPageLink = "Item No." = field("No.");
                RunPageView = sorting("Item No.", "Variant Code", "Unit of Measure Code");
            }

        }
        modify(Identifiers)
        {
            Visible = false;
        }




    }
    trigger OnAfterGetCurrRecord()
    begin
        rec.GetPurchaseFiscalYear(rec, QAchatN, "QAchatN-1", "QAchatN-2", NbAchatN, "NbAchatN-1", "NbAchatN-2");
        rec.GetSalesFiscalYear(rec, VCY, VLY, VLY2, VenteAnnéeRoulante);
    end;

    var
        QAchatN: Decimal;
        "QAchatN-1": Decimal;
        "QAchatN-2": Decimal;
        NbAchatN: Integer;
        "NbAchatN-1": Integer;
        "NbAchatN-2": Integer;
        VCY: Decimal;
        VLY: Decimal;
        VLY2: Decimal;
        VenteAnnéeRoulante: Decimal;



}
