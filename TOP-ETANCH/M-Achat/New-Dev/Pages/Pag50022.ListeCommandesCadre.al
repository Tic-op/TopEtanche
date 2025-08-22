namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;

page 50022 "Liste lignes commandes cadres"
{
    ApplicationArea = All;
    Caption = 'Liste des commandes cadres';
    PageType = List;
    SourceTable = "Purchase Line";
    //UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = where("Document Type" = filter("Blanket Order"));// Restant = filter('>0')


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'N° document';
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Fournisseur';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    Caption = 'Type';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Caption = 'Article';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Tariff No."; Rec."Tariff No.")
                {
                    Caption = 'NGP';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Country region origin code"; Rec."Country region origin code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantité';
                    ApplicationArea = all;
                    Editable = false;

                }
                field("A commander"; Rec."A commander")
                {
                    ApplicationArea = All;


                }

                field(Restant; Rec.Restant - rec."A commander")
                {
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 3;

                }
                /*   field("Qty commandée"; Rec."Qty commandée")
                  {
                      ApplicationArea = all;
                      Editable = false;


                  } */

                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    Caption = 'Coût unitaire direct HT';
                    ApplicationArea = all;
                    Editable = false;
                }
                /*  field(marked; Rec.Marked)
                 {
                     ApplicationArea = all;
                     Caption = 'Sélection';

                     trigger OnValidate()
                     begin
                         if rec.Marked then
                             rec.NoCommandeAchat := NoCommandeAchatEnCours
                         else
                             rec.NoCommandeAchat := '';
                         rec.Validate("A commander", 0);

                         CurrPage.Update();
                     end;

                 } */



            }
        }
    }

    actions
    {
        area(Processing)
        {
            /*   action(InsereLigne)
              {
                  Caption = 'Insérer ligne sélectionnée';
                  ApplicationArea = All;
                  Image = Add;
                  Promoted = true;
                  PromotedCategory = Process;
                  PromotedOnly = true;

                  trigger OnAction()
                  var
                      PurchaseHeader: Record "Purchase Header";
                      NewLine: Record "Purchase Line";
                      PurchaseLine2: Record "Purchase Line";
                      Exist: Record "Purchase Line";
                  begin
                      if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, NoCommandeAchatEnCours) then begin
                          PurchaseLine2.SetRange("Document Type", PurchaseLine2."Document Type"::"Blanket Order");
                          PurchaseLine2.SetFilter(PurchaseLine2.NoCommandeAchat, NoCommandeAchatEnCours);
                          PurchaseLine2.SetRange(PurchaseLine2.Marked, true);
                          PurchaseLine2.SetFilter(PurchaseLine2."A commander", '>0');

                          if PurchaseLine2.findfirst() then begin
                              repeat
                                  if PurchaseLine2.Marked then begin
                                      Exist.SetRange("Document Type", Exist."Document Type"::Order);
                                      Exist.SetRange("Document No.", PurchaseHeader."No.");
                                      Exist.SetRange("No.", PurchaseLine2."No.");
                                      if Exist.FindFirst() then begin
                                          //  Exist."Qty commandée" := Exist.Quantity + PurchaseLine2."A commander";
                                          exist.Validate("Quantity (Base)", Exist."Quantity (Base)" + PurchaseLine2."A commander");
                                          Exist."A commander" := 0;
                                          Exist.Restant := Exist.Quantity - (Exist."Qty commandée" + Exist."A commander");
                                          Exist.Modify();
                                      end else begin
                                          NewLine.Init();
                                          NewLine.Validate("Document Type", NewLine."Document Type"::Order);
                                          NewLine.Validate("Document No.", PurchaseHeader."No.");
                                          NewLine.Validate(Type, PurchaseLine2.Type);
                                          NewLine.Validate("No.", PurchaseLine2."No.");
                                          NewLine.Validate(Quantity, PurchaseLine2."A commander");
                                          NewLine.Validate("Direct Unit Cost", PurchaseLine2."Direct Unit Cost");
                                          NewLine.Validate("Unit of Measure", PurchaseLine2."Unit of Measure");
                                          NewLine.Validate("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                                          NewLine.Validate("Blanket Order No.", PurchaseLine2."Document No.");
                                          NewLine.Validate("Blanket Order Line No.", PurchaseLine2."Line No.");
                                          NewLine."Line No." := GetNextLineNo(PurchaseHeader."No.");
                                          NewLine.Insert(true);
                                      end;

                                      // PurchaseLine2."A commander" := 0;
                                  end;
                              until PurchaseLine2.Next() = 0;
                              CurrPage.Update();
                              Message('Lignes insérées');

                              PurchaseLine2.Reset();
                              PurchaseLine2.SetRange("Document Type", PurchaseLine2."Document Type"::"Blanket Order");
                              PurchaseLine2.SetFilter(PurchaseLine2.NoCommandeAchat, NoCommandeAchatEnCours);
                              // PurchaseLine2.SetFilter(Restant, '>0');
                              //PurchaseLine2.SetRange(PurchaseLine2.Marked, true);

                              if PurchaseLine2.FindFirst() then
                                  repeat
                                      if PurchaseLine2."A commander" <> 0 then begin
                                          PurchaseLine2."A commander" := 0;
                                          PurchaseLine2.Modify();
                                      end;
                                  until PurchaseLine2.Next() = 0;
                          end else
                              Message('Aucune ligne insérée ');
                      end;
                  end;



              } */

        }
    }

    var
        NoCommandeAchatEnCours: Code[20];

    procedure Init(NoCommande: Code[20])
    begin
        NoCommandeAchatEnCours := NoCommande;
    end;


    procedure GetNextLineNo(DocNo: Code[20]): Integer
    var
        PL: Record "Purchase Line";
    begin
        PL.SetRange("Document Type", PL."Document Type"::Order);
        PL.SetRange("Document No.", DocNo);
        if PL.FindLast() then
            exit(PL."Line No." + 10000);
        exit(10000);
    end;
    /*  trigger OnClosePage()
     var
         PurchaseLine2: Record "Purchase Line";

     begin
         PurchaseLine2.SetRange("Document Type", PurchaseLine2."Document Type"::"Blanket Order");
         PurchaseLine2.SetFilter(PurchaseLine2.NoCommandeAchat, NoCommandeAchatEnCours);
         PurchaseLine2.SetRange(PurchaseLine2.Marked, true);
         PurchaseLine2.ModifyAll(Marked, false);
         PurchaseLine2.ModifyAll(NoCommandeAchat, ''); 
     end;
  */


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        InsertMarkedLine();
    end;

    procedure InsertMarkedLine()
    var
        PurchaseHeader: Record "Purchase Header";
        NewLine: Record "Purchase Line";
        PurchaseLine2: Record "Purchase Line";
        Exist: Record "Purchase Line";
        NbrInserted: Integer;
        TotalAmount: Decimal;
    begin
        if not PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, NoCommandeAchatEnCours) then
            exit;

        PurchaseLine2.Copy(Rec);
        PurchaseLine2.MarkedOnly(true);

        if PurchaseLine2.FindFirst() then begin
            repeat
                if PurchaseLine2."A commander" > 0 then begin
                    NbrInserted += 1;
                    TotalAmount += PurchaseLine2."A commander" * PurchaseLine2."Direct Unit Cost";
                end;
            until PurchaseLine2.Next() = 0;
        end;

        if NbrInserted = 0 then begin
            Message('Aucune ligne sélectionnée');
            exit;
        end;

        if not Confirm('Vous avez sélectionné %1 lignes pour un montant de %2. Voulez-vous continuer ?', true, NbrInserted, TotalAmount) then
            exit;
        PurchaseLine2.FindFirst();
        repeat
            if PurchaseLine2."A commander" > 0 then begin

                Exist.SetRange("Document Type", Exist."Document Type"::Order);
                Exist.SetRange("Document No.", PurchaseHeader."No.");
                Exist.SetRange("No.", PurchaseLine2."No.");
                exist.SetRange("Blanket Order No.", PurchaseLine2."Document No.");
                Exist.SetRange("Blanket Order Line No.", PurchaseLine2."Line No.");
                Message('%1  %2', exist.Count, Exist.GetFilters);
                if Exist.FindFirst() then begin
                    Exist.Validate("Quantity (Base)", Exist."Quantity (Base)" + PurchaseLine2."A commander");
                    Exist."A commander" := 0;
                    Exist.Restant := Exist.Quantity - (Exist."Qty commandée" + Exist."A commander");
                    Exist.Modify();
                end else begin
                    NewLine.Init();
                    NewLine.Validate("Document Type", NewLine."Document Type"::Order);
                    NewLine.Validate("Document No.", PurchaseHeader."No.");
                    NewLine.Validate(Type, PurchaseLine2.Type);
                    NewLine.Validate("No.", PurchaseLine2."No.");
                    NewLine.Validate(Quantity, PurchaseLine2."A commander");
                    NewLine.Validate("Direct Unit Cost", PurchaseLine2."Direct Unit Cost");
                    NewLine.Validate("Unit of Measure", PurchaseLine2."Unit of Measure");
                    NewLine.Validate("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                    NewLine.Validate("Blanket Order No.", PurchaseLine2."Document No.");
                    NewLine.Validate("Blanket Order Line No.", PurchaseLine2."Line No.");
                    NewLine."Line No." := GetNextLineNo(PurchaseHeader."No.");
                    NewLine.Insert(true);

                end;
                PurchaseLine2."A commander" := 0;
                PurchaseLine2."MAJ_Qté_Restante"();
                PurchaseLine2.Modify();
            end;
        until PurchaseLine2.Next() = 0;

        CurrPage.Update();


    end;

}
