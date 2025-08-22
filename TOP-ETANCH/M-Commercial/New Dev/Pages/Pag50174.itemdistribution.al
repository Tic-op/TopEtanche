
page 50174 "itemdistribution"
{
    ApplicationArea = All;
    Caption = 'item distribution';
    PageType = Worksheet;
    SourceTable = "Item Distribution";
    //SourceTableTemporary = true;
    DeleteAllowed = false;
    InsertAllowed = false;


    layout
    {
        area(Content)
        {
            grid(quantity)
            {

                field("Totale"; "quantité totale")
                {
                    Caption = 'Demandée';
                    enabled = false;
                    editable = false;
                    DecimalPlaces = 0 : 3;
                    ApplicationArea = all;
                }
                field("Affectée"; "quantité affectée")
                {
                    Enabled = false;
                    Editable = false;
                    decimalPlaces = 0 : 3;
                    ApplicationArea = all;

                }

                field("Nombre des OT"; Rec."Nbr Ordre Transfert")
                {
                    Caption = 'Nombre OT';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = visibilitytransfer;
                    DrillDownPageId = "Transfer Orders";
                }
            }
            repeater(General)
            {
                field(Item; Rec.Item)
                {
                    ToolTip = 'Specifies the value of the Article field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Magasin field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ToolTip = 'Specifies the value of the Emplacement field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Disponibilité field.', Comment = '%';
                    Editable = false;
                    caption = 'Disponibilité';
                    DecimalPlaces = 0 : 3;
                    ApplicationArea = all;
                }
                field("Qté Base Sortie"; Rec."Qté Base Sortie")
                {
                    editable = false;
                    decimalplaces = 0 : 3;
                    ApplicationArea = all;
                }
                /*  field("Qty Minimum"; Rec."Qty Minimum")
                 {
                     Caption = 'Minimum à transférer';
                     ApplicationArea = all;
                     Editable = false;
                     DecimalPlaces = 0 : 3;
                     Visible = visibilitytransfer;
                 } */
                field("Stock min"; Rec."Stock min")
                {
                    Caption = 'Stock min';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 3;
                    Visible = visibilitytransfer;
                }
                field("Qty à transférer"; Rec."Qty à transférer")
                {
                    DecimalPlaces = 0 : 3;
                    ApplicationArea = all;
                    Visible = visibilitytransfer;
                    trigger Onvalidate()
                    var
                        itemdist: Record "Item Distribution";
                        itemrec: Record item;
                    begin

                        itemdist.CalcSums("Qty à transférer");

                        "quantité affectée" := itemdist."Qty à transférer" + rec."Qty à transférer" - xRec."Qty à transférer";
                        if rec."Qty à transférer" > rec.qty then
                            error('la quantité saisie est supérieure à la quantité disponible dans le stock');


                        itemrec.get(rec.Item);
                        itemrec."ControlUnitéDépot"(rec."Qty à transférer", rec."Location Code");

                    end;

                }

                field("Qty to assign"; Rec."Qty to assign")
                {
                    ToolTip = 'Specifies the value of the Quantité à affecter field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                    ApplicationArea = all;
                    Visible = not visibilitytransfer;
                    trigger OnValidate()
                    var
                        itemdist: Record "Item Distribution";
                        itemrec: Record item;

                    begin
                        // calcQty();

                        //       "quantité affectée" += Rec."Qty to assign" - xRec."Qty to assign";

                        itemdist.CalcSums("Qty to assign");
                        //if rec."Qty to assign" <> xrec."Qty to assign" then
                        "quantité affectée" := itemdist."Qty to assign" + rec."Qty to assign" - xRec."Qty to assign";
                        if "quantité affectée" > "quantité totale" then
                            error('vous avez dépasser la quantité de la ligne vente');
                        if rec."Qty to assign" > rec.qty then
                            error('la quantité saisie est supérieure à la quantité disponible dans le stock');

                        //  message('%1 %2', "quantité affectée", "quantité totale");


                        itemrec.get(rec.Item);
                        itemrec."ControlUnitéDépot"(rec."Qty to assign", rec."Location Code");

                    end;
                }



            }
        }


    }
    actions
    {
        area(processing)
        {
            action(ValiderDistribution)
            {
                Caption = 'Valider transfert';
                ApplicationArea = All;
                Image = Approve;
                Visible = visibilitytransfer;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin

                    CreateTransfer();
                    CurrPage.Close();
                end;

            }



        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not visibilitytransfer then begin
            if Rec.FindFirst() then
                repeat
                    InsertInOrder();
                until Rec.Next() = 0;
        end;


    end;

    procedure SetDoc(Type0: enum "Sales Document Type"; Doc0: code[25]; Line0: Integer; total: Decimal)
    begin
        Doc := Doc0;
        Line := Line0;
        "quantité totale" := total;
        typeDocumentVente := type0;
        if Rec.Findfirst() then
            repeat
                Rec."Source Doc No." := Doc0;
                Rec."Source Line No." := Line0;
                Rec.Modify();
            until Rec.Next() = 0;
    end;



    procedure InsertInOrder()
    var
        SL: Record "Sales Line";
        SlToDelete: Record "Sales Line";
        insertLineNo: Integer;
        itemdist: Record "Item Distribution";
        SLToTestLocationExist: Record "Sales Line";

    begin
        SlToDelete.Get(SlToDelete."Document Type"::Order, doc, Line);
        SL.Init();
        SL := SlToDelete;

        if not visibilitytransfer then begin
            Rec.SetFilter("Qty to assign", '>0');
            if Rec.FindFirst() then
                repeat
                    SL."Line No." := SL.GetLastLineNo() + 1000;
                    SL."Location Code" := Rec."Location Code";
                    SL.Validate("Quantity (Base)", Rec."Qty to assign");
                    SL.Validate("Qty. to Ship (Base)", Rec."Qty to assign");
                    SL.Validate("Line Discount %", SlToDelete."Line Discount %");
                    SL.Insert();
                    SL.Validate("Bin Code", Rec."Bin Code");
                    SL.Modify();
                until Rec.Next() = 0;

            itemdist.CalcSums("Qty to assign");
            "quantité affectée" := itemdist."Qty to assign";

            if Confirm('Voulez vous vraiment quitter ? \ Quantité demandée %1 \ Quantité affectée %2 ', true, "quantité totale", "quantité affectée") then
                TestSortie()
            else
                Error('');

            if "quantité affectée" = "quantité totale" then
                SlToDelete.Delete();



        end;
    end;

    procedure TestSortie()
    var
    begin
        if "quantité affectée" < "quantité totale" then begin

            if visibilitytransfer then begin
                if "quantité affectée" = 0 then
                    message('Aucune distribution effectuée pour le transfert.')
                else
                    error('Vous devez affecter la totalité de la quantité pour le transfert.');
            end else begin
                if "quantité affectée" = 0 then
                    message('Vous n''avez rien Distribué.')
                else
                    error('Vous devez affecter la totalité de la quantité.');
            end;

        end;
    end;


    procedure initvalue(x: Integer)
    var
        ItemRec: Record Item;
    begin
        /*  typeDocumentVente := Y; */
        visibilitytransfer := false;
        if x = 1 then begin
            visibilitytransfer := true;
            if ItemRec.Get(Rec.Item) then
                Caption := Rec.Item + ' - ' + ItemRec.Description;
        end;

    end;

    local procedure CreateTransfer()
    var
        SalesLine: Record "Sales Line";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        BinContent: Record "Bin Content";
        TransferOrder: Page "Transfer Order";
        LineNo: Integer;
        QtyToTransfer: Decimal;
        CurrentSourceLocation: Code[10];
        LastSourceLocation: Code[10];
        TransferNo: Code[20];
        stockmin: record "Item stock min by location";
        item: Record Item;
        "Qté par unité Sortie": decimal;
        "Qté réelle à transferer": decimal;



    begin
        /*  IF type = 1 then begin */
        //    if (type = "Sales Document Type"::Order) or (type = "Sales Document Type"::"Blanket Order") then begin

        /*     if not SalesLine.Get(SalesLine."Document Type", Doc, Line) then
                Error('Ligne vente source non trouvée');
 */
        /*  end else
             if not SalesLine.Get(SalesLine."Document Type"::"Blanket Order", Doc, Line) then
                 Error('Ligne vente source non trouvée'); */

        SalesLine.get(typeDocumentVente, rec."Source Doc No.", Rec."Source Line No.");

        LastSourceLocation := '';
        TransferNo := '';
        item.get(rec.Item);

        Rec.SetFilter("Qty à transférer", '>0');
        if Rec.Findfirst() then
            repeat
                CurrentSourceLocation := Rec."Location Code";

                if Rec."Qty à transférer" <= 0 then
                    Error('Quantité invalide pour l''article %1', Rec.Item);

                if CurrentSourceLocation <> LastSourceLocation then begin
                    TransferHeader.Init();
                    TransferHeader."No." := '';
                    TransferHeader."Transfer-from Code" := CurrentSourceLocation;
                    TransferHeader."Transfer-to Code" := SalesLine."Location Code";
                    // TransferHeader."In-Transit Code" := CodeTransit();
                    TransferHeader."Source No." := Doc;
                    TransferHeader."Source Line No." := Line;
                    TransferHeader."Direct Transfer" := true;
                    TransferHeader.Insert(true);
                    TransferNo := TransferHeader."No.";
                    LastSourceLocation := CurrentSourceLocation;
                    Message('Création ordre de transfert %1 depuis %2', TransferNo, CurrentSourceLocation);
                end;

                stockmin.SetRange(Item, Rec.Item);
                //stockmin.SetRange(Location, CurrentSourceLocation);
                stockmin.SetRange(Location, TransferHeader."Transfer-to Code");

                /* if Rec."Bin Code" <> '' then
                    stockmin.SetRange("Bin code", Rec."Bin Code"); */

                if stockmin.FindFirst() then begin
                    if stockmin."Stock min" = 0 then
                        QtyToTransfer := Rec."Qty à transférer"
                    else begin
                        if Rec."Qty à transférer" < stockmin."Stock min" then
                            QtyToTransfer := stockmin."Stock min" - item."CalcDisponibilité"(rec.Item, SalesLine."Location Code", '');

                        //QtyToTransfer := Rec."Qty à transférer";
                    end;
                end
                else begin

                    QtyToTransfer := Rec."Qty à transférer";
                end;
                "Qté réelle à transferer" := ((QtyToTransfer div item."CalcQuantitéBaseSortie"(rec."Location Code")) + 1) * item."CalcQuantitéBaseSortie"(rec."Location Code");


                if CurrentSourceLocation = SalesLine."Location Code" then
                    Error('Le magasin source et le magasin destination sont identiques !');
                if QtyToTransfer > 0 then begin
                    LineNo += 10000;
                    TransferLine.Init();
                    TransferLine."Document No." := TransferNo;
                    TransferLine."Line No." := LineNo;
                    TransferLine.Validate("Item No.", Rec.Item);
                    TransferLine.Validate("Transfer-from Code", CurrentSourceLocation);
                    TransferLine.Validate("Transfer-to Code", SalesLine."Location Code");
                    TransferLine.Validate(Quantity, QtyToTransfer);

                    if Rec."Bin Code" <> '' then begin
                        BinContent.Reset();
                        BinContent.SetRange("Location Code", CurrentSourceLocation);
                        BinContent.SetRange("Bin Code", Rec."Bin Code");

                        if not BinContent.FindFirst() then
                            Error('Le Bin Code %1 n''existe pas dans le magasin %2.', Rec."Bin Code", CurrentSourceLocation);

                        TransferLine.Validate("Transfer-from Bin Code", Rec."Bin Code");
                    end;

                    TransferLine.Insert(true);
                end
            until Rec.Next() = 0;


    end;




    local procedure FromLocation(): Code[10]
    begin
        Rec.SetFilter("Qty à transférer", '>0');
        if Rec.FindFirst() then
            exit(Rec."Location Code");
    end;

    local procedure CodeTransit(): Code[10]
    var
        Location: Record Location;
    begin
        Location.SetRange("Use As In-Transit", true);
        if Location.FindFirst() then
            exit(Location.Code)

    end;




    var

        Doc: code[25];
        Line: Integer;
        "quantité totale": decimal;
        "quantité affectée": decimal;
        "Qty Available": Decimal;
        "Qty Souhaitée": Decimal;
        itemdistributiontotal: record "Item Distribution";

        pg: page "General Journal";
        visibilitytransfer: Boolean;
        SL: Record "Sales Line";
        typeDocumentVente: Enum "Sales Document Type";

    //stockmin: Record "Item stock min by location";

}
