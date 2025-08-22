namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.Structure;

tableextension 50014 BinExt extends bin
{
    fields
    {
        field(50000; CodeBarre; Code[25])
        {
            Caption = 'CodeBarre';
            DataClassification = ToBeClassified;
        }
        field(50001; "Niveau emplacement"; Option)
        {
            Caption = 'Niveu emplacement';
            OptionMembers = "0","1","2","3","4";
        }
        field(50002; "Date de mise à jour"; DateTime)
        {

        }
    }
}
