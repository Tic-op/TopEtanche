namespace TopEtanch.TopEtanch;

page 50008 "Logistic resources list"
{
    ApplicationArea = All;
    Caption = 'Liste des ressources logistiques';
    PageType = List;
    SourceTable = "Logistic resource";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Nom; Rec.Nom)
                {
                    ApplicationArea = all;
                }
                field(MotDePasse; Rec.MotDePasse)
                {
                    ApplicationArea = all;
                }
                field(Magasin; Rec.Magasin)
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field(blocked; Rec.blocked)
                {
                    ApplicationArea = all;
                }

            }
        }
    }
}
