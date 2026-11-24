@module:api.messages
Feature: 单条留言删除
  按 id 删除单条留言，并覆盖不存在 id、非法 id 以及未强制鉴权的现状风险。

  @generated @layer:e2e @case:FP-004-001
  Scenario: 删除已存在留言后列表不再包含
    Given the test environment is ready
    And the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"待删除留言"}
      """
    And I store the response field $.id as "messageId"
    And I send a DELETE request to "/api/messages/{{var.messageId}}"
    Then the response status should be 200
    When I send a GET request to "/api/messages?limit=10"
    And I decrypt the response payload
    Then the response body at $.total should be "0"

  @generated @layer:api @case:FP-004-002
  Scenario: 删除不存在的留言返回未找到
    Given the test environment is ready
    And the test database is prepared
    When I send a DELETE request to "/api/messages/999999999"
    Then the response status should be 404
    When I send a GET request to "/api/messages?limit=1"
    And I decrypt the response payload
    Then the response body at $.total should be "0"

  @generated @layer:api @case:FP-004-003
  Scenario: 删除非法 id 返回参数错误
    Given the test environment is ready
    And the test database is prepared
    When I send a DELETE request to "/api/messages/abc"
    Then the response status should be 400

  @generated @layer:e2e @case:FP-004-004
  Scenario: 未携带鉴权信息也可删除留言的现状风险
    Given the test environment is ready
    And the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"无鉴权保护留言"}
      """
    And I store the response field $.id as "messageId"
    And I send a DELETE request to "/api/messages/{{var.messageId}}"
    Then the response status should be 200
    When I send a GET request to "/api/messages?limit=10"
    And I decrypt the response payload
    Then the response body at $.total should be "0"
