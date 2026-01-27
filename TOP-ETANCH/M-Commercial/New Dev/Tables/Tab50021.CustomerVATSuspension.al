table 50021 "Customer VAT Suspension"
{
    Caption = 'Customer VAT Suspension';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Client';
            TableRelation = Customer."No.";
        }

        field(2; "Start Date"; Date)
        {
            Caption = 'Date début';
        }

        field(3; "End Date"; Date)
        {
            Caption = 'Date fin';
        }

        field(4; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'TVA';
            TableRelation = "VAT Business Posting Group";
        }
        field(5; "Bus. Posting Group"; Code[20])
        {
            Caption = 'Groupe CA';
            TableRelation = "Gen. Business Posting Group";
        }

        field(6; Description; Text[100])
        {
            Caption = 'Description';
        }

    }

    keys
    {
        key(PK; "Customer No.", "Start Date", "End Date")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        CheckDateConsistency();
    end;

    trigger OnModify()
    begin
        CheckDateConsistency();
    end;

    local procedure CheckDateConsistency()
    begin
        if "End Date" < "Start Date" then
            Error('Erreur Date');

        if ("End Date" = 0D) OR ("Start Date" = 0D)
        then
            Error('Erreur Date');
    end;
}
