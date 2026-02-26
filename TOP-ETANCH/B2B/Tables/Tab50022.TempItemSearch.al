table 50022 "Temp Item Search"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20]) { }
        field(2; "Count"; Integer) { }
    }

    keys
    {
        key(PK; "Item No.") { Clustered = true; }
    }

}
