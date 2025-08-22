namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Archive;

tableextension 50028 "Purchase Line Archive Ext" extends "Purchase Line Archive"
{
    fields
    {
        field(50011; "Confirmé par fournisseur"; Boolean)
        {
            Caption = 'Confirmé par fournisseur';
            DataClassification = ToBeClassified;
        }
    }
}
