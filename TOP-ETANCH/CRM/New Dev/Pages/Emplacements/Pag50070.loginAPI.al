namespace PHARMATEC.PHARMATEC;

using Microsoft.Projects.Resources.Resource;

page 50070 loginAPI
{
    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'loginAPI';
    DelayedInsert = true;
    EntityName = 'entityName';
    EntitySetName = 'entitySetName';
    PageType = API;
    SourceTable = "Logistic resource";
    ODataKeyFields = SystemId;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId) { }
                field(PWD; Rec.MotDePasse) { }
                field(Login; Rec.Nom) { }

            }
        }
    }

}
