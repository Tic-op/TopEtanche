/* namespace Top.Top;
using Microsoft.Warehouse.Structure;

codeunit 50007 FindEmplacement
{
    procedure GetEmplacementByBarcode(CodeBarre: Text): Code[20]
    var
        Bin: Record Bin;
    begin
        Bin.Reset();
        Bin.SetRange(CodeBarre, CodeBarre);
        if Bin.FindFirst() then
            exit(Bin.Code)

    end;
}
 */