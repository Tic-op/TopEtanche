namespace Ticop.Ticop;

using Microsoft.CRM.Contact;

pageextension 50001 Contact extends "Contact Card"
{
    layout
    {

        addafter("Company Name")
        {

            field(Concurrent; Rec.Concurrent)
            {
                ApplicationArea = all;
                Caption = 'Concurent';
            }
            /*   field("Customer Posting Group"; Rec."Customer Posting Group")
              {
                  ApplicationArea = all;
                  Caption = 'Groupe Contact';
              } */
            field("Nbre Personnes"; Rec."Nbre Personnes")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Nbre Personnes';
            }
            field("code secteur"; Rec."Territory Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Organizational Level Code")
        {
            field("Approuver Vente"; Rec."Approuver Vente")
            {
                ApplicationArea = all;

            }
        }
    }


}
