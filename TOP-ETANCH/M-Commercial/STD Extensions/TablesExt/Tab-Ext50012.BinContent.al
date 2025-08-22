namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.Structure;

tableextension 50012 BinContent extends "Bin Content"
{
    fields
    {
        field(50000; "Barre Code"; code[25])
        {
            Caption = 'Barre-Code';
            DataClassification = ToBeClassified;
        }
        Field(80000; Disponibilité; decimal)
        {

        }
    }
    keys
    {

        key(DisponibilitéKey; "Disponibilité") { }
    }
}
