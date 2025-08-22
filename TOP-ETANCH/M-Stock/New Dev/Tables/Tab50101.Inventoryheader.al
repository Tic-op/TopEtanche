table 50101 "Inventory header"
{
    Caption = 'Inventory header';
    DataClassification = ToBeClassified;



    fields
    {
        field(50001; No; Code[20])
        {
            Caption = 'No';


            /*  trigger OnValidate()
             var
                 InventorySetup: Record "Inventory Setup";
                 NoSeries: Codeunit "No. Series";
             begin
                 if No <> xRec.No then begin

                     InventorySetup.Get();
                     InventorySetup.TestField("Inventory No.");


                     if No = '' then begin
                         No := NoSeries.GetNextNo(InventorySetup."Inventory No.", WorkDate(), true);
                         InventorySetup."Inventory No." := InventorySetup."Inventory No.";
                     end else begin
                         NoSeries.TestManual(InventorySetup."Inventory No.");
                         InventorySetup."Inventory No." := '';
                     end;
                 end;
             end; */
        }
        field(50002; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "","Global","Tournant";
        }
        field(50003; "Location code"; Code[20])
        {
            Caption = 'Code magasin';
            TableRelation = Location;
        }
        field(50004; "Creation Date"; DateTime)
        {
            Caption = 'Date de creation';
        }
        field(50005; Status; Option)
        {
            Caption = 'Statut';
            OptionMembers = "Ouvert","Lancé","Clôturé";
        }
        field(50006; "Release Date"; DateTime)
        {
            Caption = 'Date de lancement';
        }
        field(50007; "Close Date"; DateTime)
        {
            Caption = 'Date clôture';
        }
        field(50008; "Count No."; Integer)
        {
            Caption = 'N° Comptage';

            InitValue = 1;
        }
        field(50009; "UserCreator"; Code[50])
        {
            Caption = 'Code utilisateur';
        }
        field(50010; Validate; Boolean)
        {
            Caption = 'Validate';
        }
        field(50011; "Posting date"; Date)
        {
            Caption = 'Date comptabilisation';
        }
        field(50012; "Item Nbr"; Integer)
        {
            Caption = 'Nombre d''article';

        }
        field(50013; "Valeur art. à inventorier"; Decimal)
        {
            Caption = 'Valeur art. à inventorier';
        }
        field(50014; "Valeur art. inventoriés"; Decimal)
        {
            Caption = 'Valeur art. inventoriés';
        }
        field(50015; "Sujet inventaire"; Text[50])
        {
            Caption = 'Sujet inventaire';
        }
        field(50016; "Count 1 inventory Item Nbre"; Integer)
        {
            Caption = 'Nbre d''article inventorié comp 1';
        }
        field(50017; "Count 2 inventory Item Nbre"; Integer)
        {
            Caption = 'Nbre d''article inventorié comp 2';
        }
        field(50018; "Count 3 inventory Item Nbre"; Integer)
        {
            Caption = 'Nbre d''article inventorié comp 3';
        }
        field(50019; "Count 4 inventory Item Nbre"; Integer)
        {
            Caption = 'Nbre d''article inventorié comp 4';
        }
        field(50020; "Count 5 inventory Item Nbre"; Integer)
        {
            Caption = 'Nbre d''article inventorié comp 5';
        }
        field(50021; Bin; Code[25])
        {
            Caption = 'Code emplacement';
            TableRelation = "Bin".Code WHERE("Location Code" = FIELD("Location code"));


        }

    }


    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }
    var
        s: record "Sales Header";


    trigger OnInsert()
    var
        InventorySetup: Record "Inventory Setup";
        CuSeriesNo: Codeunit "No. Series";
        GLSetup: Record "General Ledger Setup";
    begin
        InventorySetup.Get();
        GLSetup.Get();
        "No" := CuSeriesNo.GetNextNo(InventorySetup."Inventory No.");
        UserCreator := UserId;
        "Creation Date" := CurrentDateTime();


    end;


    trigger OnDelete()
    var
        INVL: record "Inventroy Line";

    begin
        INVL.setrange("Inventory No.", No);
        Invl.DeleteAll();


    end;

    procedure CountItem(): Integer
    var
        InventoryLine: Record "Inventroy Line";
        Count: Integer;
        LastItemCode: Code[20];
    begin
        Count := 0;
        LastItemCode := '';

        InventoryLine.SetRange("Inventory No.", Rec.No);
        InventoryLine.SetCurrentKey("Item No.");

        if InventoryLine.FindFirst() then begin
            repeat
                if InventoryLine."Item No." <> LastItemCode then begin
                    Count := Count + 1;
                    LastItemCode := InventoryLine."Item No.";
                end;
            until InventoryLine.Next() = 0;
        end;

        Rec."Item Nbr" := Count;
        //Rec.Modify();

        exit(Count);
    end;

}
