namespace TopEtanch.TopEtanch;
using Top.Top;

page 50009 Listedesordresdepreparation
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'listedesordresdepreparation';
    DelayedInsert = true;
    EntityName = 'ListOrdrePre';
    EntitySetName = 'ListOrdresPre';
    PageType = API;
    SourceTable = "Ordre de preparation";
    ODataKeyFields = SystemId;
    SourceTableView = where(Statut = filter(Créé | "En cours"));




    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(no; Rec.No)
                {
                    Caption = 'No';
                }
                field(orderNo; Rec."Order No")
                {
                    Caption = 'N° Commande';
                }
                field(preparateur; Rec."Préparateur")
                {
                    Caption = 'Préparateur';
                }
                field(magasin; Rec.Magasin)
                {
                    Caption = 'Magasin';
                }
                field(statut; Rec.Statut)
                {
                    Caption = 'Statut';
                }
                field(suspendu;Rec.Suspendu)
                {
                    Caption = 'Suspendu';
                }

                field(dateDebutPreparation; Rec."Date début préparation")
                {
                    Caption = 'Date début préparation';
                }
              /*   part(lignesprep;"Lignepréparation")
                {      EntityName = 'Ligneprep';
                EntitySetName ='Lignesprep';
                  
                     SubPagelink ="Document No." = field(No);
 
                } */
            }
        }
    }



}
