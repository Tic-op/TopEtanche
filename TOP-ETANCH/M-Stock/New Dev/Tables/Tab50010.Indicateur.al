table 50010 "Indicateur Préparation"
{
    Caption = 'Indicateur Préparation';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[25])
        {
            Editable = false;
            Caption = 'Code';
        }
        Field(2; Locationfilter; Code[10])
        {
            Editable = false;
            Caption = 'Filtre Magasin';
            FieldClass = FlowFilter;

        }
        Field(3; "Lignes Prép vente encours"; integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Ligne préparation" where(Statut = const("En cours"), "Source type." = filter(Commande | Facture)));
        }
        Field(4; "Lignes Prép vente regoupées"; integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Ligne préparation" where(Statut = const("Regroupé"), "Source type." = filter(Commande | Facture)));
        }
        Field(5; "Lignes Prép transfert encours"; integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Ligne préparation" where(Statut = const("En cours"), "Source type." = filter(Transfert)));
        }
        Field(6; "Lignes Prép transfer regoupées"; integer)
        {
            Editable = false;
            Caption = 'Lignes préparations transfert regoupées';
            FieldClass = FlowField;
            CalcFormula = Count("Ligne préparation" where(Statut = const("Regroupé"), "Source type." = filter(Transfert)));
        }

        Field(7; "Nouvelles prép."; integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Ordre de preparation" where(Statut = Const("Créé")));
        }
        Field(8; "Encours Vente"; integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Ordre de preparation" where(Statut = const("En cours"), "document type" = filter(Commande | Facture)));
        }
        Field(9; "Encours Transf."; integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Ordre de preparation" where(Statut = const("En cours"), "document type" = filter(Transfert)));
        }
        Field(10; "Prép transfer regoupées"; integer)
        {
            Editable = false;
            Caption = 'Préparations transfert regoupées';
            FieldClass = FlowField;
            CalcFormula = Count("Ordre de preparation" where(Statut = const("Regroupé"), "document type" = filter(Transfert)));
        }
        Field(11; "Prép vente en attente"; integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Ordre de preparation" where(Statut = const("Créé"), "document type" = filter(Commande | Facture)));
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
