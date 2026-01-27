namespace Top.Top;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

report 50033 "Calcul des prix de vente"
{
    ApplicationArea = All;
    Caption = 'Calcul des prix de vente';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            RequestFilterFields = "Document No.", "Item No.", "Posting Date";
            DataItemTableView = where("Document Type" = CONST("Item Ledger Entry Type"::purchase), Positive = const(true));

            trigger OnPreDataItem()
            begin
                if (GetFilter("Posting Date") = '') OR // peut etre il faut controler la période : exple : pas de mise à jour pour N-1
                             (GetFilter("Document No.") = '') then
                    Error('Vous devez mentionner la réception ainsi que sa date avant de lancer ce calcul');

                if OptionBase = OptionBase::" " then
                    Error('Vous devez choisir la base de votre calcul');

                if NOT CONFIRM('Vous êtes sur le point de mettre à jour les prix de vente de %1 articles... \ Base = %2', false, COUNT, OptionBase) then
                    exit;

                if NOT CONFIRM('Etes-vous sûrs de vouloir continuer cette action ?', false, COUNT) then
                    exit;

                if NOT CONFIRM('***** Cette mise à jour est IRREVERSIBLE.***** \ Continuez ?', false, COUNT) then
                    exit;

                if OptionBase = OptionBase::"Prix de revient" then
                    SetAutoCalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
            end;

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
            begin
                Item.get("Item No.");
                if NOT Item."Cost is Adjusted" then
                    Error('Le coût de %1    %2  n''est pas encore ajusté', Item."No.", Item."Vendor Item No.");

                if OptionBase = OptionBase::"Prix de revient" then
                    Item.UpdateNewPrices(("Cost Amount (Actual)"
                     + "Cost Amount (Expected)")
                    / Quantity)
                else
                    Item.UpdateNewPrices(Item."Unit Cost");
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Base de calcul")

                {
                    field(Option; OptionBase)
                    {
                        ApplicationArea = all;
                        Caption = 'Choisir une option ';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        OptionBase: Option " ","Prix moyen","Prix de revient";
}
