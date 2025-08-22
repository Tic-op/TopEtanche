namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;

pageextension 50016 PurchaseOrderExt extends "Purchase Order"
{

    layout
    {

    }
    actions
    {
        addlast(Processing)
        {

            action(GenerateCACFromConfirm)
            {
                ApplicationArea = All;
                Caption = 'Insérer Lignes depuis Confirmations';
                Image = CreateWhseLoc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ReportObject: Report "Gén. Cmde depuis Confirmation";
                begin
                    if not Confirm('Voulez-vous insérer des Confirmations pour une réception prévue ?') then
                        exit;
                    ReportObject.SetParameters(Rec."No.");
                    ReportObject.run;
                end;
            }

            action(AffecterConfirmation)
            {
                ApplicationArea = All;
                Caption = 'Affecter Confirmation';
                Image = CoupledQuote;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    PurchaseLine: Record "Purchase Line";
                    DOPLine: Record "Purchase Line";
                    RestantDOP: Decimal;
                    DOPfound: Boolean;

                begin

                    Error('A réviser');
                    if not Confirm('Voulez-vous affecter des DOP aux lignes restantes ?') then
                        exit;
                    rec.TestField(Status, rec.Status::Open);

                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SetRange("Document No.", rec."No.");
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetRange("Blanket Order No.", '');
                    PurchaseLine.SetRange(PurchaseLine."Blanket Order Line No.", 0);

                    if PurchaseLine.FindFirst() then
                        repeat

                            DOPfound := false;
                            DOPLine.SetRange("Document Type", DOPLine."Document Type"::"Blanket Order");
                            DOPLine.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                            DOPLine.SetRange("Confirmé par fournisseur", true);
                            DOPLine.SetRange("Direct Unit Cost", PurchaseLine."Direct Unit Cost");
                            DOPLine.SetRange("Line Discount %", PurchaseLine."Line Discount %");
                            DOPLine.SetRange("Entry Point", PurchaseLine."Entry Point");
                            //    DOPLine.SetAutoCalcFields("DOP sur Commande", "DOP sur Réception");

                            if DOPLine.FindFirst() then
                                repeat
                                    RestantDOP := DOPLine.Quantity - DOPLine."DOP sur Commande" - DOPLine."DOP sur Réception";
                                    if PurchaseLine.Quantity <= RestantDOP then begin
                                        PurchaseLine.Validate("DOP No.", DOPLine."Document No.");
                                        PurchaseLine.Validate("DOP Line No.", DOPLine."Line No.");
                                        PurchaseLine.Modify();
                                        DOPfound := true;
                                    end;

                                until DOPfound OR (DOPLine.Next() = 0);


                        until PurchaseLine.next = 0;



                end;
            }


            action(ExtraireLigneCAC)
            {
                Caption = 'Extraire lignes commande cadre';
                Image = Export;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ListeCAC: Page 50022;
                    PurchaseLine: Record "Purchase Line";
                begin
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::"Blanket Order");
                    PurchaseLine.SetRange("Buy-from Vendor No.", Rec."Buy-from Vendor No.");

                    if PurchaseLine.FindFirst() then
                        repeat
                            if PurchaseLine.Restant > 0 then
                                PurchaseLine.Mark := true;
                        until PurchaseLine.next = 0;

                    PurchaseLine.MarkedOnly(true);



                    ListeCAC.SetTableView(PurchaseLine);

                    ListeCAC.Init(Rec."No.");
                    ListeCAC.RunModal();
                end;

            }
        }
    }

}

