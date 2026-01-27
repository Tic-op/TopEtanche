page 50059 "Import folder card"
{
    PageType = Card;


    SourceTable = "Import Folder";
    Caption = 'Dossier Importation';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;

                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = all;
                }
                field("N° déclaration"; Rec."N° déclaration")
                {
                    ApplicationArea = all;
                }
                field("N° Titre Importation"; Rec."N° Titre Importation")
                {
                    ApplicationArea = all;
                }
                field("Nombre de colis"; Rec."Nombre de colis")
                {
                    ApplicationArea = all;
                }
                field("Order Count"; Rec."Order Count")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Purchase Order List";
                }
                field("Invoice Count"; Rec."Invoice Count")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Purchase Invoices";
                }
                field("Réceptions validées"; Rec."Réceptions validées")
                {
                    ApplicationArea = all;

                }
                field("Factures achat enregistrées"; Rec."Factures achat enregistrées")
                {
                    ApplicationArea = all;
                }
                field("Avoirs Achat Enregistrées"; Rec."Avoirs Achat Enregistrées")
                {
                    ApplicationArea = all;
                }
            }
            part(DroitDouane; "Droit douane ledger entry")
            {
                ApplicationArea = all;
                Editable = true;

                SubPageLink = "DI No" = field("No.");
            }

        }
        area(Factboxes)
        {
            part(DocumentsAttach; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = CONST(50119), "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExtraireDD)

            {
                Image = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    recPurchaseRCP: Record "Purch. Rcpt. Header";
                    RecLPurchRCPLine: record "Purch. Rcpt. Line";
                    DroitDouaneLEntry: record DroitDouaneLedgerEntry;
                    LineNo: Integer;
                // itm:record item;
                begin


                    recPurchaseRCP.SETRANGE(recPurchaseRCP."DI No.", rec."No.");
                    RecLPurchRCPLine.SetRange("Buy-from Vendor No.", rec."Vendor No.");
                    if recPurchaseRCP.FindFirst() then begin


                        RecLPurchRCPLine.SETRANGE(RecLPurchRCPLine."Document No.", recPurchaseRCP."No.");
                        RecLPurchRCPLine.SETRANGE(RecLPurchRCPLine.Type, RecLPurchRCPLine.Type::Item);
                        RecLPurchRCPLine.SETFILTER(Quantity, '<>%1', 0);
                        IF RecLPurchRCPLine.FINDFIRST THEN
                            REPEAT

                                DroitDouaneLEntry.RESET;
                                DroitDouaneLEntry.SETRANGE(DroitDouaneLEntry."DI No", Rec."No.");
                                DroitDouaneLEntry.SETRANGE(DroitDouaneLEntry.NGP, RecLPurchRCPLine."Tariff No.");
                                DroitDouaneLEntry.SETRANGE(DroitDouaneLEntry.Origin, RecLPurchRCPLine."Country region origin code");

                                IF (NOT DroitDouaneLEntry.FINDFIRST) THEN BEGIN
                                    DroitDouaneLEntry.LOCKTABLE;
                                    DroitDouaneLEntry.INIT;

                                    DroitDouaneLEntry."DI No" := Rec."No.";
                                    DroitDouaneLEntry.NGP := RecLPurchRCPLine."Tariff No.";
                                    DroitDouaneLEntry.Origin := RecLPurchRCPLine."Country region origin code";

                                    DroitDouaneLEntry.INSERT;
                                END;


                            UNTIL RecLPurchRCPLine.NEXT = 0;
                    end else
                        Message('Aucune réception n''est associée au dossier %1', Rec."No.");
                end;
            }
            action("Gérer les prix de vente")
            {
                Image = PriceWorksheet;
                ApplicationArea = all;
                trigger OnAction()
                var
                    RcptLine: Record "Purch. Rcpt. Line";
                    RcptHeader: Record "Purch. Rcpt. Header";
                begin
                    RcptHeader.SetRange("DI No.", Rec."No.");
                    RcptHeader.FindFirst();
                    RcptLine.SetRange("Document No.", RcptHeader."No.");
                    Page.RunModal(Page::"Purch Rcpt Pricing Worksheet", RcptLine);
                end;

            }
        }
    }

    var


    trigger OnAfterGetRecord()
    begin
        Rec."Creation Date" := Today;
    end;



}