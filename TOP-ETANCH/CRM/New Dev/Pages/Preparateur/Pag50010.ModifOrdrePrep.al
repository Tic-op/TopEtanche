namespace TopEtanch.TopEtanch;

page 50010 ModifOrdrePrep
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'modifOrdrePrep';
    DelayedInsert = true;
    EntityName = 'ModifPrep';
    EntitySetName = 'ModifPreps';
    PageType = API;
    SourceTable = "Ordre de preparation";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SystemId; Rec.SystemId) { }
                field(Preparateur; Rec.Préparateur) { }
                field(Statut; Rec.Statut) { }
                //  field(No; Rec.No) { }

            }
        }
    }
}

