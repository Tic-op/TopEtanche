namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Transfer;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;

tableextension 50013 TransferHeaderExt extends "Transfer Header"
{
    fields
    {
        field(50000; "Source Doc Type"; Enum "Sales Document Type")
        {
            ValuesAllowed = 1, 4;
        }
        field(50001; "Source No."; Code[20])
        {
            Caption = 'N° commande vente ';
            //TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
            Editable = false;
        }
        field(50002; "Source Line No."; Integer)
        {
            Caption = 'N° ligne vente source';
            Editable = false;
        }
        field(50003; "Bon de preparation"; Integer)
        {
            FieldClass = FlowField;
            //CalcFormula = count("Ordre de preparation" where("Order No" = field("No."), Statut = filter("Créé" | "Regroupé" | "Préparé" | "En cours")));
            CalcFormula = count("Ordre de preparation" where("Order No" = field("No.")));

        }
   Field(50103; "Num récéption"; code[20])
        {

        }


    }

}
