namespace Nouveaudossier.Nouveaudossier;

using Microsoft.Foundation.Company;

tableextension 50009 "Company information" extends "Company Information"
{
    fields
    {
        field(50000; "version CRM"; Text[50])
        {
            Caption = 'versionCRM';
            DataClassification = ToBeClassified;
        }
    }
}
