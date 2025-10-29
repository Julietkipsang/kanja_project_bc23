page 50068 "Sacoo Salespersion Card"
{
    Caption = 'EMPLOYERS DETAIL ';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sacco Salesperson";
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Salesperson ID"; Rec."Salesperson ID")
                {
                    ApplicationArea = All;
                    Caption = 'Code';

                }
                /*field("Station No."; "Station No.")
                {
                    ApplicationArea = All;
                    Caption='Employer NO';

                }*/
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;

                }

                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("City/Towm"; Rec."City/Towm")
                {
                    ApplicationArea = All;
                    Caption = 'City/Town';
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = All;
                }
                field("Phone No"; rec."Phone No")
                {
                    ApplicationArea = All;
                }
            }
            group("")
            {

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("&Create Station Account")
            {
                Caption = '&Create Station Account';
                Image = Payables;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Create Station Account';
                trigger OnAction()
                begin
                    //  Remittance.CreateStationAccount(Rec);
                end;
            }
        }
    }
    var
    // Remittance: Codeunit Remitance;
}