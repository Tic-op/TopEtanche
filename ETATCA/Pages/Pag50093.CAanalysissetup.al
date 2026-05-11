namespace Top.Top;
using Microsoft.Inventory.Ledger;

page 50093 "CA analysis setup"
{
    ApplicationArea = All;
    Caption = 'Analyse chiffre d''affaire';
    PageType = Worksheet;
    UsageCategory = Administration;
    SourceTable = "CA Analysis Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(Parametres)
            {
                field(TypePeriode; TypePeriode)
                {
                    Caption = 'Type période';
                }

                field(DateDebut; DateDebut)
                {
                    Caption = 'Date début';
                }

                field(DateFin; DateFin)
                {
                    Caption = 'Date fin';
                }
            }
            repeater(resultat)
            {
                field(Description; Rec.Description)
                {
                    Caption = 'Indicateur';
                }

                field("CA Current"; Rec."CA Current")
                {
                    Caption = 'CA période';
                }

                /*  field("CA Previous"; Rec."CA Previous")
                 {
                     Caption = 'CA période précédente';
                 } */

                field("Variation %"; Rec."Variation %")
                {
                    Caption = 'Variation %';
                }
                /*    part(Result; "CA Analysis Part")
                   {
                       ApplicationArea = All;

                   } */

            }


        }
    }

    actions
    {
        area(processing)
        {
            action(Calculer)
            {
                Caption = 'Calculer CA';

                trigger OnAction()
                begin
                    RunAnalysis(TypePeriode, DateDebut, DateFin);
                end;
            }
        }
    }

    var
        TypePeriode: Enum "Period Type";
        DateDebut: Date;
        DateFin: Date;

    procedure RunAnalysis(TypePeriode: Enum "Period Type"; StartDate: Date; EndDate: Date)
    var
        ILE: Record "Item Ledger Entry";
        PeriodStart: Date;
        PeriodEnd: Date;
        AmountCurrent: Decimal;
        AmountPrevious: Decimal;
        i: Integer;
    begin
        Rec.DeleteAll();

        PeriodStart := StartDate;
        i := 0;

        while PeriodStart <= EndDate do begin

            // ===== définir période =====
            GetPeriod(TypePeriode, PeriodStart, PeriodEnd);

            if PeriodEnd > EndDate then
                PeriodEnd := EndDate;

            // ===== CA période actuelle =====
            ILE.Reset();
            ILE.SetRange("Posting Date", PeriodStart, PeriodEnd);
            ILE.CalcSums("Sales Operation Amount");
            AmountCurrent := ILE."Sales Operation Amount";

            // ===== CA période précédente =====
            ILE.Reset();
            ILE.SetRange("Posting Date",
                         CalcDate('<-1D>', PeriodStart),
                         CalcDate('<-1D>', PeriodEnd));

            ILE.CalcSums("Sales Operation Amount");
            AmountPrevious := ILE."Sales Operation Amount";

            // ===== insertion ligne =====
            i += 1;

            Rec.Init();
            Rec."Line No." := i;
            Rec.Description := Format(PeriodStart) + ' - ' + Format(PeriodEnd);
            Rec."CA Current" := AmountCurrent;
            Rec."CA Previous" := AmountPrevious;

            if AmountPrevious <> 0 then
                Rec."Variation %" := ((AmountCurrent - AmountPrevious) / AmountPrevious) * 100;

            Rec.Insert();

            // ===== avancer période =====
            PeriodStart := PeriodEnd + 1;
        end;

        CurrPage.Update(false);
    end;

    procedure RunAnalysis0(TypePeriode: Enum "Period Type"; StartDate: Date; EndDate: Date)
    var
        ILE: Record "Item Ledger Entry";
        PrevStart: Date;
        PrevEnd: Date;
        CA1: Decimal;
        CA2: Decimal;
        Buffer: Record "CA Analysis Buffer" temporary;
    begin
        Buffer.DeleteAll();

        // période actuelle
        ILE.Reset();
        ILE.SetRange("Posting Date", StartDate, EndDate);
        ILE.CalcSums("Sales Operation Amount");
        CA1 := ILE."Sales Operation Amount";

        // période précédente
        PrevEnd := StartDate - 1;
        PrevStart := CalcDate('<-1M>', StartDate); // simplifié V1

        ILE.Reset();
        ILE.SetRange("Posting Date", PrevStart, PrevEnd);
        ILE.CalcSums("Sales Operation Amount");
        CA2 := ILE."Sales Operation Amount";

        Buffer.Init();
        Buffer."Line No." := 1;
        Buffer.Description := 'Chiffre d''affaires';
        Buffer."CA Current" := CA1;
        Buffer."CA Previous" := CA2;

        if CA2 <> 0 then
            Buffer."Variation %" := ((CA1 - CA2) / CA2) * 100;

        Buffer.Insert();

        Rec := Buffer;
        Rec.Insert();

        CurrPage.Update(false);
    end;

    local procedure GetPeriod(TypePeriode: Enum "Period Type"; StartDate: Date; var EndDate: Date)
    begin
        case TypePeriode of

            TypePeriode::Day:
                EndDate := StartDate;

            TypePeriode::Week:
                EndDate := CalcDate('<+1W-1D>', StartDate);

            TypePeriode::Month:
                EndDate := CalcDate('<CM>', StartDate);

            TypePeriode::Quarter:
                EndDate := CalcDate('<CQ>', StartDate);

            TypePeriode::Year:
                EndDate := CalcDate('<CY>', StartDate);
        end;
    end;
}

