namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Ledger;

report 50001 Demo
{
    ApplicationArea = All;
    Caption = 'Disponibilité dans ''DÉMO''';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'demo.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = where("Open" = const(true), "Location Code" = const('DÉMO'), "Entry Type" = filter('Transfert'));

            column(Famille; Famille) { }

            column(ItemNo; "Item No.")
            {
            }
            column(Designation; Designation)
            {
            }
            column(Open; Open)
            {
            }
            column(Quantity; "Remaining Quantity")
            {
            }
            column(Nom_Origine; "Nom Origine")
            { }
            column(Posting_Date; "Posting Date")
            { }
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
}
