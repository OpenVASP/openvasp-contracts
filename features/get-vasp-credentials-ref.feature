Feature: Get VASP credentials reference from VASP directory

  In order to get VASP credentials
  As a regular user
  I want to get VASP credentials reference first

  Background:
    Given VASP with identifier "4bd78ccf8ee0" registered in the directory with credentials from "sample-vasp-credentials-1.json"

  @vasp-directory
  Scenario: Requesting credentials reference for a VASP that is registered in the directory
    Given I'm a regular user
      And VASP identifier is "4bd78ccf8ee0"
     When requesting VASP credentials reference
     Then returned VASP credentials reference should be "0xeb93cd7a0e1e29df2f1647e338ad52dded3f0068bb3aee169a341ce8a50a3fd2"
      And returned VASP credentials hash should be "0xeb93cd7a0e1e29df2f1647e338ad52dded3f0068bb3aee169a341ce8a50a3fd2"

  @vasp-directory
  Scenario: Requesting credentials reference for a VASP that is not registered in the directory
    Given I'm a regular user
      And VASP identifier is "22cb5762aae0"
     When requesting VASP credentials reference
     Then returned VASP credentials reference should be empty
      And returned VASP credentials hash should be empty