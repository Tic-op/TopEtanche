namespace PHARMATECCLOUD.PHARMATECCLOUD;

using Microsoft.Inventory.Location;
using Microsoft.Inventory.Posting;
using Microsoft.Inventory.Ledger;

tableextension 50016 "Location Ext" extends Location
{
    fields
    {

        Field(50000; "Type"; Option)
        {

            OptionMembers = "Dépot","Point de vente","Tampon","Casse";
            Caption = 'Type magasin';
        }
        field(50002; "Valeur Stock"; Decimal)
        {
            Caption = 'Stock';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = sum("Item Ledger Entry"."Operation Cost" where("Location Code" = field(code)));
        }
        field(50003; "Qty Minimum"; Decimal)
        {
            Caption = 'Quantité minimum';


        }
        /*  field(50004; "tampon"; Boolean)
         {
             caption = 'Tampon';
         } */
        field(50005; "Dépot associé"; Code[10])
        {
            TableRelation = if (type = const("Point de vente")) Location.code where(type = const("Dépot"));
        }

    }

}
