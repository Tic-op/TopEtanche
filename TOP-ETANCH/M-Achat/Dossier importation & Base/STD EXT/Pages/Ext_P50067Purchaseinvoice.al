/// <summary>
/// PageExtension purchaseinvoiceExt (ID 50067) extends Record Purchase Invoice.
/// </summary>
pageextension 50167 purchaseinvoiceExt extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("DI No."; Rec."DI No.")
            {
                ApplicationArea = all;
                Caption = 'No Dossier importation';
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            Group(Ventilation)
            {
                Image = Allocate;
                action(VentilerFrais)



                {
                    Image = Allocate;
                    caption = 'Ventiler les frais';
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        ItemChargePurch: record "Item Charge Assignment (Purch)";
                        recLPurchaselineInv: record "Purchase Line";
                        recITEMCHARGE: Record "Item Charge";
                        recLpurchRCPLine: record "Purch. Rcpt. Line";
                        recLpurchRcpHeader: Record "Purch. Rcpt. Header";
                        NumLine: Integer;
                        CUItemchargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
                        pg5805: page 5805;
                    begin

                        Rec.TESTFIELD("DI No.");
                        IF CONFIRM('Etes-vous sûr de ventiler les les frais de cette facture sur la réception ? ', FALSE) THEN BEGIN

                            ItemChargePurch.SETRANGE("Document Type", Rec."Document Type");
                            ItemChargePurch.SETRANGE("Document No.", Rec."No.");
                            // ItemChargePurch.SETFILTER("Item Charge No.", '<>%1', 'DD');
                            ItemChargePurch.SetRange("Droit Douane", false);

                            ItemChargePurch.DELETEALL;

                            recLPurchaselineInv.SETCURRENTKEY("Document Type", "Document No.", Type, "No.");
                            recLPurchaselineInv.SETRANGE("Document Type", Rec."Document Type");
                            recLPurchaselineInv.SETRANGE("Document No.", Rec."No.");
                            recLPurchaselineInv.SETRANGE(Type, recLPurchaselineInv.Type::"Charge (Item)");
                            recLPurchaselineInv.SetRange(recLPurchaselineInv."Droit douane", false);
                            recLPurchaselineInv.SetRange(recLPurchaselineInv.TVA, false);
                            IF recLPurchaselineInv.FINDFIRST THEN
                                REPEAT
                                    recITEMCHARGE.GET(recLPurchaselineInv."No.");
                                    IF recITEMCHARGE.Affectable THEN BEGIN ///////////////////////NOOOOOOTTTTT
                                        recLpurchRcpHeader.SetRange("DI No.", Rec."DI No.");
                                        if recLpurchRcpHeader.FindFirst() then

                                            // A vérifier une seule réception par Dossier import 
                                            recLpurchRCPLine.SETRANGE(recLpurchRCPLine."Document No.", recLpurchRcpHeader."No.");
                                        recLpurchRCPLine.SETRANGE(recLpurchRCPLine.Type, recLpurchRCPLine.Type::Item);
                                        IF recLpurchRCPLine.FINDFIRST THEN BEGIN
                                            NumLine := 0;
                                            REPEAT

                                                ItemChargePurch."Document Type" := Rec."Document Type";
                                                ItemChargePurch."Document No." := Rec."No.";
                                                ItemChargePurch."Document Line No." := recLPurchaselineInv."Line No.";
                                                ItemChargePurch."Line No." := NumLine + 10000;
                                                ItemChargePurch."Item Charge No." := recLPurchaselineInv."No.";
                                                ItemChargePurch.VALIDATE("Item No.", recLpurchRCPLine."No.");
                                                ItemChargePurch."Applies-to Doc. Type" := ItemChargePurch."Applies-to Doc. Type"::Receipt;
                                                ItemChargePurch."Applies-to Doc. Line No." := recLpurchRCPLine."Line No.";
                                                ItemChargePurch."Unit Cost" := recLPurchaselineInv."Unit Cost";
                                                ItemChargePurch."DI No." := Rec."DI No.";
                                                //  ItemChargePurch.insert;
                                                //Message('%1', ItemChargePurch);
                                                CUItemchargePurch.CreateRcptChargeAssgnt(recLpurchRCPLine, ItemChargePurch);
                                                //CUItemchargePurch.SuggestAssgnt(recLPurchaselineInv, recLPurchaselineInv."Qty. to Assign", recLPurchaselineInv.Amount);
                                                CUItemchargePurch.AssignItemCharges(recLPurchaselineInv, recLPurchaselineInv.Quantity, recLPurchaselineInv."Line Amount", 1);
                                                ItemChargePurch.FindLast();
                                                NumLine := ItemChargePurch."Line No.";
                                            UNTIL recLpurchRCPLine.NEXT = 0;
                                        END;
                                    END;
                                UNTIL recLPurchaselineInv.NEXT = 0;
                            MESSAGE('Ventilation des frais avec succès');
                        END;
                    end;
                }
                action(VentilerDD2)

                {
                    Image = Allocate;
                    Caption = 'Ventiler Droit douane';
                    ApplicationArea = all;
                    Visible = false;
                    trigger OnAction()
                    var
                        ItemChargePurch: record "Item Charge Assignment (Purch)";
                        recLPurchaselineInv: record "Purchase Line";
                        recITEMCHARGE: Record "Item Charge";
                        recLpurchRCPLine: record "Purch. Rcpt. Line";
                        recLpurchRcpHeader: Record "Purch. Rcpt. Header";
                        NumLine: Integer;
                        CUItemchargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
                        DroitDouaneLEntry: Record DroitDouaneLedgerEntry;
                        DroitDouaneLEntry2: Record DroitDouaneLedgerEntry;
                        LineNo, compteur : Integer;
                        percent, Somme_percent, Somme_ValueToAssig : Decimal;

                    // rec98: Record 98;


                    begin

                        Rec.TESTFIELD("DI No.");
                        ItemChargePurch.SETRANGE("Document Type", Rec."Document Type");
                        ItemChargePurch.SETRANGE("Document No.", Rec."No.");

                        ItemChargePurch.SETRANGE(ItemChargePurch."Droit Douane", true);

                        ItemChargePurch.DELETEALL;
                        // 



                        recLPurchaselineInv.SETRANGE("Document Type", Rec."Document Type");
                        recLPurchaselineInv.SETRANGE("Document No.", Rec."No.");
                        recLPurchaselineInv.SETRANGE(Type, recLPurchaselineInv.Type::"Charge (Item)");
                        //recLPurchaselineInv.SETRANGE(recLPurchaselineInv."No.", 'DD');
                        recLPurchaselineInv.SetRange(recLPurchaselineInv."Droit douane", true);

                        recLPurchaselineInv.FINDFIRST;
                        DroitDouaneLEntry.SetRange("DI No", rec."DI No.");
                        //DroitDouaneLEntry.FindFirst();
                        DroitDouaneLEntry.CalcSums(Amount);
                        if recLPurchaselineInv."Line Amount" <> DroitDouaneLEntry.Amount then
                            Error('La somme des Montants Droit douane pour Dossier Import %1  \%2 \est différent de Montant %3', Rec."DI No.", DroitDouaneLEntry.Amount, recLPurchaselineInv."Line Amount")
                        else begin

                            DroitDouaneLEntry2.SetRange("DI No", rec."DI No.");
                            DroitDouaneLEntry2.FindFirst();
                            repeat
                                DroitDouaneLEntry2.TestField(Amount);
                                DroitDouaneLEntry2.TestField(NGP);
                                //DroitDouaneLEntry2.TestField(Origin);

                                recLpurchRcpHeader.SetRange("DI No.", Rec."DI No.");

                                recLpurchRcpHeader.FindFirst();
                                percent := 0;// Initialize Percent for every NGP
                                             // A vérifier une seule réception par Dossier import
                                recLpurchRCPLine.SETRANGE(recLpurchRCPLine."Document No.", recLpurchRcpHeader."No.");
                                recLpurchRCPLine.SETRANGE(recLpurchRCPLine.Type, recLpurchRCPLine.Type::Item);
                                recLpurchRCPLine.SetRange("Tariff No.", DroitDouaneLEntry2.NGP);
                                recLpurchRCPLine.SetRange("Country region origin code", DroitDouaneLEntry2.Origin);
                                recLpurchRCPLine.SetFilter(Quantity, '<>0');

                                // Message(recLpurchRCPLine.GetFilters);
                                IF recLpurchRCPLine.FINDFIRST THEN BEGIN


                                    REPEAT
                                        LineNo += 1;
                                        compteur += 1;
                                        ItemChargePurch.init;
                                        ItemChargePurch."Document Type" := Rec."Document Type";
                                        ItemChargePurch."Document No." := Rec."No.";
                                        ItemChargePurch."Document Line No." := recLPurchaselineInv."Line No.";

                                        ItemChargePurch."Line No." := LineNo; //ItemChargePurch."Line No." + 10000;

                                        ItemChargePurch.validate("Item Charge No.", recLPurchaselineInv."No.");
                                        ItemChargePurch.VALIDATE("Item No.", recLpurchRCPLine."No.");
                                        ItemChargePurch.Description := DroitDouaneLEntry2.NGP + ' ' + DroitDouaneLEntry2.Origin;

                                        ItemChargePurch."Applies-to Doc. Type" := ItemChargePurch."Applies-to Doc. Type"::Receipt;
                                        ItemChargePurch."Applies-to Doc. No." := recLpurchRCPLine."Document No.";
                                        ItemChargePurch."Applies-to Doc. Line No." := recLpurchRCPLine."Line No.";

                                        ItemChargePurch.validate("Unit Cost", DroitDouaneLEntry2.Amount);
                                        ItemChargePurch."DI No." := Rec."DI No.";
                                        ItemChargePurch."Droit Douane" := true;
                                        //ItemChargePurch.
                                        if compteur <> recLpurchRCPLine.Count then begin
                                            percent := ROUND((recLpurchRCPLine.Quantity * recLpurchRCPLine."Direct Unit Cost" * (1 - recLpurchRCPLine."Line Discount %" / 100))
                                            / GetTotalAmountNGP_inReceiptLines(recLpurchRCPLine."Document No.", DroitDouaneLEntry2.NGP, DroitDouaneLEntry2.Origin)
                                            , 0.00001, '=');


                                            ItemChargePurch.Validate("Amount to Assign", DroitDouaneLEntry2.Amount * percent);
                                            ItemChargePurch.Validate("Qty. to Assign", percent);
                                            ItemChargePurch.Validate("Amount to Handle", DroitDouaneLEntry2.Amount * percent);
                                            ItemChargePurch.Validate("Qty. to Handle", percent);
                                            Somme_percent += percent;
                                            Somme_ValueToAssig += ROUND(DroitDouaneLEntry2.Amount * percent);

                                            ///


                                        end
                                        else begin
                                            ItemChargePurch.Validate("Amount to Assign", DroitDouaneLEntry2.Amount - Somme_ValueToAssig);
                                            ItemChargePurch.Validate("Qty. to Assign", 1 - Somme_percent);



                                        end;
                                        ///

                                        ///Message('%1--%2', DroitDouaneLEntry2.Amount, percent);


                                        ItemChargePurch.Insert();
                                    // Message('%1', ItemChargePurch);

                                    // CUItemchargePurch.CreateRcptChargeAssgnt(recLpurchRCPLine, ItemChargePurch);

                                    //TotalMtDD += 


                                    UNTIL recLpurchRCPLine.NEXT = 0;




                                    //      CUItemchargePurch.AssignItemCharges(recLPurchaselineInv, recLPurchaselineInv.Quantity, DroitDouaneLEntry2.Amount, 1);



                                END;

                            UNTIL DroitDouaneLEntry2.NEXT = 0;
                            MESSAGE('Ventilation de Droit Douane avec Succès');
                        end;

                    end;
                }


                action("Ventiler DD OD")

                {
                    Image = Allocate;
                    Caption = 'Ventiler DD';
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        ItemChargePurch: record "Item Charge Assignment (Purch)";
                        recLPurchaselineInv: record "Purchase Line";
                        recITEMCHARGE: Record "Item Charge";
                        recLpurchRCPLine: record "Purch. Rcpt. Line";
                        recLpurchRcpHeader: Record "Purch. Rcpt. Header";
                        NumLine: Integer;
                        CUItemchargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
                        DroitDouaneLEntry: Record DroitDouaneLedgerEntry;
                        DroitDouaneLEntry2: Record DroitDouaneLedgerEntry;
                        LineNo: Integer;
                        percentItemFromTotalNGP: Decimal;
                        PercentNgpFromTotalDI: decimal;
                        TotalPerc: decimal;

                        compteur: Integer;



                    begin
                        Rec.TESTFIELD("DI No.");
                        ItemChargePurch.SETRANGE("Document Type", Rec."Document Type");
                        ItemChargePurch.SETRANGE("Document No.", Rec."No.");

                        ItemChargePurch.SETRANGE(ItemChargePurch."Droit Douane", true);

                        ItemChargePurch.DELETEALL;
                        // ALL IS GOOD



                        recLPurchaselineInv.SETRANGE("Document Type", Rec."Document Type");
                        recLPurchaselineInv.SETRANGE("Document No.", Rec."No.");
                        recLPurchaselineInv.SETRANGE(Type, recLPurchaselineInv.Type::"Charge (Item)");
                        recLPurchaselineInv.SetRange(recLPurchaselineInv."Droit douane", true);

                        recLPurchaselineInv.FINDFIRST;
                        DroitDouaneLEntry.SetRange("DI No", rec."DI No.");
                        DroitDouaneLEntry.CalcSums(Amount);


                        if recLPurchaselineInv."Line Amount" <> DroitDouaneLEntry.Amount then
                            Error('La somme des Montants Droit douane pour Dossier Import %1  \%2 \est différent de Montant %3', Rec."DI No.", DroitDouaneLEntry.Amount, recLPurchaselineInv."Line Amount");

                        if recLPurchaselineInv.Quantity <> 1 then
                            Error('La quantité de Droit douane doit être égale à 1');
                        recLpurchRcpHeader.SetRange("DI No.", Rec."DI No.");

                        recLpurchRcpHeader.FindFirst();



                        recLpurchRCPLine.SETRANGE(recLpurchRCPLine."Document No.", recLpurchRcpHeader."No.");
                        recLpurchRCPLine.SETRANGE(recLpurchRCPLine.Type, recLpurchRCPLine.Type::Item);
                        recLpurchRCPLine.SetFilter(Quantity, '<>0');

                        IF recLpurchRCPLine.FINDFIRST THEN
                            REPEAT

                                recLpurchRCPLine.TestField("Tariff No.");
                                recLpurchRCPLine.TestField("Country region origin code");
                                DroitDouaneLEntry2.get(Rec."DI No.", recLpurchRCPLine."Tariff No.", recLpurchRCPLine."Country region origin code");
                                DroitDouaneLEntry2.TestField(Amount);

                                PercentNgpFromTotalDI := round(DroitDouaneLEntry2.Amount / recLPurchaselineInv.Amount);

                                LineNo += 1;
                                ItemChargePurch.init;
                                ItemChargePurch."Document Type" := Rec."Document Type";
                                ItemChargePurch."Document No." := Rec."No.";
                                ItemChargePurch."Document Line No." := recLPurchaselineInv."Line No.";

                                ItemChargePurch."Line No." := LineNo;

                                ItemChargePurch.validate("Item Charge No.", recLPurchaselineInv."No.");
                                ItemChargePurch.VALIDATE("Item No.", recLpurchRCPLine."No.");
                                ItemChargePurch.Description := DroitDouaneLEntry2.NGP + '/' + DroitDouaneLEntry2.Origin;

                                ItemChargePurch."Applies-to Doc. Type" := ItemChargePurch."Applies-to Doc. Type"::Receipt;
                                ItemChargePurch."Applies-to Doc. No." := recLpurchRCPLine."Document No.";
                                ItemChargePurch."Applies-to Doc. Line No." := recLpurchRCPLine."Line No.";

                                ItemChargePurch.validate("Unit Cost", DroitDouaneLEntry.Amount);
                                ItemChargePurch."DI No." := Rec."DI No.";
                                ItemChargePurch."Droit Douane" := true;

                                percentItemFromTotalNGP := round(recLpurchRCPLine.Quantity * recLpurchRCPLine."Direct Unit Cost" * (1 - recLpurchRCPLine."Line Discount %" / 100)
                                / GetTotalAmountNGP_inReceiptLines(recLpurchRCPLine."Document No.", DroitDouaneLEntry2.NGP, DroitDouaneLEntry2.Origin));


                                compteur += 1;
                                if compteur <> recLpurchRCPLine.Count then begin
                                    ItemChargePurch.Validate("Qty. to Assign", PercentNgpFromTotalDI * percentItemFromTotalNGP);
                                    ItemChargePurch.Validate("Qty. to Handle", PercentNgpFromTotalDI * percentItemFromTotalNGP);

                                    TotalPerc += PercentNgpFromTotalDI * percentItemFromTotalNGP;

                                end
                                else begin
                                    ItemChargePurch.Validate("Qty. to Assign", 1 - TotalPerc);
                                    ItemChargePurch.Validate("Qty. to Handle", 1 - TotalPerc);
                                    TotalPerc += 1 - TotalPerc;
                                end;



                                ItemChargePurch.Insert();

                            until recLpurchRCPLine.Next() = 0;

                        //Message('TotalPerc %1 ', TotalPerc);
                    end;



                }


            }



        }
    }
    local procedure GetTotalAmountNGP_inReceiptLines(docNo: code[20]; Ngp: code[20]; Origin: code[20]) total: Decimal
    var
        recLpurchRCPLine: Record 121;
    begin
        recLpurchRCPLine.SetFilter("Document No.", docNo);

        recLpurchRCPLine.SetRange("Tariff No.", Ngp);
        recLpurchRCPLine.SetRange("Country region origin code", Origin);
        recLpurchRCPLine.SetRange(Type, recLpurchRCPLine.Type::Item);
        recLpurchRCPLine.SetFilter(Quantity, '<>0');
        recLpurchRCPLine.FindFirst();
        repeat
            total += recLpurchRCPLine.Quantity * recLpurchRCPLine."Direct Unit Cost" * (1 - recLpurchRCPLine."Line Discount %" / 100);
        until recLpurchRCPLine.next = 0;
        if total = 0 then begin
            recLpurchRCPLine.FindFirst();
            repeat
                total += recLpurchRCPLine.Quantity * recLpurchRCPLine."Direct Unit Cost";
            until recLpurchRCPLine.next = 0;
        end;
    end;
}