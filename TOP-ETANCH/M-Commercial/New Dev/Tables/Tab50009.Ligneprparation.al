table 50009 "Ligne préparation"
{
    Caption = 'Ligne préparation';
    DataClassification = ToBeClassified;
    DrillDownPageID = "Lignes préparations List";
    LookupPageID = "Lignes préparations List";
    
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'No document';
        }
        field(2; "Source type."; Option)
        {
            Caption = 'Type.';
            OptionMembers ="Commande","Transfert","Facture";
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Source line No."; Integer)
        {
            Caption = 'No. ligne';
        }
        field(5; "item No."; Code[20])
        {
            Caption = 'No. article';
            TableRelation = item ;
        }
        field(6; description; Text[100])
        {
            Caption = 'Description';
        }
        field(7; Location; Code[10])
        {
            Caption = 'Magasin';
            
        }
        field(8; "Bin Code"; Code[10])
        {
            Caption = 'Emplacement';
        }
        field(9; Qty; decimal)
        {
            Caption = 'Qté';
        }
        field(10; Statut; Option)
        {
            Caption = 'Statut';
            OptionMembers = "Créé","En cours","Préparé","Regroupé","livré";

        }
        field(11; "Creation date"; DateTime)
        {
            Caption = 'Date de création';
        }
        field(12; "Date début préparation"; DateTime)
        {

        }
        field(13; "Date fin préparation"; DateTime)
        {

        }
        field(14; "Préparateur"; Text[50])
        {
            TableRelation = "Logistic resource" where(Magasin = field(Location), blocked = const(false));
        }
        Field(15; Demandeur; Text[50]) { }
        field(16; "Nom demandeur"; text[100])
        {

        }
         field(50011; "Identifier Code"; Code[100])
        {
            Caption = 'Barre Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Identifier TICOP".Code WHERE("Item No." = field("item No.")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Document No.", "Source type.", "Source No.", "Source line No.")
        {
            Clustered = true;
        }
        key(StatusKey; Statut) { }
        key(Datekey; "Creation date", "Date début préparation", "Date fin préparation") { }
        key(Locationkey; Location, "Préparateur") { }
        key(IndicateurKey; Statut, "Source type.", Location, "Préparateur") { }

    }
}
