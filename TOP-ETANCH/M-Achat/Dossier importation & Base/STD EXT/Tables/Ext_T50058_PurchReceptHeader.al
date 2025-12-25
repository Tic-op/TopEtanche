tableextension 50058 PurchRCPHeaderExt extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50001; "DI No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No DI';
            TableRelation = "Import Folder" where("Vendor No." = field("Pay-to Vendor No."));
        }
    }
}