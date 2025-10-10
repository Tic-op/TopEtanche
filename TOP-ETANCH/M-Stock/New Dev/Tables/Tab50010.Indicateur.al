table 50010 "Indicateur Préparation"
{
    Caption = 'Indicateur Préparation';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Code"; Code[25])
        {
            Caption = 'Code';
        }
        Field(2;Locationfilter ;Code[10] )
        {    
           Caption= 'Filtre Magasin';
           FieldClass = FlowFilter ;

        }
        Field(3;"Lignes Prép vente encours";integer)
        {
            FieldClass = FlowField ;
            CalcFormula= Count("Ligne préparation" where (Statut= const("En cours"),"Source type." = filter (Commande|Facture)));
        }
           Field(4;"Lignes Prép vente regoupées";integer)
        {
            FieldClass = FlowField ;
            CalcFormula= Count("Ligne préparation" where (Statut= const("Regroupé"),"Source type." = filter (Commande|Facture)));
        }
          Field(5;"Lignes Prép transfert encours";integer)
        {
            FieldClass = FlowField ;
            CalcFormula= Count("Ligne préparation" where (Statut= const("En cours"),"Source type." = filter (Transfert)));
        }
           Field(6;"Lignes Prép transfer regoupées";integer)
        {   
            Caption = 'Lignes préparations transfert regoupées';
            FieldClass = FlowField ;
            CalcFormula= Count("Ligne préparation" where (Statut= const("Regroupé"),"Source type." = filter (Transfert)));
        }

         Field(7;"Prép vente encours";integer)
        {
            FieldClass = FlowField ;
            CalcFormula= Count("Ordre de preparation" where (Statut= const("En cours"),"document type"= filter (Commande|Facture)));
        }
           Field(8;"Prép vente regoupées";integer)
        {
            FieldClass = FlowField ;
            CalcFormula= Count("Ordre de preparation" where (Statut= const("Regroupé"),"document type" = filter (Commande|Facture)));
        }
          Field(9;"Prép transfert encours";integer)
        {
            FieldClass = FlowField ;
            CalcFormula= Count("Ordre de preparation" where (Statut= const("En cours"),"document type" = filter (Transfert)));
        }
           Field(10;"Prép transfer regoupées";integer)
        {   
            Caption = 'Préparations transfert regoupées';
            FieldClass = FlowField ;
            CalcFormula= Count("Ordre de preparation" where (Statut= const("Regroupé"),"document type" = filter (Transfert)));
        }

        
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
