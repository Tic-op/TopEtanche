table 50001 ContactApprobation   /// By AM 02025
{
    Caption = 'ContactApprobation';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(2; "Organizational Level Code"; Code[10])
        {
            Caption = 'Organizational Level Code';
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(4; "Contact "; Code[20])
        {
            Caption = 'Contact ';
            TableRelation = contact."No." where("Approuver Vente" = const(true), "Organizational Level Code" = field("Organizational Level Code"), "No Organisation" = field("Customer No."));
            //"Contact Business Relation"."Contact No." where ("Link to Table" = const("Contact Business Relation Link To Table"::Customer),"No." = field("Customer No.")) 
            trigger OnValidate()
            begin

                if xrec."Contact " <> "Contact " then resetApprobation();
            end;
        }
        field(5; "Approbation Date"; Date)
        {
            Caption = 'Approbation Date';
            trigger OnValidate()
            begin
                if "Approbation Date" > Today then
                    Error('Date non valide');
            end;
        }
        field(6; Via; Option)
        {
            OptionMembers = " ","Téléphone","E-mail","Whatsapp","Signature";
            Caption = 'Via';

            trigger OnValidate()
            begin

                if xRec.Via <> via then begin

                    if xrec.Via = via::" " then
                        //"Approbation Date" := CurrentDateTime;
                        message('Veuillez saisir la date de l''approbation du client')
                end;
                if via = via::" " then resetDateTime();
            end;
        }
    }
    keys
    {
        key(PK; "Order No.", "Organizational Level Code", "Customer No.")
        {
            Clustered = true;
        }
    }
    procedure resetDateTime()
    begin

        "Approbation Date" := 0D;
    end;

    procedure resetApprobation()
    begin
        validate(Via, Via::" ");
    end;
}
