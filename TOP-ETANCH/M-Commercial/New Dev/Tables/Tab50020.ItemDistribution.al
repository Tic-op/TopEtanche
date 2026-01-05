table 50020 "Item Distribution"
{
    Caption = 'Item Distribution';
    DataClassification = ToBeClassified;
    //TableType = Temporary;

    fields
    {
        Field(1; "Source Doc type"; Enum "Sales Document Type")
        {
            ValuesAllowed = 1, 4;

            Caption = 'Type Origine';

        }
        field(2; "Source Doc No."; Code[25])
        {
            Caption = 'Commande d''origine';

        }

        field(3; "Source Line No."; Integer)
        {
            Caption = 'Ligne commande';

        }
        field(4; Item; Code[20])
        {
            Caption = 'Article';
            TableRelation = Item;
        }
        field(5; "Location Code"; Code[10])
        {
            Caption = 'Magasin';
            TableRelation = Location;

        }
        field(6; "Bin Code"; Code[20])
        {
            Caption = 'Emplacement';
            TableRelation = Bin where("Location Code" = field("Location Code"));
        }
        field(7; Qty; Decimal)
        {
            Caption = 'Disponibilité';
            MinValue = 0;
        }
        field(8; "Qty to assign"; decimal)
        {
            Caption = 'Quantité à affecter';
            MinValue = 0;

            trigger OnValidate()
            var
                location: Record Location;
            begin
                location.get("Location Code");
                if location."Use As In-Transit" then
                    error('Impossible de modifier récupérer de ce magasin car c''est un TRANSIT');
                if location.Type = location.Type::Casse then
                    error('Impossible de modifier récupérer de ce magasin car c''est un Casse');
                if location.Type = location.Type::Tampon then
                    error('Impossible de modifier récupérer de ce magasin car c''est un Tampon');
            end;
        }
        field(9; "Qté Base Sortie"; decimal)
        {

            editable = false;

        }
        field(10; "Qty à transférer"; Decimal)
        {
            MinValue = 0;
        }

        field(11; "Nbr Ordre Transfert"; Integer)
        {
            Caption = 'Nbre Ordres Transfert';
            FieldClass = FlowField;
            CalcFormula = Count("Transfer Header" where("Source No." = field("Source Doc No."), "Source Line No." = field("Source Line No.")));

        }

        field(13; "Stock min"; Decimal)
        {
            Caption = 'Stock min';
            FieldClass = FlowField;
            CalcFormula = lookup("Item stock min by location"."Stock min" where(Location = field("Location Code")));
        }


    }


    keys
    {
        key(PK; "Source Doc type", "Source Doc No.", "Source Line No.", Item, "Location Code", "Bin Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin

        // message('item distribution %1 , %2 , %3 ,%4 , %5 , %6 inserted', "Source Doc type", "Source Doc No.", "Source Line No.", Item, "Location Code", "Bin Code");

    end;

    trigger OnDelete()
    begin


        // message('item distribution %1 , %2 , %3 ,%4 , %5 , %6 Deleted', "Source Doc type", "Source Doc No.", "Source Line No.", Item, "Location Code", "Bin Code");

    end;

    trigger OnModify()
    begin

        // message('item distribution %1 , %2 , %3 ,%4 , %5 , %6 Modified', "Source Doc type", "Source Doc No.", "Source Line No.", Item, "Location Code", "Bin Code");


    end;

    trigger OnRename()
    begin
        // error('item distribution %1 , %2 , %3 ,%4 , %5 , %6 Modified', "Source Doc type", "Source Doc No.", "Source Line No.", Item, "Location Code", "Bin Code");

        // message('item distribution %1 , %2 , %3 ,%4 , %5 , %6 Modified', "Source Doc type", "Source Doc No.", "Source Line No.", Item, "Location Code", "Bin Code");

    end;
    /* procedure CalctotalQuantitéAffectée(): decimal
        var
            ItemDist: record "Item Distribution";
            total: Decimal;
        begin
            total := 0;

            if ItemDist.Findfirst() then
                repeat
                    total += ItemDist."Qty to assign";
                until ItemDist.next = 0;

            exit(total);

        end; */

}
