table 50020 "Item Distribution"
{
    Caption = 'Item Distribution';
    DataClassification = ToBeClassified;
    //TableType = Temporary;

    fields
    {
        field(1; Item; Code[20])
        {
            Caption = 'Article';
            TableRelation = Item;
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Magasin';
            TableRelation = Location;

        }
        field(3; "Bin Code"; Code[20])
        {
            Caption = 'Emplacement';
            TableRelation = Bin where("Location Code" = field("Location Code"));
        }
        field(4; Qty; Decimal)
        {
            Caption = 'Disponibilité';
            MinValue = 0;
        }
        field(5; "Qty to assign"; decimal)
        {
            Caption = 'Quantité à affecter';
            MinValue = 0;
        }
        field(6; "Qté Base Sortie"; decimal)
        {

            editable = false;

        }
        field(7; "Qty à transférer"; Decimal)
        {
            MinValue = 0;
        }
        field(8; "Source Doc No."; Code[25])
        {
            Caption = 'Commande d''origine';

        }

        field(9; "Source Line No."; Integer)
        {
            Caption = 'Ligne commande';

        }
        field(10; "Nbr Ordre Transfert"; Integer)
        {
            Caption = 'Nbre Ordres Transfert';
            FieldClass = FlowField;
            CalcFormula = Count("Transfer Header" where("Source No." = field("Source Doc No."), "Source Line No." = field("Source Line No.")));

        }
        field(11; "Qty Minimum"; Decimal)
        {
            Caption = 'Quantité Minimum';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Location"."Qty Minimum" where("Code" = field("Location Code")));
        }
        field(12; "Stock min"; Decimal)
        {
            Caption = 'Stock min';
            FieldClass = FlowField;
            CalcFormula = lookup("Item stock min by location"."Stock min" where(Location = field("Location Code")));
        }

    }

    keys
    {
        key(PK; Item, "Location Code", "Bin Code")
        {
            Clustered = true;
        }
    }


}
