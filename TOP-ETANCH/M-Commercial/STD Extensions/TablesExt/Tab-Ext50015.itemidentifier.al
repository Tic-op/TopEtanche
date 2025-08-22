namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.ADCS;

tableextension 50015 "Item Identifier TICOP" extends "Item Identifier TICOP"
{
    fields
    {
        field(50000; "Ordre de préparation No."; Code[20])
        {
            Caption = 'N° Inventaire';
            TableRelation = "Ordre de preparation";

        }

    }
}
