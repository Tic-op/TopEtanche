namespace DefaultPublisher.SalesManagement;

using Microsoft.Sales.Customer;
using Microsoft.CRM.Contact;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Intrastat;
using PHARMATECCLOUD.PHARMATECCLOUD;




pageextension 50139 CustomerCard extends "customer Card"
{
    layout
    {

        addafter("Customer Posting Group")
        {
            field("Timbre"; Rec.Stamp)
            {
                ApplicationArea = all;
                Caption = 'Timbre Fiscal';
            }
        }


        addafter("Bill-to Customer No.")
        {
            field("Client Initial"; rec."Client Initial")
            {

                ApplicationArea = all;
                Caption = 'Client Initial';

            }
        }
        modify(Blocked)
        {
            Caption = 'Bloquer des transactions... ';
        }
        addafter(Blocked)
        {
            field("Territory Code"; Rec."Territory Code")
            {
                Caption = 'Code Secteur';
                ApplicationArea = all;
                TableRelation = Territory;
                NotBlank = true;
                ShowMandatory = true;

            }
            field("Cause du blockage"; Rec."Cause du blocage")

            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.update();
                end;
            }
            field(Public; Rec.Public)
            {
                ApplicationArea = All;
            }

        }
        addafter("Payment Terms Code")
        {
            field("Contre remboursement"; Rec."Contre remboursement")
            {
                Importance = Promoted;
                ApplicationArea = All;
            }

        }

        addafter("SIREN No.")
        {
            field("Type de facturation"; Rec."Type de facturation")
            {
                ApplicationArea = All;

            }
            field(Seuil; Rec.Seuil)
            {
                Caption = 'Minimum à facturer';
                ApplicationArea = all;
                enabled = rec."Type de facturation" = rec."Type de facturation"::"Fact. Plafond";
                // visible = rec."Type de facturation" = rec."Type de facturation"::"Fact. Plafond";
            }

        }
        addafter(Name)
        {
            field("Customer type"; Rec."Customer type")
            {
                ApplicationArea = all;
            }
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
    }
    actions
    {
        addfirst(reporting)
        {

            action("Relevé Client Ticop")
            {
                Promoted = true;
                PromotedCategory = Report;
                Caption = 'Engagement Client Ticop';
                ApplicationArea = all;
                Image = GLAccountBalance;
                trigger OnAction()
                var

                    customer: record customer;
                begin
                    Customer.setfilter("no.", rec."no.");

                    report.runmodal(50010, true, true, Customer);

                end;

            }

        }
        modify("Report Statement")
        {
            Visible = false;
        }
    }

}