namespace TopEtanch.TopEtanch;


using Microsoft.Inventory.Setup;
using Microsoft.Foundation.NoSeries;

tableextension 50021 InventorySetup extends "Inventory Setup"
{
    fields
    {
        field(50004; "Bon d'Entrée"; Code[20])
        {
            caption = 'Bon d''Entrée';
            TableRelation = "No. Series";
        }
        field(50005; "Bon de Sortie"; Code[20])
        {
            caption = 'Bon de Sortie';
            TableRelation = "No. Series";
        }
    }
}
