page 50039 MembersList
{
    PageType = List;
    //  ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = Members;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(MemberNo; Rec."Kanja Id")
                {
                    ApplicationArea = All;
                    Caption = 'Kanja Id';

                }
                field(saccoMemberNo; Rec.saccoMemberNo)
                {

                }
                field(accountNo; Rec.accountNo)
                {
                    Caption = 'Sacco Account Number';
                }
                field(memberName; Rec.firstName)
                {
                    Caption = 'First Name';

                }
                field(middleName; Rec.middleName)
                {

                }
                field(surnameName; Rec.surnameName)
                {

                }
                field(IdNumber; Rec.IdNumber)
                {

                }
                field(Email; Rec.Email)
                {

                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {

                }
                field(EntityCode; Rec.EntityCode)
                {
                    Caption = 'sacco Code';

                }
                field("Sacco Name"; Rec."Sacco Name")
                {

                }
                field(Gender; Rec.Gender)
                {

                }
                field(DateOfBirth; Rec.DateOfBirth)
                {

                }
                field(kraPin; Rec.kraPin)
                {

                }
                field("Date Registered"; Rec."Date Registered")
                {

                }
                field("Time Regsitered"; Rec."Time Regsitered")
                {
                    Caption = 'Time Registered';
                }
                field(Status; Rec.Status)
                {

                }

                field("Confirmed Terms"; Rec."Confirmed Terms")
                {
                    Caption = 'Confirmed Terms';
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}