namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Setup;
using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.Customer;

tableextension 50010 SalesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Bon de prepation No"; Code[25])
        {
            Caption = 'Bon de prepation No';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Utiliser Pré-BL"; Boolean)
        {
            Caption = 'Utiliser Pré-BL';
            DataClassification = ToBeClassified;

        }
        field(50002; "Utiliser Pré-Facture"; Boolean)
        {
            Caption = 'Utiliser Pré-Facture';
            DataClassification = ToBeClassified;

        }

        field(50003; "Client Divers"; Code[20])
        {
            Caption = 'Client Divers';
            DataClassification = ToBeClassified;
            TableRelation = Customer;

        }
        /*   Field(50003;"PEC Type facturation";Boolean)
          {
              Caption= 'Prise en considération du type facturation';
              DataClassification= ToBeClassified;
          } */
    }
}
