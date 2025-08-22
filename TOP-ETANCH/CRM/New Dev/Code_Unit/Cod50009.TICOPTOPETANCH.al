namespace PHARMATEC.PHARMATEC;

using Microsoft.Projects.Resources.Resource;

codeunit 50009 "TICOP TOP-ETANCH"
{
    [ServiceEnabled]

    procedure login(Nom: Text[50]; pwd: text[50]): Text[50]
    var
        logisticRes: Record "Logistic resource";
    begin
        if (Nom = '') or (pwd = '') then
            exit('-2');
        logisticRes.SetRange(Nom, Nom);
        logisticRes.SetRange(MotDePasse, pwd);

        if logisticRes.FindFirst() then begin
            if logisticRes.Blocked then
                exit(logisticRes.Nom + '|2')
            else
                exit(logisticRes.Nom + '|1');

        end
        else
            exit('-1');
    end;



}
