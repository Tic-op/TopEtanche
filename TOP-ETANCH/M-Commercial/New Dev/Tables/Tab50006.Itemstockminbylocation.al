table 50006 "Item stock min by location"
{
    Caption = 'Item stock min by location';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Location; Code[10])
        {
            Caption = 'Location';
            TableRelation = Location;

        }
        field(2; Item; Code[20])
        {
            Caption = 'Item';
            TableRelation = Item;
        }
        field(3; "Stock min"; Decimal)
        {
            DecimalPlaces = 0 : 3;

        }


    }
    keys
    {
        key(PK; Location, Item)
        {
            Clustered = true;
        }
    }
}
