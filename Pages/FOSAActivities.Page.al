page 50300 "FOSA Activities"
{
    PageType = CardPart;
    SourceTable = "FOSA Cue";

    layout
    {
        area(content)
        {

            cuegroup(MemberCueContainer)
            {
                Caption = 'Statistics';
                //CuegroupLayout = Wide;
                field("Sacco-Active"; Rec."Sacco-Active")
                {
                    Caption = 'Registered sacco';
                    DrillDownPageId = "Organisation List";
                    ApplicationArea = All;
                }
                field(Fintech; Rec.Fintech)
                {
                    Caption = 'Registered Fintech';
                    DrillDownPageId = "Organisation List";
                    ApplicationArea = All;
                }
                field(Agents; Rec.Agents)
                {
                    Caption = 'Registered Agents';
                    DrillDownPageId = "Organisation List";
                    ApplicationArea = All;
                }
                field("Registered members"; Rec."Registered members")
                {
                    Caption = 'Registered Members';
                    DrillDownPageId = MembersList;
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnOpenPage();
    begin


    end;

    local procedure CalculateAccountBalance()
    var
        Vendor: Record Vendor;
        AccountType: Record "Account Type";
    begin
        AccountType.Reset();
        if AccountType.FindSet() then begin
            repeat
                Vendor.Reset();
                Vendor.SetCurrentKey("Vendor Posting Group");
                Vendor.SetRange("Vendor Posting Group", AccountType.Code);
                if Vendor.FindSet() then begin
                    repeat
                        Vendor.CalcFields("Balance (LCY)");
                        if AccountType.Type = AccountType.Type::Sacco then
                            Rec.TotalOrdinarySavings += Vendor."Balance (LCY)";
                        if AccountType.Type = AccountType.Type::Fintech then
                            Rec.TotalDeposits += Vendor."Balance (LCY)";

                    until Vendor.Next() = 0
                end;
            until AccountType.Next() = 0;
        end;
    end;

    trigger OnAfterGetRecord()
    var
    begin
        CalculateAccountBalance();
    end;

}