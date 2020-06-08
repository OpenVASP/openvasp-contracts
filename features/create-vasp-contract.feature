Feature: Create VASP contract

  In order to register a VASP
  As a VASP representative
  I want to create a VASP contract 

  Scenario Outline: Creating VASP contract
      Given I'm <my-role>
      And owner address is <owner-address>
      And VASP code is <vasp-code>
     When creating a VASP contract
     Then transaction execution result is <transaction-execution-result>
      And transaction failure reason is <transaction-failure-reason>

    Examples:
      | my-role                   | owner-address    | vasp-code      | transaction-execution-result | transaction-failure-reason             |
      | a VASP Index deployer     | non-zero address | not used yet   | success                      | empty                                  |
      | a VASP Index deployer     | non-zero address | already in use | failure                      | VASPIndex: vaspCode is already in use. |
      | a VASP Index deployer     | non-zero address | empty          | failure                      | VASPIndex: vaspCode is empty.          |
      | a VASP Index deployer     | the zero address | not used yet   | failure                      | VASP: owner is the zero address.       |
      | a VASP Index deployer     | the zero address | already in use | failure                      | VASPIndex: vaspCode is already in use. |
      | a VASP Index deployer     | the zero address | empty          | failure                      | VASPIndex: vaspCode is empty.          |
      | not a VASP Index deployer | non-zero address | already in use | failure                      | VASPIndex: vaspCode is already in use. |
      | not a VASP Index deployer | non-zero address | not used yet   | success                      | empty                                  |
      | not a VASP Index deployer | non-zero address | empty          | failure                      | VASPIndex: vaspCode is empty.          |
      | not a VASP Index deployer | the zero address | not used yet   | failure                      | VASP: owner is the zero address.       |
      | not a VASP Index deployer | the zero address | already in use | failure                      | VASPIndex: vaspCode is already in use. |
      | not a VASP Index deployer | the zero address | empty          | failure                      | VASPIndex: vaspCode is empty.          |