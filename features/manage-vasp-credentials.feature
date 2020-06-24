Feature: Manage VASP credentials in VASP directory

  In order to keep VASP directory in the actual state
  As a VASP directory operator
  I want my authorized representatives (and only them) to be able to manage VASP credentials in my directory

  Background:
    Given VASP with code "8ccf8ee0" registered in the directory with credentials from "sample-vasp-credentials-1.json"

  @vasp-directory
  Scenario: Inserting VASP credentials as an administrator
    Given I'm an administrator
      And VASP code is "92c26d29"
      And VASP credentials are specified in "sample-vasp-credentials-2.json"
     When inserting VASP credentials
     Then transaction should succeed
      And credentials should be inserted
      And "CredentialsInserted" event should be logged
      And logged credentials reference should be "0x6226d513d4b247e2c1b6b8e66d3043e06670a85b4c8742441ebf2ea92cd23e5d"
      And logged credentials hash should be "0x6226d513d4b247e2c1b6b8e66d3043e06670a85b4c8742441ebf2ea92cd23e5d"
      And logged credentials should be same as in "sample-vasp-credentials-2.json"
  
  @vasp-directory
  Scenario: Reinserting VASP credentials as an administrator
    Given I'm an administrator
      And VASP code is "8ccf8ee0"
      And VASP credentials are specified in "sample-vasp-credentials-1.json"
     When inserting VASP credentials
     Then transaction should fail with a following error: "VASPDirectory: vaspCode has already been registered"

  @vasp-directory
  Scenario: Revoking VASP credentials as an administrator
    Given I'm an administrator
      And VASP code is "8ccf8ee0"
     When revoking VASP credentials
     Then transaction should succeed
      And credentials should be revoked
      And "CredentialsRevoked" event should be logged
      And logged VASP code should be "8ccf8ee0"
      And logged credentials reference should be "0xeb93cd7a0e1e29df2f1647e338ad52dded3f0068bb3aee169a341ce8a50a3fd2"
      And logged credentials hash should be "0xeb93cd7a0e1e29df2f1647e338ad52dded3f0068bb3aee169a341ce8a50a3fd2"

  @vasp-directory
  Scenario: Inserting VASP credentials as a regular user
    Given I'm a regular user
      And VASP code is "92c26d29"
      And VASP credentials are specified in "sample-vasp-credentials-2.json"
     When inserting VASP credentials
     Then transaction should fail with a following error: "AdministratorRole: caller is not the administrator"

  @vasp-directory
  Scenario: Revoking VASP credentials as a regular user
    Given I'm a regular user
      And VASP code is "8ccf8ee0"
     When revoking VASP credentials
     Then transaction should fail with a following error: "AdministratorRole: caller is not the administrator"