namespace Top.Top;

report 50016 "BonPréparation"
{
    Caption = 'BonPréparation';
    dataset
    {
        dataitem(Ordredepreparation; "Ordre de preparation")
        {
            column(No; No)
            {
            }
            column(Statut; Statut)
            {
            }
            column(OrderNo; "Order No")
            {
            }
            column(Magasin; Magasin)
            {
            }
            column(Creationdate; "Creation date")
            {
            }
            column(Datedbutprparation; "Date début préparation")
            {
            }
            column(Datefinprparation; "Date fin préparation")
            {
            }
            column(Prparateur; "Préparateur")
            {
            }
            column(documenttype; "document type")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
