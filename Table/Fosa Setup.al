table 50028 "FOSA Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[100])
        {
            //DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;
        }
        field(2; "Account Activation"; Boolean)
        { }
        field(3; "Change Member Details"; Boolean)
        { }
        field(4; "Approve Member Changes"; Boolean)
        { }
        field(5; "Member Approver"; Boolean)
        { }
        field(6; "Member Activator"; Boolean)
        { }
        field(7; "Account Opening Approver"; Boolean)
        { }
        field(8; "Create ATM Applications"; Boolean)
        { }
        field(9; "ATM Approver"; Boolean)
        { }
        field(10; "Create ATM Activation"; Boolean)
        { }
        field(11; "Approve ATM Activation"; Boolean)
        { }
        field(12; "Create Spotcash Application"; Boolean)
        { }
        field(13; "Approve Spotcash Application "; Boolean)
        { }
        field(14; "Deactivate ATM"; Boolean)
        { }
        field(15; "Create Direct Debit Request"; Boolean)
        { }
        field(16; "Approve Direct Debit Request"; Boolean)
        { }
        field(17; "Post Direct Debit"; Boolean)
        { }
        field(18; "Create STO"; Boolean)
        { }
        field(19; "Approve STO"; Boolean)
        { }
        field(20; "Create Share Transfer Request"; Boolean)
        { }
        field(21; "Approve Share Transfer"; Boolean)
        { }
        field(22; "Commitee Approver 1"; Boolean)
        { }
        field(23; "Commitee Approver 2"; Boolean)
        { }
        field(24; "LoanApprover"; Boolean)
        { }
        field(25; GLApprover; Boolean)
        {


        }
        field(26; GLCreator; Boolean)
        { }
        field(27; LoanProductApprover; Boolean)
        { }
        field(28; LoanProductCreator; Boolean)
        { }
        field(29; MemberExitApprover; Boolean)
        {

        }
        field(30; "Dormant Members Activator"; Boolean)
        {

        }

    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}