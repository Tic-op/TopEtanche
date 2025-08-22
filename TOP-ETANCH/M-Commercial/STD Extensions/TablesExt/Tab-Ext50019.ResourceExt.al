namespace PHARMATEC.PHARMATEC;

using Microsoft.Projects.Resources.Resource;

tableextension 50019 ResourceExt extends Resource
{
    fields
    {
        field(50000; "Login"; Text[50])
        {
            Caption = 'Nom';
            DataClassification = ToBeClassified;
        }
        field(50001; "PWD"; Text[50])
        {
            Caption = '';
            DataClassification = ToBeClassified;
            NotBlank = false;

        }
    }
}
