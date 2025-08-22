namespace TOPETANCH.TOPETANCH;

using Microsoft.Warehouse.Ledger;

tableextension 50020 "Warehouse Entrie" extends "Warehouse Entry"
{
    keys
    {

        key("Expiration Key"; "Expiration Date", "Item No.", "Lot No.")
        {

        }
    }
}
